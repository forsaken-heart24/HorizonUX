#!/usr/bin/env bash

# device blob path...
BUILD_TARGET_BLOB_PATH="./target/a30/patches/stock_blobs"
soundBoosterBlob=$(ls ${HORIZON_SYSTEM_DIR}/lib/ | grep lib_SoundBooster_ver)
soundBooster64Blob=$(ls ${HORIZON_SYSTEM_DIR}/lib64/ | grep lib_SoundBooster_ver)

# makes fstab if the ROM fstab doesn't have f2fs configuarations.
function mkfstab() {
    cat ${HORIZON_VENDOR_DIR}/etc/fstab.exynos7904 | grep -q f2fs || {
        console_print "Vendor doesn't have f2fs mount configuaration, trying to add it..."
        echo -e "#<src>                  <mnt_point>         <type>    <mnt_flags and options>                               <fs_mgr_flags>\n# The filesystem that contains the filesystem checker binary (typically /system) cannot\n# specify MF_CHECK, and must come before any filesystems that do specify MF_CHECK\n/dev/block/platform/13500000.dwmmc0/by-name/cache	/cache	ext4	noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic	wait,check\n/dev/block/platform/13500000.dwmmc0/by-name/cache       /cache  f2fs    nosuid,nodev,noatime,inline_xattr wait,check,formattable\n/dev/block/platform/13500000.dwmmc0/by-name/efs	/mnt/vendor/efs	ext4	noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic	wait,check\n/dev/block/platform/13500000.dwmmc0/by-name/misc	/misc	emmc	defaults	defaults,first_stage_mount\n/dev/block/platform/13500000.dwmmc0/by-name/userdata	/data	ext4	noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic	wait,check,fileencryption=ice,quota,reservedsize=128M\n/dev/block/platform/13500000.dwmmc0/by-name/userdata    /data   f2fs    nosuid,nodev,noatime,inline_xattr,data_flush,fsync_mode=nobarrier latemount,wait,check,encryptable=footer,quota\n/dev/block/platform/13500000.dwmmc0/by-name/hidden	/preload	ext4	noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic	voldmanaged=preload:auto,check\n/devices/platform/13550000.dwmmc2/mmc_host/mmc1*        auto        vfat    defaults    voldmanaged=sdcard:auto\n/devices/platform/13600000.usb/13600000.dwc3*		auto        auto    defaults    voldmanaged=usb:auto\n" > $HORIZON_VENDOR_DIR/etc/fstab.exynos7904
        [ "$?" == "0" ] && console_print "Added f2fs mount configs"
    }
    abort "Failed to add mount configs, this may due to the vendor have came with mount configs"
}

# tries to copy blobs and exits if failed.
function copyDeviceBlobsSafely() {
    local blobFromSource="$1"
    local blobInROM="$2"
    console_print "Trying to copy ${blobFromSource} to ${blobInROM}"
    if [ ! -f "${blobInROM}" ] && ask "${blobFromSource} is not found on the ROM, do you wanna copy this blob to the device?"; then
        cp -af "${blobFromSource}" "${blobInROM}" 2>${thisConsoleTempLogFile} || warns "Failed to copy ${blobFromSource}, this might cause an bootloop, please be sure." "copyDeviceBlobsSafely()"
    else
        cp -af "${blobFromSource}" "${blobInROM}" 2>${thisConsoleTempLogFile} || warns "Failed to copy ${blobFromSource}, this might cause an bootloop, please be sure." "copyDeviceBlobsSafely()"
    fi
    console_print "Finished copying given blobs!"
    return 0
}

if [[ "$(grep_prop "ro.product.vendor.device" "$HORIZON_VENDOR_PROPERTY_FILE")" == *"a30"* && -f "${HORIZON_VENDOR_DIR}/etc/fstab.exynos7904" ]]; then
    console_print "Customizing experience for Galaxy A30..."
    setprop --vendor ro.config.pageboost.io_prefetch.enabled "false"
    setprop --vendor ro.config.pageboost.io_prefetch.level '2'
    setprop --vendor ro.frp.pst " "
    mkfstab
    setprop --custom "${HORIZON_VENDOR_DIR}/default.prop" "log.tag.stats_log" "D"
    setprop --custom "${HORIZON_VENDOR_DIR}/default.prop" "persist.sys.usb.config" "mtp,adb"
    boolReturn "${BUILD_TARGET_ADD_PATCHED_C2API_LIBRARY_FILE}" && copyDeviceBlobsSafely "${BUILD_TARGET_BLOB_PATH}/vendor/lib64/libexynoscamera3.so" "${VENDOR_DIR}/lib64/libexynoscamera3.so" && console_print "Brought camera2api!!!"
    boolReturn "${BUILD_TARGET_ADD_FRAMEWORK_OVERLAY_TO_FIX_CUTOUT}" && build_and_sign "./target/a30/overlay/framework-res/" "${HORIZON_VENDOR_DIR}"
    if boolReturn "${BUILD_TARGET_ADD_EXTRA_CAMERA_MODE}"; then
        console_print "Removing Pro Lite Mode and replacing with Pro mode.."
        manageCameraFeatures --remove "SHOOTING_MODE_PRO_LITE" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SHOOTING_MODE_PRO" "value=\"true\"" "SHOOTING_MODE_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_SUPER_RESOLUTION" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        console_print "Adding support for super resolution.."
        manageCameraFeatures --add "SUPPORT_DYNAMIC_RANGE_CONTROL" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_BACK_MF_HDR" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_BACK_RT_HDR" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_FRONT_MF_HDR" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_FRONT_RT_HDR" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_POST_PROCESSING_MOTION_PHOTO" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_FLASH_IN_WIDE_LENS" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_FLASH_IN_ULTRA_WIDE_LENS" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        console_print "Adding support for HDR.."
        manageCameraFeatures --remove "SUPPORT_VIDEO_HDR" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        manageCameraFeatures --add "SUPPORT_VIDEO_HDR" "value=\"true\"" "SUPPORT_" "${HORIZON_SYSTEM_DIR}/cameradata/camera-feature.xml"
        console_print "Finished tweaking camera features"
    fi
fi