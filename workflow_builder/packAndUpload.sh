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

# Source utility functions
source ./misc/build_scripts/util_functions.sh
PACK_IMAGE_WITH_TS_FORMAT="$1"

# Cleanup helpers
cleanUpFile() {
    [[ -f "$1" ]] && rm -f "$1"
}

# Build system/vendor/product images
for COMMON_FIRMWARE_BLOCKS in system vendor product; do
    for IMAGES in ./local_build/workflow_partitions/*_${COMMON_FIRMWARE_BLOCKS} ./local_build/workflow_partitions/*_${COMMON_FIRMWARE_BLOCKS}__rw; do
        [[ -f "$IMAGES" ]] || continue
        buildImage "${IMAGES}"
    done
done

# Build and compress optics image
for optics in ./local_build/workflow_builds/*__optics ./local_build/workflow_builds/*__optics__rw; do
    [[ -f "$optics" ]] || continue
    buildImage "${optics}"
    zstd -T0 --ultra -22 "./local_build/workflow_builds/optics_built.img" -o "./optics.img.zst" && cleanUpFile "./local_build/workflow_builds/optics_built.img"
done

# Inform user
sendMessageToTelegramChat "Packing images into a ${PACK_IMAGE_WITH_TS_FORMAT} file..."

if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == true ]; then
    for imagesToMove in ./local_build/super_extract/*_built.img; do
        [[ -f "$imagesToMove" ]] || continue
        imageName="$(basename "$imagesToMove")"
        partitionName="$(echo "$imageName" | grep -oE '(system|vendor|product|optics)')" || continue
        [[ -n "$partitionName" ]] || continue
        mv "$imagesToMove" "./local_build/super_extract/${partitionName}.img"
    done
    repackSuperFromDump "./super_new.img"
    case "${PACK_IMAGE_WITH_TS_FORMAT}" in
        "tar")
            tar -cf "./local_build/workflow_builds/packed_buildImages.tar" ./super_new.img && cleanUpFile "./super_new.img"
        ;;
        "zstd")
            zstd -T0 --ultra -22 "./super_new.img" -o "./super_new.img.zst" && cleanUpFile "./super_new.img"
        ;;
        "zip")
            zip -q -r ./local_build/workflow_builds/packed_buildImages.zip "./super_new.img" && cleanUpFile "./super_new.img"
        ;;
    esac
else
    # Non-dynamic: move built images to extract folder
    for imagesToMove in ./local_build/workflow_builds/*_built.img; do
        [[ -f "$imagesToMove" ]] || continue
        imageName="$(basename "$imagesToMove")"
        partitionName="$(echo "$imageName" | grep -oE '(system|vendor|product|optics)')" || continue
        [[ -n "$partitionName" ]] || continue
        mv "$imagesToMove" "./local_build/super_extract/${partitionName}.img"
    done
    # Package images
    for packedImages in ./local_build/workflow_builds/*.img; do
        [[ -f "$packedImages" ]] || continue
        case "${PACK_IMAGE_WITH_TS_FORMAT}" in
            "tar"|"zstd")
                tar --append --file="./local_build/workflow_builds/packed_buildImages.tar" -C "$(dirname "$packedImages")" "$(basename "$packedImages")"
            ;;
            "zip")
                zip -q -r ./local_build/workflow_builds/packed_buildImages.zip "$packedImages"
            ;;
        esac
        cleanUpFile "$packedImages"
    done
    [[ "${PACK_IMAGE_WITH_TS_FORMAT}" == "zstd" ]] && \
        zstd -T0 --ultra -22 "./local_build/workflow_builds/packed_buildImages.tar" -o "./local_build/workflow_builds/packed_buildImages.zst" && \
        cleanUpFile "./local_build/workflow_builds/packed_buildImages.tar"
fi

# Wrap up and upload
timestamp=$(TZ=America/Phoenix date +"%b %d %I:%M %p")
sendMessageToTelegramChat "Build completed successfully at ${timestamp}"
sendMessageToTelegramChat "Trying to upload the build to Telegram..."

uploadGivenFileToTelegram "$thisConsoleTempLogFile"
uploadGivenFileToTelegram "./optics.img.zst" "test build for Samsung Galaxy $(deviceCodenameToModel "${TARGET_DEVICE}") (${TARGET_DEVICE}) | tag @forsaken_heart24 if it boots, Thanks in advance!" || \
    abort "Failed to upload the optics image to Telegram."

if uploadGivenFileToTelegram "./local_build/workflow_builds/packed_buildImages.${PACK_IMAGE_WITH_TS_FORMAT}" \
    "test build for Samsung Galaxy $(deviceCodenameToModel "${TARGET_DEVICE}") (${TARGET_DEVICE}) | tag @forsaken_heart24 if it boots, Thanks in advance!"; then
    cleanUpFile "./local_build/workflow_builds/packed_buildImages.${PACK_IMAGE_WITH_TS_FORMAT}"
    exit 0
fi
exit 1