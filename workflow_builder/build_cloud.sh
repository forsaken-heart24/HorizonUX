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
cd ../src/

TARGET_DEVICE=$1
TARGET_DEVICE_FULL_FIRMWARE_LINK=$2
MAKECONFIGS_LINK="$3"

# device specific customization:
[ -d "./target/${TARGET_DEVICE}" ] || exit 0;
. "./target/${TARGET_DEVICE}/buildTargetProperties.conf"

# Check if required files exist
download_stuffs "${MAKECONFIGS_LINK}" "./makeconfigs.prop"
for i in "./misc/build_scripts/util_functions.sh" "./makeconfigs.prop" "./monika.conf"; do
    if [ ! -f "$i" ]; then
        echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] [:\e[0;36mABORT\e[0;37m:] -\e[0;31m Can't find $i file, please try again later...\e[0;37m"
        sleep 0.5
        exit 1
    else
		debugPrint "Executing ${i}.."
        . "$i"
    fi
done

# mako mako mako mako those who know💀
for i in system/product/priv-app system/product/etc system/product/overlay \
         system/etc/permissions system/product/etc/permissions custom_recovery_with_fastbootd/ \
         system/etc/init/ tmp/hux/ local_build_downloaded_contents/ local_build_downloaded_contents/extracted_fw \
         local_build_downloaded_contents/tar_files/ workflow_partitions/; do
    mkdir -p "../local_build/$i"
	debugPrint "Making ../local_build/${i} directories.."
done

# functions
function download_stuffs() {
    local link="$1"
    local save_path="$2"
    if [ "$#" -lt '2' ]; then
        warns "Arguments are not enough.." "DOWNLOADER"
        return 1
    fi
    # arg counts
    debugPrint "download_stuffs(): Arguments: $1 $2"
    # arg counts
    # Check if the URL is a raw GitHub content
    if [[ "$link" == *"raw.githubusercontent.com"* ]]; then
        wget --show-progress --progress=bar:force:noscroll -O "$save_path" "$link" &>>$thisConsoleTempLogFile
    else
        curl -L --progress-bar -o "$save_path" "$link" &>>$thisConsoleTempLogFile
    fi
    # Check if the download failed
    if [ "$?" -ne '0' ]; then
        abort "The download failed..."
    fi
    return $?
}

function mountRawImage() {
    local image_path="$1"
    local mount_point="$2"
    if [ "$#" -lt '2' ]; then
        warns "Arguments are not enough. Usage: mountRawImage <image_path> <mount_point>" "mountRawImage"
        return 1
    fi
    if [ ! -f "$image_path" ]; then
        abort "The specified image file does not exist: $image_path"
    fi
    if [ ! -d "$mount_point" ]; then
        debugPrint "Creating mount point directory: $mount_point"
        mkdir -p "$mount_point"
    fi
    debugPrint "Mounting raw image $image_path to $mount_point..."
    if ! mount -o loop "$image_path" "$mount_point"; then
        abort "Failed to mount the image: $image_path"
    fi
    console_print "Successfully mounted $image_path to $mount_point"
    return 0
}
# functions

echo -e "\033[0;31m########################################################################"
echo -e "   _  _     _   _            _                _   ___  __"
echo -e " _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \/ /"
echo -e "|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / "
echo -e "|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ "
echo -e "  |_||_|   |_| |_|\___/|_|  |_/___\\___/|_| |_|\___//_/\\_\\"
echo -e "                                                         "
echo -e "########################################################################\033[0m"
console_print "Starting to build HorizonUX on cloud..."
console_print "Build started at $(date +%I:%M%p) on $(date +%d\ %B\ %Y)"
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
   if ! tar -xvf "$EXTRACTED_FIRMWARE_FILES" -C ../local_build/local_build_downloaded_contents/tar_files/; then
        abort "Failed to extract tar files from $EXTRACTED_FIRMWARE_FILES..."
    fi
done
console_print "Finished fetching packages at $(date +%I:%M%p) on $(date +%d\ %B\ %Y)"
console_print "Trying to mount images..."
if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == false ]; then
    for PARTITIONS in system vendor product; do
        mkdir -p ../local_build/workflow_partitions/${PARTITIONS}
        mountRawImage "../local_build/local_build_downloaded_contents/tar_files/${PARTITIONS}.img" "../local_build/workflow_partitions/${PARTITIONS}/"
    done
elif [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == true ]; then
    mkdir -p ../local_build/workflow_partitions/super
    simg2img ../local_build/local_build_downloaded_contents/tar_files/super.img ../local_build/local_build_downloaded_contents/tar_files/super_raw.img
    for PARTITIONS in optics prism; do
        mkdir -p ../local_build/workflow_partitions/${PARTITIONS}
        mountRawImage "../local_build/local_build_downloaded_contents/tar_files/${PARTITIONS}.img" "../local_build/workflow_partitions/${PARTITIONS}/"
    done
fi