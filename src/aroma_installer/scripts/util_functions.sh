# Set up environment and directories
TMPDIR=/dev/tmp
OUTFD="$2"
ZIPFILE="$3"
INSTALLER="$TMPDIR/install"
IMAGES="${INSTALLER}/images"
LOW_LEVEL_PARTITIONS_BACKUP_VOID_AREA="${INSTALLER}/low-level-backups"
mkdir -p $IMAGES $INSTALLER $LOW_LEVEL_PARTITIONS_BACKUP_VOID_AREA || exit 1
chmod 755 "$INSTALLER/scripts/busybox"

# functions:
function busybox() {
    $INSTALLER/scripts/busybox "$@"
}

function consolePrint() {
    local text="$1"
    echo -e "ui_print $text\nui_print" >> /proc/self/fd/$OUTFD
}

function abort() {
    consolePrint "$1"
    rm -rf ${LOW_LEVEL_PARTITIONS_BACKUP_VOID_AREA} ${IMAGES} ${INSTALLER} ${TMPDIR}
    exit 1    
}

function getAromaProp() {
    local prop="$1"
    local propFileName="$2"
    [[ -z "${prop}" || -z "${propFileName}" ]] && abort "Usage: getAromaProp <property> <property_file_name>"
    cat ${propFileName} | grep ${prop} | cut -d '=' -f2 | xargs
}

function amiMountedOrNot() {
    grep -q "$1" /proc/mounts 2>/dev/null
}

function unmountPartitions() {
    for partitions in system system_root vendor odm product prism optics; do
        amiMountedOrNot "${partitions}" && umount /${partitions} 2>/dev/null
    done
}

function findActualBlock() {
    local blockname="$1"
    local block
    [ -z "${blockname}" ] && abort "Usage: findActualBlock <block name, ex: system>"
    for commonDeviceBlocks in /dev/block/bootdevice/by-name /dev/block/by-name /dev/block/platform/*/by-name; do
        [ ! -f "${commonDeviceBlocks}/${blockname}" ] && continue
        [ -f "${commonDeviceBlocks}/${blockname}" ] && block=$(readlink -f "${commonDeviceBlocks}/${blockname}");
        [ -z "${block}" ] || echo "${block}"
    done
}

function installImages() {
    local imageName="$1"
    local blockname="$2"
    if [[ -z "${imageName}" || -z "${blockname}" ]]; then
        echo "Usage: installImages <image file name in the zip, ex: system.img> <block name, ex: system>"
        exit 1
    fi
    case "${imageType}" in
        "sparse")
            unzip -o "${ZIPFILE}" "${imageName}" -d $IMAGES
            consolePrint "Trying to install ${imageName} to ${blockname}..."
            simg2img "${IMAGES}/${blockname}" $(findActualBlock "${blockname}") || abort "Failed to install ${imageName} to ${blockname}!"
            consolePrint "Successfully installed ${imageName} to ${blockname}!"
            rm -rf ${IMAGES}/
        ;;
        "raw")
            consolePrint "Trying to install ${imageName} to ${blockname}..."
            unzip -o "${ZIPFILE}" "${imageName}" -d ${blockname} || abort "Failed to install ${imageName}!"
            consolePrint "Successfully installed ${imageName} to ${blockname}!"
        ;;
    esac
}
# functions: