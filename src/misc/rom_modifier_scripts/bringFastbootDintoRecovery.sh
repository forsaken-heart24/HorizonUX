#!/usr/bin/env bash
#
# Copyright (C) 2025 Luna <luna.realm.io.bennett24@outlook.com> & Ravindu Deshan <Droidcasts@protonmail.com>
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

# def variables:
recoveryFileSize=$(stat -c%s "${RECOVERY_IMAGE_PATH}")
hexPatches=(
    "e10313aaf40300aa6ecc009420010034 e10313aaf40300aa6ecc0094"
    "eec3009420010034 eec3009420010035"
    "3ad3009420010034 3ad3009420010035"
    "50c0009420010034 50c0009420010035"
    "080109aae80000b4 080109aae80000b5"
    "20f0a6ef38b1681c 20f0a6ef38b9681c"
    "23f03aed38b1681c 23f03aed38b9681c"
    "20f09eef38b1681c 20f09eef38b9681c"
    "26f0ceec30b1681c 26f0ceec30b9681c"
    "24f0fcee30b1681c 24f0fcee30b9681c"
    "27f02eeb30b1681c 27f02eeb30b9681c"
    "b4f082ee28b1701c b4f082ee28b970c1"
    "9ef0f4ec28b1701c 9ef0f4ec28b9701c"
    "9ef00ced28b1701c 9ef00ced28b9701c"
    "2001597ae0000054 2001597ae1000054"
    "50860494f3031f2a 5086049433008052"
)

# smol chemk:
command -v lz4 &>/dev/null || abort "Please install lz4 to proceed"
mkdir -p ./local_build/custom_recovery_with_fastbootd/ramdisk
[ ! -f "${RECOVERY_IMAGE_PATH}" ] && abort "The recovery image is not found in the path you've provided, please provide the exact path and try again..." "bringFastbootDintoRecovery"

# unpack the image and patch it:
magiskboot unpack ${RECOVERY_IMAGE_PATH} &>>$thisConsoleTempLogFile || abort "Failed to unpack the given recovery image" "bringFastbootDintoRecovery"
magiskboot cpio ramdisk.cpio 'extract system/bin/recovery ./recovery_patch' &>>$thisConsoleTempLogFile || abort "Failed to extract the required binary from the recovery image." "bringFastbootDintoRecovery"
for hexPatch in "${hexPatches[@]}"; do
    patchFrom=$(echo $hexPatch | awk '{print $1}')
    patchTo=$(echo $hexPatch | awk '{print $2}')
    debugPrint "bringFastbootDintoRecovery(): Patch from: ${patchFrom} | Patch to: ${patchTo}"
    magiskboot hexpatch "./recovery_patch" "$patchFrom" "$patchTo" || abort "Failed to patch the recovery image" "bringFastbootDintoRecovery"
done

# repack the blobs and sign them using avbtool:
magiskboot cpio ramdisk.cpio "add 0755 system/bin/recovery recovery_patch" && rm -rf recovery_patch
magiskboot repack . ./recovery_patched.img
avbtool \
    add_hash_footer \
    --partition_name recovery \
    --partition_size ${recoveryFileSize}
    --image ./recovery_patched.img \
    --key ./test-keys/testkey_rsa2048.pem
    --algorithm SHA256_RSA2048

if ask "Do you want a tar to get this flashed via odin?"; then
    lz4 -B6 --content-size ./recovery_patched.img ./recovery_patched.img.lz4
    tar -cvf "fastbootd-patched-recovery.tar" ./recovery_patched.img.lz4
    console_print "Odin tar file is located at ./recovery_patched.img.lz4"
    rm -rf ./recovery_patched.img ./recovery_patched.img.lz4
fi
rm -rf boot ramdisk.cpio recovery_patch