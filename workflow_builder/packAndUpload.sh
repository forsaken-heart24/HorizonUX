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

# source script to fetch functions.
source ./misc/build_scripts/util_functions.sh

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
sendMessageToTelegramChat "Build completed successfully at $(TZ=America/Phoenix date +%I:%M%p)"
uploadGivenFileToTelegram "../local_build/workflow_builds/packed_buildImages.${PACK_IMAGE_WITH_TS_FORMAT}" || exit 1
exit 0