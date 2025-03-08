# Check if the dependency exists inside the ZIP file
function check_if_dependencies_exist() {
    local file="$1"
    unzip -l "${ZIPFILE}" | grep -q "${file}"
    return $?
}

# Unpack the file from the ZIP archive
function unpack_the_dependencies() {
    local file="$1"
    if check_if_dependencies_exist "$file"; then
        unzip -o "$ZIPFILE" "$file" -d "${INSTALLER}/" || abort "- Failed to unpack the dependency: $file."
        return 0
    else
        abort "- The system file in the zip archive is missing. Please re-download the ROM package and try again."
    fi
}

# Print a message to the recovery log
function print() {
    local text="$1"
    echo -e "ui_print $text\nui_print" >> /proc/self/fd/$OUTFD
}

# Check if a file or directory is mounted
function they_are_mounted_or_not() {
    grep -q " $(readlink -f "$1") " /proc/mounts 2>/dev/null
    return $?
}

# Abort with an error message, clean up, and exit
function abort() {
    local text="$1"
    print "$text"
    rm -rf "$TMPDIR" "$INSTALLER"
    exit 1    
}

# Find the real block device (either a device or a kernel block)
function find_real_block() {
    local arguments="$(echo $1 | string_case --lower)"
    local block_name="$2"
    local linked_block real_block

    if [[ -z "$block_name" || -z "$arguments" ]]; then
        return 1
    fi

    case "$arguments" in 
        --device)
            linked_block=$(find /dev/block/*/by-name -name "$block_name" -print -quit)
            ;;
        --kernel)
            linked_block=$(find /sys/* -name "$block_name" -print -quit)
            ;;
    esac

    if [[ -z "$linked_block" ]]; then
        print "- Weird device. Please report this to the developer..."
        abort ""
    fi

    real_block=$(readlink -f "$linked_block")
    echo "${real_block:-$linked_block}"
}

# Install a disk image on a specific block
function install_the_disk_image() {
    local image_name="$1"
    local block_name="$2"
    local image_name_blah="${image_name%%.*}"

    if [[ -z "$image_name" || -z "$block_name" ]]; then
        print "- Insufficient information. The zip might be corrupted."
        abort "  Error code: 0x696d6167655f6e616d65206e6f7420736574"
    fi

    unpack_the_dependencies "$image_name" || abort " - The file wasn't properly extracted, please re-install or reboot into recovery and try again."

    local real_block=$(find_real_block --device "$block_name")
    if [[ -z "$real_block" ]]; then
        print "- Failed to gather sufficient information. An unknown error occurred."
        abort "  Error code: 0x7265616c5f626c6f636b206e6f7420736574"
    fi

    case "$(get_rom_prop SHIPPED_AS_WHAT)" in
        "tar")
            tar -xf "${INSTALLER}/${image_name}" -C "${INSTALLER}/" || abort "- Failed to extract tar image."
            ;;
        "sparse")
            simg2img "${INSTALLER}/${image_name}" "${real_block}" || abort "- Failed to convert sparse image."
            ;;
        "raw")
            cp "${INSTALLER}/${image_name}" "${real_block}" || abort "- Failed to copy raw image."
            ;;
        *)
            abort " - Unknown image type detected, exiting..."
            ;;
    esac
}

# Get ROM property value
function get_rom_prop() {
    local variable_name="$1"
    local value=$(grep "$variable_name" "${INSTALLER}/rom.prop" | cut -d '=' -f 2)
    if [[ -z "$variable_name" ]]; then
        print " - Missing argument for property query."
        return 1
    fi
    if [[ -z "$value" || "$value" == "NULL" ]]; then
        print " - No value found for '$variable_name' or it is NULL."
        return 2
    fi
    case "$(echo "${value}" | tr '[:upper:]' '[:lower:]')" in 
        true) return 0 ;;
        false) return 1 ;;
        *) echo "$value" ;;
    esac
}

function install_low_level_images() {
    local image_name="$1"
    local md_five_hash="$2"
    local image_name_blah=${image_name%%.*}
    local real_block=$(find_real_block --device "$image_name_blah")
    unpack_the_dependencies "$image_name" || abort " - The file wasn't properly extracted, please re-install or reboot into recovery and try again."
    local the_dawn_of_the_west=$(echo "$image_name" | wc -c)
    local the_dawn_of_the_east=$(($image_name_blah_zap_zap - $the_dawn_of_the_west))
    local image_name_zap_zap=$(md5sum $image_name | xargs | wc -c)
    local image_name_blah_blah=$(md5sum $image_name | xargs | cut -c 1-$the_dawn_of_the_east)
    # let's backup the current blob to avoid bricks as possible.
    cp $real_block $LOW_LEVEL_PARTITIONS_BACKUP_VOID_AREA
    if [[ -z "$real_block" ]]; then
        print "- Failed to gather sufficient information. An unknown error occurred."
        abort "  Error code: 0x7265616c5f626c6f636b206e6f7420736574"
    fi
    if [ "${md_five_hash}" == "${image_name_blah_blah}" ]; then
        if ! cp ${INSTALLER}/${image_name} ${real_block}; then
            abort " - Failed to flash low-level parts of your phone, please re-download the zip again."
        fi
    else
        abort " - Aborting the installation of $image_name_blah because the given verification hash doesn't seem to be the same..."
    fi
}

function string_case() {
    local smile="$(echo $1 | tr '[:upper:]' '[:lower:]')"
    local string="$2"
    case $smile in
        --lower*|-l*)
            echo "$string" | tr '[:upper:]' '[:lower:]'
        ;;
        --upper*|-u*)
            echo "$string" | tr '[:lower:]' '[:upper:]'
        ;;
        *)
            echo "$string"
        ;;
    esac
}

function manage_mounts() {
    if echo $1 | grep -q where; then
        [ -z "$2" ] || mount | grep $2 | head -n 1 | awk '{print $3}'
    elif echo $1 | grep -q alive?; then
        [ -z "$2" ] || mount | grep -q $2
    elif echo $1 | grep -q mount-it; then
        SLOT=$(grep_cmdline androidboot.slot_suffix)
        if [ -z $SLOT ]; then
            SLOT=$(grep_cmdline androidboot.slot)
            [ -z $SLOT ] || SLOT=_${SLOT}
        fi
        [ "$SLOT" = "normal" ] && unset SLOT
        if mount | grep -q $2; then
            mount -o rw,remount $2
        fi
    fi
}

function setup_recovery_command_file() {
    if ! $hosts_were_backed_up; then
        echo "--data_resizing" > /cache/recovery/command
    else
        echo "--delete_apn_changes" > /cache/recovery/command
    fi
    chown 1000 /cache/recovery/command
    chgrp 1000 /cache/recovery/command
    chmod 644 /cache/recovery/command
}

# Set up environment and directories
export TMPDIR=/dev/tmp
export OUTFD="$2"
export ZIPFILE="$3"
export INSTALLER="$TMPDIR/install"
export LOW_LEVEL_PARTITIONS_BACKUP_VOID_AREA="${INSTALLER}/low-level-backups"
export IMAGES="${INSTALLER}/"
mkdir -p $INSTALLER $TMPDIR $LOW_LEVEL_PARTITIONS_BACKUP_VOID_AREA 2>/dev/null
. ${INSTALLER}/rom.prop

# let's run the installer with arguments...
. ${INSTALLER}/install.sh --inject-magisk $OUTFD $ZIPFILE