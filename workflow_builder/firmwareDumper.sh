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

# Paths
firmwareZip="./local_build/downloads/firmware.zip"
thisConsoleTempLogFile="./local_build/logs/hux_build.log"
extrdDir="./local_build/extrd"
cmprsDir="./local_build/cmprs"
mkdir -p "${extrdDir}" "${cmprsDir}" "./local_build/downloads" "./local_build/logs"

# Source script to fetch functions
. ./src/misc/build_scripts/util_functions.sh "${theBotToken}" "${chatID}"

# Header
console_print "\033[0;31m########################################################################"
console_print "   _  _     _   _            _                _   ___  __"
console_print " _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \/ /"
console_print "|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / "
console_print "|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ "
console_print "  |_||_|   |_| |_|\___/|_|  |_/___\\___/|_| |_|\___//_/\\_\\"
console_print "########################################################################\033[0m"
console_print tg "Firmware Dump started at $(TZ=America/Phoenix date '+%d %b %Y, %I:%M%p') (Phoenix Time)"

# Download firmware
console_print "Downloading firmware package..."
download_stuffs "${TARGET_DEVICE_FULL_FIRMWARE_LINK}" "${firmwareZip}" || abort "Failed to download firmware."
console_print tg "Firmware package finished downloading at $(TZ=America/Phoenix date '+%I:%M%p')"

# Unzip AP and HOME_CSC
for specificFirmwareFile in $(unzip -Z1 "${firmwareZip}" | grep -E 'AP|HOME_CSC'); do
    console_print tg "Unpacking firmware: ${specificFirmwareFile}"
    unzip -q "${firmwareZip}" "${specificFirmwareFile}" -d "${extrdDir}" >> "$thisConsoleTempLogFile" || abort "Failed to extract $specificFirmwareFile"
done
rm -f "${firmwareZip}" || abort "Failed to delete ${firmwareZip}"

# Find real paths
HOME_CSC=$(find "${extrdDir}" -type f -name 'HOME_CSC_*.tar.md5' | head -n1)
AP=$(find "${extrdDir}" -type f -name 'AP*.tar.md5' | head -n1)
[ -f "$HOME_CSC" ] || abort "HOME_CSC archive not found!"
[ -f "$AP" ] || abort "AP archive not found!"

# Extract HOME_CSC content
if tar -tf "$HOME_CSC" | grep -q "optics"; then
    console_print tg "Found optics in HOME_CSC, extracting..."
    tar -xf "$HOME_CSC" -C "${extrdDir}" --wildcards 'optics*'
    extractStuffsByTheirFormatSpecifier "${extrdDir}/optics"* "${cmprsDir}/optics.img" NULL
    zstd -T0 --ultra -22 "${cmprsDir}/optics.img" -o "${cmprsDir}/optics.zst"
    uploadGivenFileToTelegram "${cmprsDir}/optics.zst" && rm -f "${cmprsDir}/optics.zst"
elif tar -tf "$HOME_CSC" | grep -q "product"; then
    console_print tg "Found product in HOME_CSC, extracting..."
    tar -xf "$HOME_CSC" -C "${extrdDir}" --wildcards 'product*'
    extractStuffsByTheirFormatSpecifier "${extrdDir}/product"* "${cmprsDir}/product.img" NULL
    zstd -T0 --ultra -22 "${cmprsDir}/product.img" -o "${cmprsDir}/product.zst"
    uploadGivenFileToTelegram "${cmprsDir}/product.zst" && rm -f "${cmprsDir}/product.zst"
fi

# Extract AP content
if tar -tf "$AP" | grep -q "super"; then
    console_print "Found super in AP, extracting..."
    tar -xf "$AP" -C "${extrdDir}" --wildcards 'super*'
    extractStuffsByTheirFormatSpecifier "${extrdDir}/super"* "${cmprsDir}/super.img" NULL
    zstd -T0 --ultra -22 "${cmprsDir}/super.img" -o "${cmprsDir}/super.zst"
    uploadGivenFileToTelegram "${cmprsDir}/super.zst" && rm -f "${cmprsDir}/super.zst"
elif tar -tf "$AP" | grep -q "system"; then
    for img in system vendor; do
        if tar -tf "$AP" | grep -q "$img"; then
            console_print "Found ${img} in AP, extracting..."
            tar -xf "$AP" -C "${extrdDir}" --wildcards "${img}*"
            extractStuffsByTheirFormatSpecifier "${extrdDir}/${img}"* "${cmprsDir}/${img}.img" NULL
            zstd -T0 --ultra -22 "${cmprsDir}/${img}.img" -o "${cmprsDir}/${img}.zst"
            uploadGivenFileToTelegram "${cmprsDir}/${img}.zst" && rm -f "${cmprsDir}/${img}.zst"
            rm -f "${extrdDir}/${img}"*
        fi
    done
fi

console_print tg "Firmware dump and upload complete!"
rm -rf ./local_build/
exit 0