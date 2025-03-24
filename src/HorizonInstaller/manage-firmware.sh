#!/system/bin/sh

DEBUG="no"
daridaridaridari="/dev/tmp/install/daridaridaridari"
DEFAULT_BACKUP_DIR="/dev/tmp/install/low-level-backups"
## Currently Installing: %s To Requested Block: %s | shippedAs: %s | OUTFD Constucted Path: %s
IMAGE__=$(cat ${daridaridaridari} | awk '{print $3}')
BLOCKFILEPATH__=$(cat ${daridaridaridari} | awk '{print $7}')
OUTFD__=$(cat ${daridaridaridari} | awk '{print $15}')

# We are using this approach because, in general, these are useless.
function throwMessagesToConsole() {
    [[ -f "${OUTFD__}" && "${DEBUG}" == "yes" ]] && echo -ne "ui_print manage-firmware: $1\nui_print\n" >> ${OUTFD__}
}

# well, yeah. But these are important tho
function abort() {
    [ -f "${OUTFD__}" ] && echo -ne "ui_print manage-firmware: $1\nui_print\n" >> ${OUTFD__}
    exit 1;
}

# don't mind the variable bro
function verifyMD5Hash() {
    local bombardiro="$1"
    local tralalelo="$2"
    [ "$(md5sum ${bombardiro} | awk '{print $1}')" == "$(cat ${tralalelo})" ] && return 0;
    return 1;
}

# ts shit grabs args / parameters from the binary and does the requested job.
# shouldve gone with C but, this wrapper script is enough and a bit safe.
case "$(echo "$@" | tr '[:upper:]' '[:lower:]')" in 
    "--restore")
        for i in ${DEFAULT_BACKUP_DIR}/${IMAGE__}; do
            if verifyMD5Hash ${i} ${i}.md5sum; then
                if cat ${i} > ${BLOCKFILEPATH__} || cp ${i} ${BLOCKFILEPATH__} || dd if=${IMAGE__} of=${BLOCKFILEPATH__} bs=1M status=progress; then
                    throwMessagesToConsole "Successfully restored ${IMAGE__}!"
                else
                    throwMessagesToConsole "That's it, you are cooked frfr"
                    abort "Failed to restore ${IMAGE__}"
                fi
            else
                throwMessagesToConsole "That's it, you are cooked frfr"
            fi
        done
    ;;
    "--backup")
        if cp ${BLOCKFILEPATH__} ${DEFAULT_BACKUP_DIR}; then
            throwMessagesToConsole "Backed up $IMAGE__"
            md5sum ${BLOCKFILEPATH__} > ${IMAGE__}.md5sum
        else
            abort "Failed to backup $IMAGE__"
        fi
    ;;
    *)
        echo "$@ is undefined"
    ;;
esac