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

# device blob path and etc...
BUILD_TARGET_BLOB_PATH="./target/a30/patches/stock_blobs"
stockCameraLibPath="${VENDOR_DIR}/lib/libexynoscamera3.so"
selected_lib="$BUILD_TARGET_BLOB_PATH/vendor/lib/libexynoscamera3_apr17.so"
REGEX="^(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (([[:digit:]]| )[[:digit:]]) ([[:digit:]][[:digit:]][[:digit:]][[:digit:]])$"
declare -A months=(
    [Jan]="01" [Feb]="02" [Mar]="03" [Apr]="04"
    [May]="05" [Jun]="06" [Jul]="07" [Aug]="08"
    [Sep]="09" [Oct]="10" [Nov]="11" [Dec]="12"
)

# adds fstab configs if the ROM fstab doesn't have f2fs configurations.
function mkfstab() {
    if ! cat ${VENDOR_DIR}/etc/fstab.exynos7904 | grep -q f2fs; then
        console_print "Vendor doesn't have f2fs mount configuaration, trying to add it..."
        echo -e "\n\n# ${BUILD_USERNAME} - ${BUILD_TARGET_CUSTOM_BRAND_NAME}\n/dev/block/platform/13500000.dwmmc0/by-name/cache /cache f2fs nosuid,nodev,noatime,inline_xattr wait,check,formattable\n/dev/block/platform/13500000.dwmmc0/by-name/userdata /data f2fs nosuid,nodev,noatime,inline_xattr,data_flush,fsync_mode=nobarrier latemount,wait,check,encryptable=footer,quota" >> ${VENDOR_DIR}/etc/fstab.exynos7904 && console_print "Added f2fs mount configs"
    fi
}

if [[ "$(grep_prop "ro.product.vendor.device" "$HORIZON_VENDOR_PROPERTY_FILE")" == *"a30"* && -f "${VENDOR_DIR}/etc/fstab.exynos7904" ]]; then
    console_print "Customizing experience for Galaxy A30..."
    mkfstab
    setprop --custom "${VENDOR_DIR}/default.prop" "log.tag.stats_log" "D"
    setprop --custom "${VENDOR_DIR}/default.prop" "persist.sys.usb.config" "mtp,adb"
    replaceTargetBuildProperties "a30"
    if [ "${BUILD_TARGET_ADD_PATCHED_C2API_LIBRARY_FILE}" == "true" ]; then
        console_print "Copying patched camera2api library file..."
        if [ -z "$(grep_prop "ro.vendor.build.date.utc" "$HORIZON_VENDOR_PROPERTY_FILE")" ]; then
            lib_date=$(strings $stockCameraLibPath | grep -o -E "$REGEX")
            year=${lib_date: -4}
            month_abbr=${lib_date:0:3}
            month="${months[$month_abbr]}"
            day=${lib_date:4:2}
            day="${day/ /0}"
            timestamp=$(date -d "$year-$month-$day" +%s)
        fi
        [ "$timestamp" -gt 1630458000 ] && selected_lib="$BUILD_TARGET_BLOB_PATH/vendor/lib/libexynoscamera3_oct15.so"
        if [ -z $timestamp ]; then
            warns "Failed to get timestamp from libexynoscamera3.so, please check the file." "timestampFromLib()"
        else
            copyDeviceBlobsSafely "$selected_lib" "$VENDOR_DIR/lib64/libexynoscamera3.so" && debugPrint "Brought camera2api!!!"
        fi
    fi
    [ "${BUILD_TARGET_ADD_FRAMEWORK_OVERLAY_TO_FIX_CUTOUT}" == "true" ] && buildAndSignThePackage "./target/a30/overlay/framework-res/" "${VENDOR_DIR}"
    if [ "${BUILD_TARGET_ADD_EXTRA_CAMERA_MODE}" == "true" ]; then
        console_print "Removing Pro Lite Mode and replacing with Pro mode.."
        manageCameraFeatures --remove "SHOOTING_MODE_PRO_LITE" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SHOOTING_MODE_PRO" "value=\"true\"" "SHOOTING_MODE_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_SUPER_RESOLUTION" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        console_print "Adding support for super resolution.."
        manageCameraFeatures --add "SUPPORT_DYNAMIC_RANGE_CONTROL" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_BACK_MF_HDR" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_BACK_RT_HDR" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_FRONT_MF_HDR" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_FRONT_RT_HDR" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_POST_PROCESSING_MOTION_PHOTO" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_FLASH_IN_WIDE_LENS" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_FLASH_IN_ULTRA_WIDE_LENS" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        console_print "Adding support for HDR.."
        manageCameraFeatures --remove "SUPPORT_VIDEO_HDR" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_VIDEO_HDR" "value=\"true\"" "SUPPORT_" "${SYSTEM_DIR}/cameradata/camera-feature.xml"
        console_print "Finished tweaking camera features"
    fi
fi