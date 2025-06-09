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
function grep_prop() {
    [[ -z "$1" || -z "$2" || ! -f "$2" ]] && return 1
    grep -E "^$1=" "$2" 2>>"$thisConsoleTempLogFile" | cut -d '=' -f2- | tr -d '"'
}

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
    local imageType="$3"
    [[ -z "${imageName}" || -z "${blockname}" ]] && abort "Usage: installImages <image file name in the zip, ex: system.img> <block name, ex: system>"
    case "${imageType}" in
        "sparse")
            unzip -o "${ZIPFILE}" "${imageName}" -d $IMAGES
            consolePrint "Trying to install ${imageName} to ${blockname}..."
            simg2img "${IMAGES}/${blockname}.img" $(findActualBlock "${blockname}") || abort "Failed to install ${imageName} to ${blockname}!"
            consolePrint "Successfully installed ${blockname}!"
            rm -rf ${IMAGES}/
        ;;
        "raw")
            consolePrint "Trying to install ${imageName} to ${blockname}..."
            unzip -o "${ZIPFILE}" "${imageName}" -d ${blockname} || abort "Failed to install ${imageName}!"
            consolePrint "Successfully installed ${blockname}!"
        ;;
    esac
}

function checkBuildID() {
    local buildIDFromZIp="$1"
    local aromaTraces="$(echo /tmp/checkbox* | head -n 1)"
    if [ -f "${aromaTraces}" ]; then
    amiMountedOrNot "/system" || mount /system
    amiMountedOrNot "/system_root" || mount /system_root
    local systemPath=$([ -f "/system/system/build.prop" ] && echo "/system/system" || [ -f "/system_root/system/build.prop" ] && echo "/system_root/system")
    [ -z "${systemPath}" ] && abort "Failed to retrieve the previous build id, please don't wipe system or vendor before the installation."
    local currentSystemBuildID=$(grep_prop "ro.horizonux.buildid" "${systemPath}/build.prop")
    if [ ${currentSystemBuildID} -eq ${buildIDFromZIp} ]; then
        consolePrint "You are not supposed to flash this on the same build id, but it's not a problem, just ignore."
    elif [ ${buildIDFromZIp} -ge ${currentSystemBuildID} ]; then
        abort "Failed to run the installer instance due to the buiid id from zip is greater than the current installed system's build id."
    fi
}
# functions: