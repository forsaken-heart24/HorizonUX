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

# Arguments
TARGET_DEVICE_FULL_FIRMWARE_LINK="$1"
theBotToken="$2"
chatID="$3"
extractKernel="$4"
userToTag="$5"
topicID="$6"
compressionLevel="$7"

# Paths
firmwareZip="./local_build/downloads/firmware.zip"
thisConsoleTempLogFile="./local_build/logs/hux_build.log"
extrdDir="./local_build/extrd"
cmprsDir="./local_build/cmprs"
mkdir -p "${extrdDir}" "${cmprsDir}" "./local_build/downloads" "./local_build/logs"

# Source script to fetch functions
. ./src/misc/build_scripts/util_functions.sh "${theBotToken}" "${chatID}" ${topicID}

# Header
console_print "\033[0;31m########################################################################"
console_print "   _  _     _   _            _                _   ___  __"
console_print " _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \/ /"
console_print "|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / "
console_print "|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ "
console_print "  |_||_|   |_| |_|\___/|_|  |_/___\\___/|_| |_|\___//_/\\_\\"
console_print "########################################################################\033[0m"
console_print tg "Firmware Dump started at $(TZ=America/Phoenix date '+%d %b %Y, %I:%M%p') (Phoenix Time) | Requested By ${userToTag}"

# Download firmware
console_print "Downloading firmware package..."
download_stuffs "${TARGET_DEVICE_FULL_FIRMWARE_LINK}" "${firmwareZip}" || abort "Failed to download firmware."
console_print tg "Firmware package finished downloading at $(TZ=America/Phoenix date '+%I:%M%p')"

# Unzip AP and HOME_CSC
for specificFirmwareFile in $(unzip -Z1 "${firmwareZip}" | grep -E 'AP|HOME_CSC'); do
    console_print tg "Unpacking firmware: ${specificFirmwareFile}"
    unzip -q "${firmwareZip}" "${specificFirmwareFile}" -d "${extrdDir}" >> "$thisConsoleTempLogFile" || abort "Failed to extract $specificFirmwareFile"
done
rm -f "${firmwareZip}" >> "$thisConsoleTempLogFile" || abort "Failed to delete ${firmwareZip}"

# Find real paths
HOME_CSC=$(find "${extrdDir}" -type f -name 'HOME_CSC_*.tar.md5' | head -n1)
AP=$(find "${extrdDir}" -type f -name 'AP*.tar.md5' | head -n1)
[ -f "$HOME_CSC" ] || abort "HOME_CSC archive not found!"
[ -f "$AP" ] || abort "AP archive not found!"

# Extract HOME_CSC content
if tar -tf "$HOME_CSC" | grep -q "optics"; then
    console_print "Found optics in HOME_CSC, extracting..."
    tar -xf "$HOME_CSC" -C "${extrdDir}" --wildcards 'optics*'
    extractStuffsByTheirFormatSpecifier "${extrdDir}/optics"* "${cmprsDir}/optics.img" NULL
    compressInZStandard "${cmprsDir}/optics.img" "${cmprsDir}/optics.zst" --${compressionLevel}
    uploadGivenFileToTelegram "${cmprsDir}/optics.zst" "Here's optics.img from your dump, ${userToTag}" && rm -f "${cmprsDir}/optics.zst"
elif tar -tf "$HOME_CSC" | grep -q "product"; then
    console_print "Found product in HOME_CSC, extracting..."
    tar -xf "$HOME_CSC" -C "${extrdDir}" --wildcards 'product*'
    extractStuffsByTheirFormatSpecifier "${extrdDir}/product"* "${cmprsDir}/product.img" NULL
    compressInZStandard "${cmprsDir}/product.img" "${cmprsDir}/product.zst" --${compressionLevel}
    uploadGivenFileToTelegram "${cmprsDir}/product.zst" "Here's product.img from your dump, ${userToTag}" && rm -f "${cmprsDir}/product.zst"
fi

# erase HOME_CSC for storage:
rm -rf ${HOME_CSC}

# Extract AP content
if tar -tf "$AP" | grep -q "super"; then
    console_print "Found super in AP, extracting..."
    tar -xf "$AP" -C "${extrdDir}" --wildcards 'super*' || abort "Failed to extract super block from $AP"
    extractStuffsByTheirFormatSpecifier "${extrdDir}/super"* "${cmprsDir}/super.img" NULL
    compressInZStandard "${cmprsDir}/super.img" "${cmprsDir}/super.zst" --${compressionLevel}
    for f in "${cmprsDir}/super.zst" "${cmprsDir}/super.zst.part_"*; do
        [[ -f "$f" ]] && uploadGivenFileToTelegram "$f" "Here's a part of super.img from your dump, ${userToTag}"
    done
    rm -f ${cmprsDir}/super.zst ${cmprsDir}/super.zst.part_
    sendMessageToTelegramChat "To merge the split. run this command in a bash shell \`\`\`cat \"super.zst\" \"super.zst.part_\" > \"super_full.zst\"\`\`\`"
elif tar -tf "$AP" | grep -q "system"; then
    for img in system vendor; do
        if tar -tf "$AP" | grep -q "$img"; then
            console_print "Found ${img} in AP, extracting..."
            tar -xf "$AP" -C "${extrdDir}" --wildcards "${img}*" || abort "Failed to extract $img from $AP"
            extractStuffsByTheirFormatSpecifier "${extrdDir}/${img}"* "${cmprsDir}/${img}.img" NULL
            compressInZStandard "${cmprsDir}/${img}.img" "${cmprsDir}/${img}.zst" --${compressionLevel}
            uploadGivenFileToTelegram "${cmprsDir}/${img}.zst" "Here's ${img}.img from your dump, ${userToTag}" && rm -f "${cmprsDir}/${img}.zst" "${extrdDir}/${img}"*
        fi
    done
fi

# Extract boot / kernel and recovery:
if [ "${extractKernel}" == "true" ]; then
    for lowLevelImage in boot recovery; do
        if tar -tf "${AP}" | grep -q "${lowLevelImage}"; then
            console_print "Found ${lowLevelImage} in AP, extracting..."
            tar -xf "${AP}" -C "${extrdDir}" --wildcards "${lowLevelImage}*" || abort "Failed to extract ${lowLevelImage} from ${AP}"
            extractStuffsByTheirFormatSpecifier "${extrdDir}/${lowLevelImage}"* "${cmprsDir}/${lowLevelImage}.img" NULL
            compressInZStandard "${cmprsDir}/${lowLevelImage}.img" "${cmprsDir}/${lowLevelImage}.zst" --${compressionLevel}
            uploadGivenFileToTelegram "${cmprsDir}/${lowLevelImage}.zst" "Here's ${lowLevelImage}.img from your dump, ${userToTag}"
        else
            console_print tg "${lowLevelImage}.img is not available in AP"
        fi
    done
fi

# erase AP for storage:
rm -rf ${AP}

console_print "Firmware dump and upload complete!"
uploadGivenFileToTelegram "${thisConsoleTempLogFile}" "Script logs, check this file if you are concerned! Thank you!"
rm -rf ./local_build/
exit 0