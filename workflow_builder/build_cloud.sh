#!/usr/bin/env bash
#
# Copyright (C) 2025 Luna
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# cd to src bcuz everything is there.
cd ./src/

TARGET_DEVICE=$1
TARGET_DEVICE_FULL_FIRMWARE_LINK=$2
MAKECONFIGS_LINK="$3"
PACK_IMAGE_WITH_TS_FORMAT="$4"
PRIVATE_KEY_SETUP_SCRIPT_LINK="$5"
theBotToken="${TELEGRAM_BOT_TOKEN}"
chatID="${TELEGRAM_CHAT_ID}"
thisConsoleTempLogFile="../local_build/logs/hux_build.log"

# source scripts to override the functions.
source ./misc/build_scripts/util_functions.sh

# test workflow:
if [ "$1" == "--test" ]; then
    sendMessageToTelegramChat "HIAAAAAAAAAA! Workflow works!"
    echo "HUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUEHUE" > let_that_sink_in
    uploadGivenFileToTelegram "let_that_sink_in" && rm let_that_sink_in
    exit 0
fi

# mako mako mako mako those who know💀
for i in system/product/priv-app system/product/etc system/product/overlay \
         system/etc/permissions system/product/etc/permissions custom_recovery_with_fastbootd/ \
         system/etc/init/ tmp/hux/ local_build_downloaded_contents/ local_build_downloaded_contents/extracted_fw \
         local_build_downloaded_contents/tar_files/ workflow_partitions/ workflow_builds; do
    mkdir -p "../local_build/$i"
	debugPrint "Making ../local_build/${i} directories.."
done

# download these and delete them if they were downloaded successfully:
download_stuffs "${MAKECONFIGS_LINK}" "./makeconfigs.prop" && rm -rf ./makeconfigs.prop
download_stuffs "${PRIVATE_KEY_SETUP_SCRIPT_LINK}" "./setup_private_key.sh" && . "./setup_private_key.sh"

# now let's get the variables for modification:
source ./makeconfigs.prop
source ./monika.conf

# device specific customization:
[ -d "./target/${TARGET_DEVICE}" ] || abort "The target device ${TARGET_DEVICE} doesn't exist, please check the name and try again..."

# prepare env.sh -
for dependenciesRequiredForTheJob in zstd zip tar xxd unzip wget curl erofs-utils lz4 gcc python3; do
    if ! command -v $dependenciesRequiredForTheJob; then
        if ! sudo apt install -y $dependenciesRequiredForTheJob; then
            console_print "Error: Failed to install $dependenciesRequiredForTheJob. Aborting this workflow session."
            exit 1;
        fi
    fi
done

# builds the ROM
sendMessageToTelegramChat "Build started at $(date +%d\ %b\ %Y --date='TZ="America/Mountain_Standard_Time"'), $(date +%I:%M%p --date='TZ="America/Mountain_Standard_Time"') (MST)"
sendMessageToTelegramChat "Requested Device: Samsung Galaxy $(deviceCodenameToModel "${TARGET_DEVICE}") (${TARGET_DEVICE}) | test_workflow=true"
console_print "\033[0;31m########################################################################"
console_print "   _  _     _   _            _                _   ___  __"
console_print " _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \/ /"
console_print "|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / "
console_print "|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ "
console_print "  |_||_|   |_| |_|\___/|_|  |_/___\\___/|_| |_|\___//_/\\_\\"
console_print "                                                         "
console_print "########################################################################\033[0m"
console_print "Starting to build HorizonUX on cloud..."
console_print "Build started at $(date +%d\ %b\ %Y --date='TZ="America/Mountain_Standard_Time"'), $(date +%I:%M%p --date='TZ="America/Mountain_Standard_Time"')"
console_print "Available RAM Memory : $(free -h | grep Mem | awk '{print $7}')B"
console_print "Downloading firmware package from the web..."
download_stuffs "${TARGET_DEVICE_FULL_FIRMWARE_LINK}" "../local_build/local_build_downloaded_contents/"
unzip -o ../local_build/local_build_downloaded_contents/*.zip -d ../local_build/local_build_downloaded_contents/extracted_fw
for EXTRACTED_FIRMWARE_FILES in ../local_build/local_build_downloaded_contents/extracted_fw/*.md5; do
    if echo "${EXTRACTED_FIRMWARE_FILES}" | tr '[:upper:]' '[:lower:]' | grep -q -E 'cp|bl|csc_odm_'; then
        console_print "Skipping ${EXTRACTED_FIRMWARE_FILES} because it's useless for the build."
        rm -rf "${EXTRACTED_FIRMWARE_FILES}"
        continue
    fi
    debugPrint "Extracting tar files from $EXTRACTED_FIRMWARE_FILES..."
    ! tar -xvf "$EXTRACTED_FIRMWARE_FILES" -C ../local_build/local_build_downloaded_contents/tar_files/ || abort "Failed to extract tar files from $EXTRACTED_FIRMWARE_FILES..."
done
console_print "Finished fetching packages at $(date +%d\ %b\ %Y --date='TZ="America/Mountain_Standard_Time"'), $(date +%I:%M%p --date='TZ="America/Mountain_Standard_Time"')"
console_print "Trying to mount images..."
if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == false ]; then
    console_print "Unpacking images...."
    for COMMON_FIRMWARE_BLOCKS in system vendor product; do
        lz4 -d -q ../local_build/local_build_downloaded_contents/tar_files/${COMMON_FIRMWARE_BLOCKS}.img.lz4 "${COMMON_FIRMWARE_BLOCKS}.img_raw" || abort "Failed to extract ${COMMON_FIRMWARE_BLOCKS} from the firmware dump, please try againn....."
        mountPath="../local_build/workflow_partitions/$(generate_random_hash 10)__$COMMON_FIRMWARE_BLOCK"
        case "$(getImageFileSystem ${COMMON_FIRMWARE_BLOCKS}.img_raw)" in
            "erofs")
                dirt="${mountPath}__rw"
                mkdir -p $dirt
                sudo fuse.erofs ${COMMON_FIRMWARE_BLOCK}.img $mountPath &>/dev/null
                sudo cp -a --preserve=all $mountPath $dirt/
                setMakeConfigs $(echo "$COMMON_FIRMWARE_BLOCK" | tr '[:lower:]' '[:upper:]')_DIR $dirt ./makeconfigs.prop
            ;;
            "f2fs"|"ext4")
                sudo mount -o rw ../local_build/local_build_downloaded_contents/tar_files/${COMMON_FIRMWARE_BLOCK}.img $mountPath || abort "Failed to mount ${COMMON_FIRMWARE_BLOCK} as rw, please try again..."
                setMakeConfigs $(echo "$COMMON_FIRMWARE_BLOCK" | tr '[:lower:]' '[:upper:]')_DIR $mountPath ./makeconfigs.prop
            ;;
            *)
                abort "Unknown filesystem to tinker with, aborting..."
            ;;
        esac
    done
elif [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == true ]; then
    console_print "Unpacking Super sparse image block...."
    if lz4 -d -q ../local_build/local_build_downloaded_contents/tar_files/super.img.lz4 "super.img.sparse" && simg2img "super.img.sparse" "super.img" && rm -rf "super.img.sparse"; then
        console_print "Successfully unpacked, converted into raw, and deleted the base Super.img from the downloaded source....."
    else
        abort "Failed to unpack the base Super.img from the downloaded source..."
    fi
    lpunpack "super.img" &>$thisConsoleTempLogFile
    lpdump "super.img" > dumpOfTheSuperBlock
    for COMMON_FIRMWARE_BLOCK in vendor system product; do
        lpunpack --partition=$COMMON_FIRMWARE_BLOCK ../local_build/local_build_downloaded_contents/tar_files/super.img || abort "Failed to extract \"${COMMON_FIRMWARE_BLOCK}\" from the super image, please try again..."
        mountPath="../local_build/workflow_partitions/$(generate_random_hash 10)__$COMMON_FIRMWARE_BLOCK"
        case "$(getImageFileSystem ${COMMON_FIRMWARE_BLOCK}.img)" in
            "erofs")
                dirt="${mountPath}__rw"
                mkdir -p $dirt
                sudo fuse.erofs ${COMMON_FIRMWARE_BLOCK}.img $mountPath &>/dev/null
                sudo cp -a --preserve=all $mountPath $dirt/
                setMakeConfigs $(echo "$COMMON_FIRMWARE_BLOCK" | tr '[:lower:]' '[:upper:]')_DIR $dirt ./makeconfigs.prop
            ;;
            "f2fs"|"ext4")
                sudo mount -o rw ../local_build/local_build_downloaded_contents/tar_files/${COMMON_FIRMWARE_BLOCK}.img $mountPath || abort "Failed to mount ${COMMON_FIRMWARE_BLOCK} as rw, please try again..."
                setMakeConfigs $(echo "$COMMON_FIRMWARE_BLOCK" | tr '[:lower:]' '[:upper:]')_DIR $mountPath ./makeconfigs.prop
            ;;
            *)
                abort "Unknown filesystem to tinker with, aborting..."
            ;;
        esac
    done
fi
setMakeConfigs TARGET_BUILD_PRODUCT_NAME ${TARGET_DEVICE} ./makeconfigs.prop
./build.sh
for COMMON_FIRMWARE_BLOCKS in system vendor product optics; do
    for IMAGES in ../local_build/workflow_partitions/*_${COMMON_FIRMWARE_BLOCKS} ../local_build/workflow_partitions/*_${COMMON_FIRMWARE_BLOCKS}__rw; do
        buildImage "${IMAGES}" "/${COMMON_FIRMWARE_BLOCKS}"
    done
done
case "${PACK_IMAGE_WITH_TS_FORMAT}" in
    "tar")
        rm -f "../local_build/workflow_builds/packed_buildImages.tar"
        for IMG_PATH in ../local_build/workflow_builds/*_buildImage.img $thisConsoleTempLogFile; do
            tar --append --file="../local_build/workflow_builds/packed_buildImages.tar" -C "$(dirname "$IMG_PATH")" "$(basename "$IMG_PATH")" && rm -f "$IMG_PATH"
        done
    ;;
    "zstd")
        for f in ../local_build/workflow_builds/*_buildImage.img $thisConsoleTempLogFile; do
            zstd -T0 --ultra -22 "$f" -o "${f}.zst" && rm -f "$f"
        done
    ;;
    "zip")
        zip -r ../local_build/workflow_builds/packed_buildImages.zip ../local_build/workflow_builds/*_buildImage.img $thisConsoleTempLogFile
    ;;
esac
rm -f ../local_build/workflow_builds/*_buildImage.img
sendMessageToTelegramChat "Build completed successfully at $(date +%I:%M%p --date='TZ="America/Mountain_Standard_Time"')"
uploadGivenFileToTelegram "../local_build/workflow_builds/packed_buildImages.${PACK_IMAGE_WITH_TS_FORMAT}" || abort ""
exit 0