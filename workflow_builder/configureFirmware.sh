#!/usr/bin/env bash
#
# Copyright (C) 2025 Luna <luna.realm.io.bennett24@outlook.com>
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
TARGET_DEVICE="$4"
theBotToken="$5"
chatID="$6"
firmwareZip="./local_build/local_build_downloaded_contents/firmware_${TARGET_DEVICE}.zip"
touch cloud

. ./src/misc/build_scripts/util_functions.sh "${theBotToken}" "${chatID}"
. ./src/target/${TARGET_DEVICE}/buildTargetProperties.conf

sendMessageToTelegramChat "Build started at $(TZ=America/Phoenix date +%d\ %b\ %Y), $(TZ=America/Phoenix date +%I:%M%p) (Phoenix Standard Time)"
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
console_print "Build started at $(TZ=America/Phoenix date +%d\ %b\ %Y), $(TZ=America/Phoenix date +%I:%M%p) (Phoenix Standard Time)"
console_print "Available RAM Memory : $(free -h | grep Mem | awk '{print $7}')B"

echo "${TARGET_DEVICE_FULL_FIRMWARE_LINK}" | grep -qE "samfw|samfwpremium" || abort "Only samfw.com firmware packages are supported!"
console_print "Downloading firmware package from the web..."
download_stuffs "${TARGET_DEVICE_FULL_FIRMWARE_LINK}" "${firmwareZip}" || abort "Failed to download the given firmware package"
console_print tg "Finished fetching packages at $(TZ=America/Phoenix date +%I:%M%p) (Phoenix Standard Time)"

mv ./src/makeconfigs.prop ./src/makeconfigs.prop_
if download_stuffs --skip "${MAKECONFIGS_LINK}" "./src/makeconfigs.prop"; then
    rm -rf ./src/makeconfigs.prop_
else
    mv ./src/makeconfigs.prop_ ./src/makeconfigs.prop
fi
download_stuffs --skip "${PRIVATE_KEY_SETUP_SCRIPT_LINK}" "./setup_private_key.sh" && . "./setup_private_key.sh"

for specificTargetFirmwareFiles in $(unzip -l "${firmwareZip}" | grep -E 'AP|HOME_CSC' | awk '{print $4}'); do
    console_print tg "Unpacking firmware | ${specificTargetFirmwareFiles}"
    unzip "${firmwareZip}" "$specificTargetFirmwareFiles" -d "./local_build/local_build_downloaded_contents/extracted_fw" &>>"$thisConsoleTempLogFile"
done

rm -rf ${firmwareZip} || abort "Failed to delete the base firmware package for cleanup, please try again!"

homeCSCTar=$(find "./local_build/local_build_downloaded_contents/extracted_fw/" -type f -name 'HOME_CSC_*.tar.md5' | head -n1)
androidPartitionsTar=$(find "./local_build/local_build_downloaded_contents/extracted_fw/" -type f -name 'AP*.tar.md5' | head -n1)

opticsMountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__optics"
mkdir -p "$opticsMountPath"
console_print tg "Trying to configure images..."
if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == "true" ]; then
    if extract_partition_image "${homeCSCTar}" "optics" "./local_build/local_build_downloaded_contents/tar_files/optics.img"; then
        setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/optics.img" "${opticsMountPath}"
    elif extract_partition_image "${androidPartitionsTar}" "optics" "./local_build/local_build_downloaded_contents/tar_files/optics.img"; then
        setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/optics.img" "${opticsMountPath}"
    else
        abort "Failed to extract optics image!"
    fi

    tar -xvf "${androidPartitionsTar}" "$(tar -tf "${androidPartitionsTar}" | grep "super")" -C "./local_build/local_build_downloaded_contents/tar_files/"
    lz4 -d ./local_build/local_build_downloaded_contents/tar_files/$(tar -tf "${androidPartitionsTar}" | grep "super") ./local_build/local_build_downloaded_contents/tar_files/super.img || abort "Failed to decompress super.img"
    mkdir -p ./local_build/super_extract
    lpdump "super.img" > dumpOfTheSuperBlock
    lpunpack "super.img" "./local_build/super_extract/" &>>"$thisConsoleTempLogFile"

    for COMMON_FIRMWARE_BLOCKS in ./local_build/super_extract/system.img ./local_build/super_extract/vendor.img ./local_build/super_extract/product.img; do
        [ -f "${COMMON_FIRMWARE_BLOCKS}" ] || continue
        mountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__$(basename "${COMMON_FIRMWARE_BLOCKS}").img"
        mkdir -p "$mountPath"
        setupLocalImage "${COMMON_FIRMWARE_BLOCKS}" "${mountPath}"
    done

elif [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == "false" ]; then
    if extract_partition_image "${homeCSCTar}" "optics" "./local_build/local_build_downloaded_contents/tar_files/optics.img"; then
        setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/optics.img" "${opticsMountPath}"
    else
        console_print tg "Optics is not a partition, falling back to product..."
        extract_partition_image "${homeCSCTar}" "product" "./local_build/local_build_downloaded_contents/tar_files/product.img"
        mountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__product.img"
        mkdir -p "${mountPath}"
        setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/product.img" "${mountPath}"
    fi

    for systemPartitions in system vendor optics; do
        if extract_partition_image "${androidPartitionsTar}" "${systemPartitions}" "./local_build/local_build_downloaded_contents/tar_files/${systemPartitions}.img"; then
            mountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__${systemPartitions}.img"
            mkdir -p "$mountPath"
            setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/${systemPartitions}.img" "${mountPath}"
        else
            console_print tg "No ${systemPartitions} image found in the AP tar file."
        fi
    done
fi

rm -f "${homeCSCTar}" || abort "Failed to delete the HOME_CSC tar file, please try again!"
rm -f "${androidPartitionsTar}" || abort "Failed to delete the AP tar file, please try again!"
rmdir "$opticsMountPath" &>/dev/null

for mounted_partitions in ./local_build/workflow_partitions/*/; do
    ls "$mounted_partitions" &>>"$thisConsoleTempLogFile"
done
