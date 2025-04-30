#!/sbin/sh

# checks:
command -v twrp || abort "Run this on twrp recovery environment. (0x6d6f746865726675636b65722072756e207468697320696e207468652066
75636b696e6720747772702062697463680a)"
[ "$(id -u)" == "0" ] || abort "Run this on twrp recovery environment (0x6d6f746865726675636b657220776865726527732074686520726f6f7420
70726976696c616765733f3f0a)"
# checks:

# variables to use:
userdataBlock=$(readlink -f /dev/block/platform/*/by-name/userdata) || abort "userdata block not found"
cacheBlock=$(readlink -f /dev/block/platform/*/by-name/cache) || abort "cache block not found"
vendorBlock=$(readlink -f /dev/block/platform/*/by-name/vendor) || abort "vendor block not found"
OUTFD="$2"
# variables to use:

# shell functions
function printr() {
    local text="$1"
    echo -e "ui_print $text\nui_print" >> /proc/self/fd/$OUTFD
}

function abort() {
    printr "$1"
    exit 1    
}
# shell functions

printr "#########################################################"
printr " _   _            _                _   _ _   _ _"
printr "| | | | ___  _ __(_)_______  _ __ | | | | |_(_) |___"
printr "| |_| |/ _ \|  __| |_  / _ \|  _ \| | | | __| | / __|"
printr "|  _  | (_) | |  | |/ / (_) | | | | |_| | |_| | \__ \\"
printr "|_| |_|\___/|_|  |_/___\___/|_| |_|\___/ \__|_|_|___/"
printr "                                                       "      
printr "#########################################################"
getprop ro.product.vendor.device | grep -qE "a30|a30dd" || abort "Your $(getprop ro.product.vendor.device) is not supported, this script is solely made for Galaxy A30 devices."
printr "Partition Converter for your Samsung Galaxy A30"
printr "This script will format your userdata and cache partitions to the requested filesystem type."
printr "This script is not responsible for any data loss or damage to your device."
printr "Please make sure to backup your data before proceeding."

# ok let's go!!
if echo "$3" | tr '[:upper:]' '[:lower:]' | grep -qE "f2fs|switch"; then
    mkfs.f2fs -f ${userdataBlock} || abort "Failed to format userdata with f2fs"
    mkfs.f2fs -f ${cacheBlock} || abort "Failed to format cache with f2fs"
    printr "Adding f2fs mount flags onto the vendor fstab file..."
    mount /vendor
    [ -f "/vendor/etc/fstab.exynos7904" ] && ! grep -q " f2fs " "/vendor/etc/fstab.exynos7904" && echo -e "\n# Added by mkfstab for F2FS support, thank @forsaken_heart24 later!\n/dev/block/platform/13500000.dwmmc0/by-name/cache /cache f2fs nosuid,nodev,noatime,inline_xattr wait,check,formattable\n/dev/block/platform/13500000.dwmmc0/by-name/userdata /data f2fs nosuid,nodev,noatime,inline_xattr,data_flush,fsync_mode=nobarrier latemount,wait,check,encryptable=footer,quota" >> /vendor/etc/fstab.exynos7904 || {
        # maybe erofs::
        if file /dev/block/by-name/vendor | grep -q "EROFS"; then
            mkdir -p /dev/tmp/install/mount/ /dev/tmp/install/mount_rw/
            umount /vendor
            mount -o relatime /dev/block/by-name/vendor /dev/tmp/install/mount/ || abort "Failed to mount vendor to /dev/tmp/install/mount, please flash this zip again after a reboot."
            cp -a --preserve=all /dev/tmp/install/mount/ /dev/tmp/install/mount_rw/ || abort "Failed to copy stuff to make the vendor rw, please flash this zip again after a reboot."
            echo -e "\n# Added by mkfstab for F2FS support, thank @forsaken_heart24 later!\n/dev/block/platform/13500000.dwmmc0/by-name/cache /cache f2fs nosuid,nodev,noatime,inline_xattr wait,check,formattable\n/dev/block/platform/13500000.dwmmc0/by-name/userdata /data f2fs nosuid,nodev,noatime,inline_xattr,data_flush,fsync_mode=nobarrier latemount,wait,check,encryptable=footer,quota" >> /dev/tmp/install/mount_rw/etc/fstab.exynos7904
            mkfs.erofs -z lz4 --mount-point=/vendor /dev/tmp/install/vendor_erofs.img /dev/tmp/install/mount_rw/ || abort "Failed to make erofs image, please flash this zip again after a reboot."
            cp /dev/tmp/install/vendor_erofs.img ${vendorBlock} || abort "Failed to flash the vendor image, please try again after a reboot."
            twrp format data
        else
            twrp format data
            abort "Failed to add F2FS flags, the ROM won't boot, so please install another ROM and try again."
        fi
    }
elif echo "$3" | tr '[:upper:]' '[:lower:]' | grep -qE "ext4|revert"; then
    mkfs.ext4 -F ${userdataBlock} || abort "Failed to format userdata with ext4"
    mkfs.ext4 -F ${cacheBlock} || abort "Failed to format cache with ext4"
else
    printr "#########################################################"
    printr " _   _            _                _   _ _   _ _"
    printr "| | | | ___  _ __(_)_______  _ __ | | | | |_(_) |___"
    printr "| |_| |/ _ \|  __| |_  / _ \|  _ \| | | | __| | / __|"
    printr "|  _  | (_) | |  | |/ / (_) | | | | |_| | |_| | \__ \\"
    printr "|_| |_|\___/|_|  |_/___\___/|_| |_|\___/ \__|_|_|___/"
    printr "                                                       "      
    printr "#########################################################"
    printr "Add f2fs or switch in the zip name to format userdata and cache to f2fs"
    printr "Add ext4 or revert in the zip name to format userdata and cache to ext4"
    abort "Unsupported filesystem type or action"
fi
printr "Congrats, you've made it here without any errors so far, Thank you for choosing Horizon!"
exit 0

# i'm proud of you because you open up these scripts just to know that these are safe or not
# haha, thank you once again dear.