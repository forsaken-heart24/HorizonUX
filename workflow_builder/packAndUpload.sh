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

# let's build shits:
for COMMON_FIRMWARE_BLOCKS in system vendor product optics; do
    for IMAGES in ./local_build/workflow_partitions/*_${COMMON_FIRMWARE_BLOCKS} ./local_build/workflow_partitions/*_${COMMON_FIRMWARE_BLOCKS}__rw; do
        buildImage "${IMAGES}"
    done
done

if compgen -G "./local_build/*__optics" > /dev/null; then
    buildImage ./local_build/*__optics
    zstd -T0 --ultra -22 "./local_build/workflow_builds/optics_built.img" -o "./optics.img.zst" && rm -f "./local_build/workflow_builds/optics_built.img"
fi

# let's compress the shits:
sendMessageToTelegramChat "Packing images into a ${PACK_IMAGE_WITH_TS_FORMAT} file..."
if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == true ]; then
    for imagesToMove in ./local_build/super_extract/*_built.img; do
        mv "$imagesToMove" "./local_build/super_extract/$(basename "$imagesToMove" | grep -oE '(system|vendor|product|optics)').img" && rm -rf "$imagesToMove"
    done
    repackSuperFromDump "./local_build/super_extract/" "./super_new.img"
    case "${PACK_IMAGE_WITH_TS_FORMAT}" in
        "tar")
            tar --create --file="./local_build/workflow_builds/packed_buildImages.tar" ./super_new.img && rm -f "./super_new.img"
        ;;
        "zstd")
            zstd -T0 --ultra -22 "./super_new.img" -o "./super_new.img.zst" && rm -f ./super_new.img
        ;;
        "zip")
            zip -r ./local_build/workflow_builds/packed_buildImages.zip "./super_new.img" && rm -f "./super_new.img"
        ;;
    esac
elif [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == false ]; then
    for imagesToMove in ./local_build/workflow_builds/*_built.img; do
        mv "$imagesToMove" "./local_build/super_extract/$(basename "$imagesToMove" | grep -oE '(system|vendor|product|optics)').img" && rm -rf "$imagesToMove"
    done
    for packedImages in ./local_build/workflow_builds/*.img; do
        [[ -f "$packedImages" ]] || continue
        case "${PACK_IMAGE_WITH_TS_FORMAT}" in
            "tar"|"zstd")
                tar --append --file="./local_build/workflow_builds/packed_buildImages.tar" -C "$(dirname "$packedImages")" "$(basename "$packedImages")" && rm -f "$packedImages"
            ;;
            "zip")
                zip -r ./local_build/workflow_builds/packed_buildImages.zip "$packedImages" && rm -f "$packedImages"
            ;;
        esac
    done
    [[ "${PACK_IMAGE_WITH_TS_FORMAT}" == "zstd" ]] && zstd -T0 --ultra -22 "./local_build/workflow_builds/packed_buildImages.tar" -o "./local_build/workflow_builds/packed_buildImages.zst" && rm -f ./local_build/workflow_builds/packed_buildImages.tar
fi

# send and exit:
sendMessageToTelegramChat "Build completed successfully at $(TZ=America/Phoenix date +%I:%M%p)"
sendMessageToTelegramChat "Trying to upload the build to Telegram..."
uploadGivenFileToTelegram "$thisConsoleTempLogFile"
uploadGivenFileToTelegram "./optics.img.zst" "test build for Samsung Galaxy $(deviceCodenameToModel "${TARGET_DEVICE}") (${TARGET_DEVICE}) | tag @forsaken_heart24 if it boots, Thanks in advance!" || abort "Failed to upload the optics image to Telegram."
if uploadGivenFileToTelegram "./local_build/workflow_builds/packed_buildImages.${PACK_IMAGE_WITH_TS_FORMAT}" "test build for Samsung Galaxy $(deviceCodenameToModel "${TARGET_DEVICE}") (${TARGET_DEVICE}) | tag @forsaken_heart24 if it boots, Thanks in advance!"; then
    rm -rf ./local_build/workflow_builds/packed_buildImages.${PACK_IMAGE_WITH_TS_FORMAT}
    exit 0
fi
exit 1