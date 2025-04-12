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

set -euo pipefail

# Arguments
TARGET_DEVICE_FULL_FIRMWARE_LINK="$1"
theBotToken="$2"
chatID="$3"
PACK_IMAGE_WITH_TS_FORMAT="$4"

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
console_print tg "Firmware package downloaded at $(TZ=America/Phoenix date '+%I:%M%p')"

# Unzip AP and HOME_CSC
for specificTargetFirmwareFile in $(unzip -Z1 "${firmwareZip}" | grep -E 'AP|HOME_CSC'); do
    console_print tg "Unpacking firmware: ${specificTargetFirmwareFile}"
    unzip -q "${firmwareZip}" "${specificTargetFirmwareFile}" -d "${extrdDir}" >> "$thisConsoleTempLogFile"
done
rm -f "${firmwareZip}"

# Find real paths
HOME_CSC=$(find "${extrdDir}" -type f -name 'HOME_CSC_*.tar.md5' | head -n1)
AP=$(find "${extrdDir}" -type f -name 'AP*.tar.md5' | head -n1)

[ -f "$HOME_CSC" ] || abort "HOME_CSC archive not found!"
[ -f "$AP" ] || abort "AP archive not found!"

# Extract HOME_CSC content
if tar -tf "$HOME_CSC" | grep -q "optics"; then
    console_print tg "Found prism in HOME_CSC, extracting..."
    tar -xf "$HOME_CSC" -C "${extrdDir}"
    extractStuffsByTheirFormatSpecifier "${extrdDir}/prism"* "${cmprsDir}/prism.img" NULL
elif tar -tf "$HOME_CSC" | grep -q "product"; then
    console_print tg "Found product in HOME_CSC, extracting..."
    tar -xf "$HOME_CSC" -C "${extrdDir}"
    extractStuffsByTheirFormatSpecifier "${extrdDir}/product"* "${cmprsDir}/product.img" NULL
fi

# Extract AP content
if tar -tf "$AP" | grep -q "super"; then
    console_print "Super image found, extracting..."
    tar -xf "$AP" -C "${extrdDir}"
    extractStuffsByTheirFormatSpecifier "${extrdDir}/super"* "${cmprsDir}/super.img" NULL
elif tar -tf "$AP" | grep -q "system"; then
    console_print tg "Found system in AP, extracting..."
    for img in system vendor; do
        tar -xvf "$AP" "$img" -C "${extrdDir}"
        extractStuffsByTheirFormatSpecifier "${extrdDir}/${img}"* "${cmprsDir}/${img}.img" NULL
        rm -f "${extrdDir}/${img}"*
    done
fi

# Pack images
console_print "Packing and uploading to Telegram..."
TS_TAR="${cmprsDir}/tsFirmware.tar"

for unpacked in "${cmprsDir}"/*.img; do
    console_print tg "Packing ${unpacked}..."
    tar --append --file="${TS_TAR}" -C "${cmprsDir}" "$(basename "${unpacked}")"
    rm -f "${unpacked}"
done

# Compress with zstd if needed
if [[ "${PACK_IMAGE_WITH_TS_FORMAT}" == "zstd" ]]; then
    zstd -T0 --ultra -22 "${TS_TAR}" -o "${cmprsDir}/tsFirmware.zst"
    uploadGivenFileToTelegram "${cmprsDir}/tsFirmware.zst" && rm -f "${cmprsDir}/tsFirmware.zst"
else
    uploadGivenFileToTelegram "${TS_TAR}"
fi

rm -f "${TS_TAR}"