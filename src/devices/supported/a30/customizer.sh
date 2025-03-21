#!/usr/bin/env bash

function mkfstab() {
    cat ${HORIZON_VENDOR_DIR}/etc/fstab.exynos7904 | grep -q f2fs || {
        console_print "Vendor doesn't have f2fs mount configuaration, trying to add it..."
        echo -e "#<src>                  <mnt_point>         <type>    <mnt_flags and options>                               <fs_mgr_flags>\n# The filesystem that contains the filesystem checker binary (typically /system) cannot\n# specify MF_CHECK, and must come before any filesystems that do specify MF_CHECK\n/dev/block/platform/13500000.dwmmc0/by-name/cache	/cache	ext4	noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic	wait,check\n/dev/block/platform/13500000.dwmmc0/by-name/cache       /cache  f2fs    nosuid,nodev,noatime,inline_xattr wait,check,formattable\n/dev/block/platform/13500000.dwmmc0/by-name/efs	/mnt/vendor/efs	ext4	noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic	wait,check\n/dev/block/platform/13500000.dwmmc0/by-name/misc	/misc	emmc	defaults	defaults,first_stage_mount\n/dev/block/platform/13500000.dwmmc0/by-name/userdata	/data	ext4	noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic	wait,check,fileencryption=ice,quota,reservedsize=128M\n/dev/block/platform/13500000.dwmmc0/by-name/userdata    /data   f2fs    nosuid,nodev,noatime,inline_xattr,data_flush,fsync_mode=nobarrier latemount,wait,check,encryptable=footer,quota\n/dev/block/platform/13500000.dwmmc0/by-name/hidden	/preload	ext4	noatime,nosuid,nodev,noauto_da_alloc,discard,journal_checksum,data=ordered,errors=panic	voldmanaged=preload:auto,check\n/devices/platform/13550000.dwmmc2/mmc_host/mmc1*        auto        vfat    defaults    voldmanaged=sdcard:auto\n/devices/platform/13600000.usb/13600000.dwc3*		auto        auto    defaults    voldmanaged=usb:auto\n" > $HORIZON_VENDOR_DIR/etc/fstab.exynos7904
        [ "$?" == "0" ] && console_print "Added f2fs mount configs" && return 0
    }
    console_print "Failed to add mount configs, this may due to the vendor have came with mount configs"
    return 1
}

if [[ "$(grep_prop "ro.product.vendor.device" "$HORIZON_VENDOR_PROPERTY_FILE")" == *"a30"* && -f "${HORIZON_VENDOR_DIR}/etc/fstab.exynos7904" ]]; then
    console_print "Customizing experience for Exynos7904 Devices...."
    setprop --vendor ro.config.pageboost.io_prefetch.enabled "false"
    setprop --vendor ro.config.pageboost.io_prefetch.level '2'
    setprop --vendor ro.frp.pst " "
    mkfstab
    setprop --custom "${HORIZON_VENDOR_DIR}/default.prop" "log.tag.stats_log" "D"
    setprop --custom "${HORIZON_VENDOR_DIR}/default.prop" "persist.sys.usb.config" "mtp,adb"
fi