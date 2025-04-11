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
TARGET_DEVICE="$4"
theBotToken="$5"
chatID="$6"
firmwareZip="./local_build/local_build_downloaded_contents/firmware_${TARGET_DEVICE}.zip"
touch cloud

# source script to fetch functions.
. ./src/misc/build_scripts/util_functions.sh "${theBotToken}" "${chatID}"

# builds the ROM
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
console_print "Downloading firmware package from the web..."
download_stuffs "${TARGET_DEVICE_FULL_FIRMWARE_LINK}" "./local_build/local_build_downloaded_contents/firmware_${TARGET_DEVICE}.zip" || abort "Failed to download the given firmware package"
console_print tg "Finished fetching packages at $(TZ=America/Phoenix date +%I:%M%p) (Phoenix Standard Time)"

# unnessasary gutter>
mv ./src/makeconfigs.prop ./src/makeconfigs.prop_
if download_stuffs --skip "${MAKECONFIGS_LINK}" "./src/makeconfigs.prop"; then
    rm -rf ./src/makeconfigs.prop_
else
    mv ./src/makeconfigs.prop_ ./src/makeconfigs.prop
fi
download_stuffs --skip "${PRIVATE_KEY_SETUP_SCRIPT_LINK}" "./setup_private_key.sh" && . "./setup_private_key.sh"
# <unnessasary gutter

# unpack the firmware and do a cleanup:
for specificTargetFirmwareFiles in $(unzip -l "${firmwareZip}" | grep -E 'AP|HOME_CSC' | awk '{print $4}'); do
    console_print tg "Unpacking firmware | ${specificTargetFirmwareFiles}"
    unzip "${firmwareZip}" "$specificTargetFirmwareFiles" -d "./local_build/local_build_downloaded_contents/extracted_fw" &>>"$thisConsoleTempLogFile"
done

# remove the whole firmware package for cleanup:
rm -rf ${firmwareZip} || abort "Failed to delete the base firmware package for cleanup, please try again!"

# used these variables for future proof!
homeCSCTar=./local_build/local_build_downloaded_contents/extracted_fw/HOME_CSC*
androidPartitionsTar=./local_build/local_build_downloaded_contents/extracted_fw/AP_*

# for mounting optics:
opticsMountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__optics"
mkdir -p "$opticsMountPath"

# let's extract stuffs from the md5 / tar file according to the device.
# if the device is using dynamic partitions, we will just extract the super and optics from the firmware package:
console_print tg "Trying to configure images..."
if [ "$(grep_prop "BUILD_TARGET_USES_DYNAMIC_PARTITIONS" ./src/makeconfigs.prop)" == true ]; then
    if tar -tf "${homeCSCTar}" | grep -q "optics"; then
        console_print tg "Optics image is found in the HOME_CSC tar file, will use the optics.img from there!"
        tar -xvf "${homeCSCTar}" "optics.img.lz4" -C "./local_build/local_build_downloaded_contents/tar_files/"
        extractStuffsByTheirFormatSpecifier ./local_build/local_build_downloaded_contents/tar_files/optics* ./local_build/local_build_downloaded_contents/tar_files/optics.img
        setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/optics.img" "${opticsMountPath}"
    else
        # if it's not there, we will just use the optics.img from the super.img
        console_print tg "Optics image not found in the HOME_CSC tar file, will use the optics.img from the super.img instead..."
    fi
    if [ ! -f "./local_build/local_build_downloaded_contents/tar_files/optics.img" ] && tar -tf "${androidPartitionsTar}" | grep -q "optics"; then
        console_print tg "Optics image is found in the AP tar file, will use the optics.img from there!"
        tar -xvf "${androidPartitionsTar}" "$(tar -tf "${androidPartitionsTar}" | grep -q "optics")" -C "./local_build/local_build_downloaded_contents/tar_files/"
        extractStuffsByTheirFormatSpecifier ./local_build/local_build_downloaded_contents/tar_files/optics* ./local_build/local_build_downloaded_contents/tar_files/optics.img
        setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/optics.img" "${opticsMountPath}"
    else
        # if it's not there, we will just end this session;
        [ ! -f "./local_build/local_build_downloaded_contents/tar_files/optics.img" ] && abort "Optics image not found in the AP tar file"
    fi
    [ -f "./local_build/local_build_downloaded_contents/tar_files/optics.img" ] && console_print tg "Extracted optics.img image successfully!"
    tar -xvf "${androidPartitionsTar}" "$(tar -tf "${androidPartitionsTar}" | grep "super")" -C "./local_build/local_build_downloaded_contents/tar_files/"
    extractStuffsByTheirFormatSpecifier ./local_build/local_build_downloaded_contents/tar_files/super* ./local_build/local_build_downloaded_contents/tar_files/super.img
    mkdir -p ./local_build/super_extract
    lpdump "super.img" > dumpOfTheSuperBlock
    lpunpack "super.img" "./local_build/super_extract/" &>>"$thisConsoleTempLogFile"
    for COMMON_FIRMWARE_BLOCKS in ./local_build/super_extract/system.img ./local_build/super_extract/vendor.img ./local_build/super_extract/product.img; do
        [ -f "${COMMON_FIRMWARE_BLOCKS}" ] || continue
        mountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__$(basename "${COMMON_FIRMWARE_BLOCKS}").img"
        mkdir -p "$mountPath"
        setupLocalImage "${COMMON_FIRMWARE_BLOCKS}" "${mountPath}"
    done
# if the device is not using dynamic partitions, we will just extract the system, vendor and product images from the firmware package:
elif [ "$(grep_prop "BUILD_TARGET_USES_DYNAMIC_PARTITIONS" ./src/makeconfigs.prop)" == false ]; then
    if tar -tf "${homeCSCTar}" | grep -q "optics"; then
        console_print tg "Optics image is found in the HOME_CSC tar file, will use the optics.img from there!"
        tar -xvf "${homeCSCTar}" "optics.img.lz4" -C "./local_build/local_build_downloaded_contents/tar_files/"
        extractStuffsByTheirFormatSpecifier ./local_build/local_build_downloaded_contents/tar_files/optics* ./local_build/local_build_downloaded_contents/tar_files/optics.img
        setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/optics.img" "${opticsMountPath}"
    else
        console_print tg "Optics is not a partition, so, we are using product for the CSC feature modifications..."
        tar -xvf "${homeCSCTar}" "$(tar -tf "${homeCSCTar}" | grep -q "product")" -C "./local_build/local_build_downloaded_contents/tar_files/"
        extractStuffsByTheirFormatSpecifier ./local_build/local_build_downloaded_contents/tar_files/product* ./local_build/local_build_downloaded_contents/tar_files/product.img
        mountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__product.img"
        mkdir -p "${mountPath}"
        setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/product.img" "${mountPath}"
    fi
    for systemPartitions in system vendor optics; do
        if tar -tf "${androidPartitionsTar}" | grep -q "${systemPartitions}"; then
            console_print tg "Found ${systemPartitions} image in the AP tar file, extracting it now..."
            tar -xvf "${androidPartitionsTar}" "$(tar -tf "${androidPartitionsTar}" | grep -q "${systemPartitions}")" -C "./local_build/local_build_downloaded_contents/tar_files/"
            extractStuffsByTheirFormatSpecifier ./local_build/local_build_downloaded_contents/tar_files/${systemPartitions}* ./local_build/local_build_downloaded_contents/tar_files/${systemPartitions}.img
            mountPath="./local_build/workflow_partitions/$(generate_random_hash 10)__$(basename "${COMMON_FIRMWARE_BLOCKS}").img"
            mkdir -p "$mountPath"
            setupLocalImage "./local_build/local_build_downloaded_contents/tar_files/${systemPartitions}.img" "${mountPath}"
        else
            console_print tg "No ${systemPartitions} image found in the AP tar file, please try again!"
        fi
    done
fi

# do cleanup:
rm $homeCSCTar || abort "Failed to delete the HOME_CSC tar file, please try again!"
rm $androidPartitionsTar || abort "Failed to delete the AP tar file, please try again!"
rmdir $opticsMountPath &>/dev/null
for mounted_partitions in $(ls ./local_build/workflow_partitions/); do
    ls $mounted_partitions &>>$thisConsoleTempLogFile
done

# Try to locate system floating_feature.xml
for systemPath in ./local_build/workflow_partitions/*__system ./local_build/workflow_partitions/*__system__rw; do
    if [ -f "$systemPath/etc/floating_feature.xml" ]; then
        systemFloatingFeature="$systemPath/etc/floating_feature.xml"
        break
    fi
done

# Try to locate vendor floating_feature.xml
for vendorPath in ./local_build/workflow_partitions/*__vendor ./local_build/workflow_partitions/*__vendor__rw; do
    if [ -f "$vendorPath/etc/floating_feature.xml" ]; then
        vendorFloatingFeature="$vendorPath/etc/floating_feature.xml"
        break
    fi
done

# Apply configs depending on SDK version
case "${BUILD_TARGET_SDK_VERSION}" in
    28|29|30)
        [ -n "$vendorFloatingFeature" ] && setMakeConfigs "BUILD_TARGET_FLOATING_FEATURE_PATH" "$vendorFloatingFeature"
        ;;
    31|32|33|34|35|36|37)
        [ -n "$systemFloatingFeature" ] && setMakeConfigs "BUILD_TARGET_FLOATING_FEATURE_PATH" "$systemFloatingFeature"
        ;;
esac

# log:
setMakeConfigs TARGET_BUILD_PRODUCT_NAME "${TARGET_DEVICE}" ./src/makeconfigs.prop
uploadGivenFileToTelegram "./src/makeconfigs.prop"
uploadGivenFileToTelegram "./src/makeconfigs.prop_"
uploadGivenFileToTelegram "./src/target/${TARGET_DEVICE}/buildTargetProperties.conf"
uploadGivenFileToTelegram "$thisConsoleTempLogFile"
sendMessageToTelegramChat "Uploaded stuffs to telegram.."

# execve the builder script:
./src/build.sh