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

# args
TARGET_DEVICE_FULL_FIRMWARE_LINK="$1"
MAKECONFIGS_LINK="$2"
PRIVATE_KEY_SETUP_SCRIPT_LINK="$3"

# source script to fetch functions.
source ./src/misc/build_scripts/util_functions.sh

# builds the ROM
sendMessageToTelegramChat "Build started at $(TZ=America/Phoenix date +%d\ %b\ %Y), $(TZ=America/Phoenix date +%I:%M%p) (MST)"
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
console_print "Build started at $(TZ=America/Phoenix date +%d\ %b\ %Y), $(TZ=America/Phoenix date +%I:%M%p) (MST)"
console_print "Available RAM Memory : $(free -h | grep Mem | awk '{print $7}')B"
console_print "Downloading firmware package from the web..."
download_stuffs "${TARGET_DEVICE_FULL_FIRMWARE_LINK}" "../local_build/local_build_downloaded_contents/"
mv ./makeconfigs.prop ./makeconfigs.prop_
if download_stuffs --skip "${MAKECONFIGS_LINK}" "./makeconfigs.prop"; then
    rm -rf ./makeconfigs.prop_
else
    mv ./makeconfigs.prop_ ./makeconfigs.prop
fi
download_stuffs --skip "${PRIVATE_KEY_SETUP_SCRIPT_LINK}" "./setup_private_key.sh" && . "./setup_private_key.sh"
unzip -o ../local_build/local_build_downloaded_contents/*.zip -d ../local_build/local_build_downloaded_contents/extracted_fw
for EXTRACTED_FIRMWARE_FILES in ../local_build/local_build_downloaded_contents/extracted_fw/*.md5; do
    if echo "${EXTRACTED_FIRMWARE_FILES}" | tr '[:upper:]' '[:lower:]' | grep -q -E 'cp|bl|csc_odm_'; then
        console_print "Skipping ${EXTRACTED_FIRMWARE_FILES} because it's useless for the build."
        rm -rf "${EXTRACTED_FIRMWARE_FILES}"
        continue
    fi
    debugPrint "Extracting tar files from $EXTRACTED_FIRMWARE_FILES..."
    tar -xvf "$EXTRACTED_FIRMWARE_FILES" -C ../local_build/local_build_downloaded_contents/tar_files/ || abort "Failed to extract tar files from $EXTRACTED_FIRMWARE_FILES..."
done
console_print "Finished fetching packages at $(TZ=America/Phoenix date +%I:%M%p) (MST)"
console_print "Trying to configure images..."
if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == false ]; then
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
source ./src/monica.conf
source ./src/makeconfigs.prop
cd ./src/