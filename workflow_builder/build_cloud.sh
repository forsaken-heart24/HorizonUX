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
PACK_IMAGE_WITH_TS_FORMAT="$4"
thisConsoleTempLogFile="../local_build/logs/hux_build.log"

# device specific customization:
[ -d "./target/${TARGET_DEVICE}" ] || exit 0;

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
         local_build_downloaded_contents/tar_files/ workflow_partitions/ workflow_builds; do
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

function getImageFileSystem() {
    if [[ "$(xxd -p -l "2" --skip "1080" "$1")" == "53ef" ]]; then
        echo "ext4"
    elif [[ "$(xxd -p -l "4" --skip "1024" "$1")" == "1020f5f2" ]]; then
        echo "f2fs"
    elif [[ "$(xxd -p -l "4" --skip "1024" "$1")" == "e2e1f5e0" ]]; then
        echo "erofs"
    else
        echo "unknown"
    fi
}

function setMakeConfigs() {
    local propVariableName="$1"
    local propValue="$2"
    local propFile="$3"
    awk -v pat="^${propVariableName}=" -v value="${propVariableName}=${propValue}" '{ if ($0 ~ pat) print value; else print $0; }' ${propFile} > ${propFile}.tmp
}

function abort() {
    echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] [:\e[0;36mABORT\e[0;37m:] -\e[0;31m $1\e[0;37m"
    debugPrint "[$(date +%d-%m-%Y) - $(date +%H:%M%p)] [:ABORT:] - $1"
    sleep 0.5
    tinkerWithCSCFeaturesFile --encode
    rm -rf $TMPDIR ${BUILD_TARGET_FLOATING_FEATURE_PATH}.bak ../local_build/*
    exit 1
}

function buildImage() {
    local blockPath="$1"
    local block="$2"
    local buildType="$3"
    local imagePath=$(mount | grep ${blockPath} | awk '{print $1}')
    if echo "$blockPath" | grep -q "__rw"; then
        console_print "EROFS fs detected, building an EROFS image..."
        sudo mkfs.erofs -z lz4 --mount-point=$block ../local_build/workflow_builds/${block}.erofs.img $blockPath/
    else 
        console_print "F2FS/EXT4 fs detected, unmounting the image.."
        sudo umount "${blockPath}" || abort "Failed to unmount the image, aborting this instance.."
        console_print "Successfully unmounted ${blockPath}.."
    fi
    cp $imagePath ../local_build/workflow_builds/${block}_buildImage.img
    rm $imagePath
    if [ "$?" -ne '0' ]; then
        abort "Failed to copy the image to the build directory, aborting this instance.."
    fi
    console_print "Successfully built ${block}_buildImage.img"
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
    console_print "Unpacking images...."
    for COMMON_FIRMWARE_BLOCKS in system vendor product; do
        lz4 -d -q ../local_build/local_build_downloaded_contents/tar_files/${COMMON_FIRMWARE_BLOCKS}.img.lz4 "${COMMON_FIRMWARE_BLOCKS}.img_raw" || abort "Failed to extract ${COMMON_FIRMWARE_BLOCKS} from the firmware dump, please try againn....."
        mountPath="../local_build/workflow_partitions/$(generate_random_hash 10)__$COMMON_FIRMWARE_BLOCK"
        case "$(getImageFileSystem ${COMMON_FIRMWARE_BLOCKS}.img_raw)" in
            "erofs")
                dirt="${mountPath}__rw"
                mkdir -p $dirt
                sudo fuse.erofs ${COMMON_FIRMWARE_BLOCK}.img $mountPath &>/dev/null
                sudo cp -a --preserve=all $mountPath $dirt/
                setMakeConfigs $(echo "$COMMON_FIRMWARE_BLOCK" | tr '[:lower:]' '[:upper:]')_DIR $dirt ./makeconfigs.prop
            ;;
            "f2fs"|"ext4")
                sudo mount -o rw ../local_build/local_build_downloaded_contents/tar_files/${COMMON_FIRMWARE_BLOCK}.img $mountPath || abort "Failed to mount ${COMMON_FIRMWARE_BLOCK} as rw, please try again..."
                setMakeConfigs $(echo "$COMMON_FIRMWARE_BLOCK" | tr '[:lower:]' '[:upper:]')_DIR $mountPath ./makeconfigs.prop
            ;;
            *)
                abort "Unknown filesystem to tinker with, aborting..."
            ;;
        esac
    done
elif [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == true ]; then
    console_print "Unpacking Super sparse image block...."
    if lz4 -d -q ../local_build/local_build_downloaded_contents/tar_files/super.img.lz4 "super.img.sparse" && simg2img "super.img.sparse" "super.img" && rm -rf "super.img.sparse"; then
        console_print "Successfully unpacked, converted into raw, and deleted the base Super.img from the downloaded source....."
    else
        abort "Failed to unpack the base Super.img from the downloaded source..."
    fi
    lpunpack "super.img" &>$thisConsoleTempLogFile
    lpdump "super.img" > dumpOfTheSuperBlock
    for COMMON_FIRMWARE_BLOCK in vendor system product; do
        lpunpack --partition=$COMMON_FIRMWARE_BLOCK ../local_build/local_build_downloaded_contents/tar_files/super.img || abort "Failed to extract \"${COMMON_FIRMWARE_BLOCK}\" from the super image, please try again..."
        mountPath="../local_build/workflow_partitions/$(generate_random_hash 10)__$COMMON_FIRMWARE_BLOCK"
        case "$(getImageFileSystem ${COMMON_FIRMWARE_BLOCK}.img)" in
            "erofs")
                dirt="${mountPath}__rw"
                mkdir -p $dirt
                sudo fuse.erofs ${COMMON_FIRMWARE_BLOCK}.img $mountPath &>/dev/null
                sudo cp -a --preserve=all $mountPath $dirt/
                setMakeConfigs $(echo "$COMMON_FIRMWARE_BLOCK" | tr '[:lower:]' '[:upper:]')_DIR $dirt ./makeconfigs.prop
            ;;
            "f2fs"|"ext4")
                sudo mount -o rw ../local_build/local_build_downloaded_contents/tar_files/${COMMON_FIRMWARE_BLOCK}.img $mountPath || abort "Failed to mount ${COMMON_FIRMWARE_BLOCK} as rw, please try again..."
                setMakeConfigs $(echo "$COMMON_FIRMWARE_BLOCK" | tr '[:lower:]' '[:upper:]')_DIR $mountPath ./makeconfigs.prop
            ;;
            *)
                abort "Unknown filesystem to tinker with, aborting..."
            ;;
        esac
    done
fi
setMakeConfigs TARGET_BUILD_PRODUCT_NAME ${TARGET_DEVICE} ./makeconfigs.prop
./build.sh
for COMMON_FIRMWARE_BLOCKS in system vendor product optics; do
    for IMAGES in ../local_build/workflow_partitions/*_${COMMON_FIRMWARE_BLOCKS} ../local_build/workflow_partitions/*_${COMMON_FIRMWARE_BLOCKS}__rw; do
        buildImage "${IMAGES}" "${COMMON_FIRMWARE_BLOCKS}"
    done
done
case "${PACK_IMAGE_WITH_TS_FORMAT}" in
    "tar")
        rm -f "../local_build/workflow_builds/packed_buildImages.tar"
        for IMG_PATH in ../local_build/workflow_builds/*_buildImage.img; do
            tar --append --file="../local_build/workflow_builds/packed_buildImages.tar" -C "$(dirname "$IMG_PATH")" "$(basename "$IMG_PATH")" && rm -f "$IMG_PATH"
        done
    ;;
    "zstd")
        for f in ../local_build/workflow_builds/*_buildImage.img; do
            zstd -T0 --ultra -22 "$f" -o "${f}.zst" && rm -f "$f"
        done
    ;;
    "zip")
        zip -r ../local_build/workflow_builds/packed_buildImages.zip ../local_build/workflow_builds/*_buildImage.img && rm -f ../local_build/workflow_builds/*_buildImage.img
    ;;
esac
console_print "Build completed successfully at $(date +%I:%M%p) on $(date +%d\ %B\ %Y)"
console_print "Build images can be found at ../local_build/workflow_builds/packed_buildImages.${PACK_IMAGE_WITH_TS_FORMAT}"