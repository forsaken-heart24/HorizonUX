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


# args | exec to get the fucnctions and variables
TARGET_DEVICE_FULL_FIRMWARE_LINK="$1"
MAKECONFIGS_LINK="$2"
PRIVATE_KEY_SETUP_SCRIPT_LINK="$3"
TARGET_DEVICE="$4"
theBotToken="$5"
chatID="$6"
. ./src/misc/build_scripts/util_functions.sh "${theBotToken}" "${chatID}"
. ./src/target/${TARGET_DEVICE}/buildTargetProperties.conf
firmwareZip="./local_build/local_build_downloaded_contents/firmware_${TARGET_DEVICE}.zip"
extractedOptics="./local_build/local_build_downloaded_contents/tar_files/optics.img.lz4"
opticsMountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__optics"
mkdir -p "$opticsMountPath"
touch cloud

# banner and etc here:
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

# setup custom makeconfigs.prop file if can:
mv ./src/makeconfigs.prop ./src/makeconfigs.prop_
if download_stuffs --skip "${MAKECONFIGS_LINK}" "./src/makeconfigs.prop"; then
    rm -rf ./src/makeconfigs.prop_
else
    mv ./src/makeconfigs.prop_ ./src/makeconfigs.prop
fi

# setup setup_private_key.sh to sign the ROM with a private key used by an individual if available
download_stuffs --skip "${PRIVATE_KEY_SETUP_SCRIPT_LINK}" "./setup_private_key.sh" && . "./setup_private_key.sh"

# unpack the fw package and delete it to save space
for specificTargetFirmwareFiles in $(unzip -l "${firmwareZip}" | grep -E 'AP|HOME_CSC' | awk '{print $4}'); do
    console_print tg "Unpacking firmware | ${specificTargetFirmwareFiles}"
    unzip "${firmwareZip}" "$specificTargetFirmwareFiles" -d "./local_build/local_build_downloaded_contents/extracted_fw" &>>"$thisConsoleTempLogFile"
done
rm -f "${firmwareZip}" || abort "Failed to delete the base firmware package for cleanup, please try again!"

# use these variable to identify the HOME_CSC and AP_ file:
homeCSCTar=$(find "./local_build/local_build_downloaded_contents/extracted_fw/" -type f -name 'HOME_CSC_*.tar.md5' | head -n1)
androidPartitionsTar=$(find "./local_build/local_build_downloaded_contents/extracted_fw/" -type f -name 'AP*.tar.md5' | head -n1)

# let's extract optics / product and then proceed to extract super / system
console_print "Extracting images from the firmware archive..."
tar -xf "${homeCSCTar}" 'optics.img.lz4' -C ./local_build/local_build_downloaded_contents/tar_files/ &>/dev/null
tar -xf "${homeCSCTar}" 'product.img.lz4' -C ./local_build/local_build_downloaded_contents/tar_files/ &>/dev/null
tar -xf "${androidPartitionsTar}" 'super.img.lz4' -C ./local_build/local_build_downloaded_contents/tar_files/ &>/dev/null
for androidPartitions in system vendor; do
    tar -xf "${androidPartitionsTar}" "${androidPartitions}.img.lz4" -C ./local_build/local_build_downloaded_contents/tar_files/ &>/dev/null
done

# take the info dump, push it to dumpOfTheSuperBlock and then extract the super.img
# this is only for dynamic partitions, if the device uses static partitions, the if statement will skip this step
if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == "true" ]; then
    console_print "Treble Device w/ Dynamic Partitions detected!"
    console_print "Extracting super.img and other images from the firmware archive..."
    mkdir -p ./local_build/super_extract
    lpdump "./local_build/local_build_downloaded_contents/tar_files/super.img" > ./dumpOfTheSuperBlock
    lpunpack "./local_build/local_build_downloaded_contents/tar_files/super.img" "./local_build/super_extract/" &>>$thisConsoleTempLogFile
    for COMMON_FIRMWARE_BLOCKS in ./local_build/super_extract/*.img; do 
        echo "$(basename "${COMMON_FIRMWARE_BLOCKS}")" | grep -qE "system.img|vendor.img|product.img" || continue
        mountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__$(basename "${COMMON_FIRMWARE_BLOCKS}" .img)"
        mkdir -p "$mountPath"
        setupLocalImage "${COMMON_FIRMWARE_BLOCKS}" "${mountPath}"
    done
# if the device uses static partitions, we will mount the extracted optics.img and product.img
# and then extract the rest of the images from the AP tar file
elif [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == "false" ]; then
    for staticPartitions in system vendor; do
        console_print "Extracting ${staticPartitions}, from this legacy firmware archive..."
        mountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__${staticPartitions}"
        mkdir -p "$mountPath"
        setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/${staticPartitions}.img.lz4" "${mountPath}"
    done
else
    abort "Unable to determine if the device uses dynamic partitions or not!"
fi

# TODO: Cleanup:
rm -f "${homeCSCTar}" || abort "Failed to delete the HOME_CSC tar file, please try again!"
rm -f "${androidPartitionsTar}" || abort "Failed to delete the AP tar file, please try again!"
rmdir "$opticsMountPath" &>/dev/null

# for logging:
for mounted_partitions in ./local_build/workflow_partitions/*/; do
    ls "$mounted_partitions" &>>"$thisConsoleTempLogFile"
done

# now the build.sh will handle the rest of the process, so we will just call it in yml file.