#!/system/bin/sh

daridaridaridari="/dev/tmp/install/daridaridaridari"
DEFAULT_LOG_FILE_PATH="/dev/tmp/Horizon/logs/teto___horizonROMInstaller.log"
DEFAULT_BACKUP_DIR="/dev/tmp/install/low-level-backups"
IMAGE__=$(cat ${daridaridaridari} | awk '{print $3}')
BLOCKFILEPATH__=$(cat ${daridaridaridari} | awk '{print $7}')
OUTFD__=$(cat ${daridaridaridari} | awk '{print $15}')
ZIPFILE=$(cat ${daridaridaridari} | awk '{print $20}')
WRITE_DEBUG_MESSAGES_TO_CONSOLE=$(cat ${daridaridaridari} | awk '{print $23}')
createSnapshot=$(cat ${daridaridaridari} | awk '{print $26}')
scriptLaunchArguments="$(echo "$@" | tr '[:upper:]' '[:lower:]')"

# We are using this approach because, in general, these are useless.
function throwMessagesToConsole() {
    local getPreviousReturnState=$?
    [ "${WRITE_DEBUG_MESSAGES_TO_CONSOLE}" == "0" ] && echo -ne "ui_print manage-firmware: $1\nui_print\n" >> ${OUTFD__}
    return $getPreviousReturnState
}

# well, yeah. But these are important tho
function abort() {
    echo -ne "ui_print manage-firmware: $1\nui_print\n" >> ${OUTFD__}
    echo "manage-firmware: %s" >> ${DEFAULT_LOG_FILE_PATH}
    exit 1;
}

# don't mind the variable bro
function verifyMD5Hash() {
    local tralalelo_tralala="$1"
    local bombardiro_crocodilo="$2"
    [ "$(md5sum ${tralalelo_tralala} | awk '{print $1}')" == "$(cat ${bombardiro_crocodilo})" ] && return 0;
    return 1;
}

# the main reason is to check OUTFD is that i dont want to check it everytime when i need to print something on the screen
if [ ! -f "${OUTFD__}" ]; then
    echo "manage-firmware: OUTFD path not found or undefined, i guess the call wasn't marked into the "daridaridaridari" file";
    exit 1;
fi

# i actually want this to get logged.
throwMessagesToConsole "######################### markInstallTypeAndBlock() ###################################"
cat ${daridaridaridari} >> ${DEFAULT_LOG_FILE_PATH}

# ts shit grabs args / parameters from the binary and does the requested job.
# shouldve gone with C but, this wrapper script is enough and a bit safe.
# one of the main reason i used so many commands because i hope atleast one command could change everything.
case "$scriptLaunchArguments" in 
    # restores the requested block if the md5 hash matches the file.
    "--restore")
        if verifyMD5Hash ${DEFAULT_BACKUP_DIR}/${IMAGE__} ${DEFAULT_BACKUP_DIR}/${IMAGE__}.md5sum; then
            if cat ${DEFAULT_BACKUP_DIR}/${IMAGE__} > ${BLOCKFILEPATH__} || cp ${DEFAULT_BACKUP_DIR}/${IMAGE__} ${BLOCKFILEPATH__} || dd if=${IMAGE__} of=${BLOCKFILEPATH__} bs=1M; then
                throwMessagesToConsole "Successfully restored ${IMAGE__}!"
            else
                throwMessagesToConsole "That's it, you are cooked frfr"
                abort "Failed to restore ${IMAGE__}"
            fi
        else
            abort "That's it, you are cooked frfr"
        fi
    ;;
    # takes the backup of the requested block and generates a md5 hash alongside it for verification.
    "--backup")
        if cp ${BLOCKFILEPATH__} ${DEFAULT_BACKUP_DIR}; then
            throwMessagesToConsole "Backed up $IMAGE__"
            md5sum ${BLOCKFILEPATH__} > ${IMAGE__}.md5sum
        else
            abort "Failed to backup $IMAGE__"
        fi
    ;;
    # marked snapshot, only takes the requested partition.
    "--snapshot")
        if [ "$createSnapshot" == "1" ]; then
            if cat ${BLOCKFILEPATH__} > ${DEFAULT_BACKUP_DIR}/${IMAGE__} || cp ${BLOCKFILEPATH__} ${DEFAULT_BACKUP_DIR}/${IMAGE__} || dd if=${BLOCKFILEPATH__} of=${DEFAULT_BACKUP_DIR}/${IMAGE__} bs=1M; then
                md5sum ${BLOCKFILEPATH__} > ${BLOCKFILEPATH__}/${IMAGE__}.md5sum
                throwMessagesToConsole "Successfully took a snap of ${IMAGE__}.."
            else 
                abort "Failed to take snapshots, please re-install the package or try a different recovery image.."
            fi
        else 
            echo -ne "ui_print manage-firmware: Snapshots feature is disabled in this installer...\nui_print\n" >> ${OUTFD__}
        fi
    ;;
    # Snapshot restore is not marked and we are just going to place em and let it get installed somehow..
    "--snapshot_restore")
        if [ "$createSnapshot" == "1" ]; then
            for image_files in ${DEFAULT_BACKUP_DIR}/*.img; do
                if verifyMD5Hash ${image_files}; then
                    if cat ${DEFAULT_BACKUP_DIR}/${image_files} > ${BLOCKFILEPATH__} || cp ${DEFAULT_BACKUP_DIR}/${image_files} ${BLOCKFILEPATH__} || dd if=${DEFAULT_BACKUP_DIR}/${image_files} of=${BLOCKFILEPATH__} bs=1M; then
                        throwMessagesToConsole "Successfully restore a snap of ${image_files}.."
                    else 
                        abort "Failed to restore snapshots, please re-install the package or try a different recovery image.."
                    fi
                fi
            done
        else 
            echo -ne "ui_print manage-firmware: Snapshots feature is disabled in this installer...\nui_print\n" >> ${OUTFD__}
        fi
    ;;
esac

# $? = current state, can be anything, 0 = success and anything beyond or below it are failure status.
STATUS=$?
throwMessagesToConsole "######################### markInstallTypeAndBlock() ###################################"
exit $STATUS