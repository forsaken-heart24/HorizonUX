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

# booooooooooooom
if $(echo $RECOVERY_IMAGE_PATH | grep -q lz4); then
    abort "blud extract the image and give the raw image path, im lazy bish"
fi

# Check for recovery images
if existance "$RECOVERY_IMAGE_PATH"; then
    mv "$RECOVERY_IMAGE_PATH" "./build/custom_recovery_with_fastbootd/raw.img"
    warns "Found unzipped image!" "RECOVERY_IMAGE_PATCHER"
else
    abort "No image to patch found."
fi

# Edit raw image
console_print "Editing image..."
off=$(grep -ab -o SEANDROIDENFORCE raw.img | tail -n 1 | cut -d : -f 1)
dd if=raw.img of=header.img bs=4k count="$off" iflag=count_bytes

# bomb
console_print "Done editing the given image!"
console_print "checking the file..."
if existance "./build/custom_recovery_with_fastbootd/header.img"; then
    console_print "finished!"
else
    abort "file check on header.img failed"
fi

# Make keystore file.
mkdir "./build/custom_recovery_with_fastbootd/keys"
openssl genrsa -f4 -out "$csd/keys/phh.pem" 4096 

# Fragment the edited image
mkdir "./build/custom_recovery_with_fastbootd/fragments"
cd "./build/custom_recovery_with_fastbootd/fragments" || exit
./dependencies/bin/magiskboot unpack "./build/custom_recovery_with_fastbootd/header.img"
./dependencies/bin/magiskboot cpio ramdisk.cpio extract

if existance "./build/custom_recovery_with_fastbootd/fragments/system/bin/recovery"; then
    console_print "successfully fragmented image!" 
else 
    abort "fragmentation failed!"
fi

# Patch the fragmented image
console_print "Patching the recovery image.."
for patch in \
    "e10313aaf40300aa6ecc009420010034 e10313aaf40300aa6ecc0094" \
    "eec3009420010034 eec3009420010035" \
    "3ad3009420010034 3ad3009420010035" \
    "50c0009420010034 50c0009420010035" \
    "080109aae80000b4 080109aae80000b5" \
    "20f0a6ef38b1681c 20f0a6ef38b9681c" \
    "23f03aed38b1681c 23f03aed38b9681c" \
    "20f09eef38b1681c 20f09eef38b9681c" \
    "26f0ceec30b1681c 26f0ceec30b9681c" \
    "24f0fcee30b1681c 24f0fcee30b9681c" \
    "27f02eeb30b1681c 27f02eeb30b9681c" \
    "b4f082ee28b1701c b4f082ee28b970c1" \
    "9ef0f4ec28b1701c 9ef0f4ec28b9701c" \
    "9ef00ced28b1701c 9ef00ced28b9701c" \
    "2001597ae0000054 2001597ae1000054"
do
    src="${patch%% *}"
    dst="${patch##* }"
    ./dependencies/bin/magiskboot hexpatch "./build/custom_recovery_with_fastbootd/fragments/system/bin/recovery" $src $dst
done

# Reassemble fragmented image
mkdir "./build/custom_recovery_with_fastbootd/output"
console_print "Attempting to defragment image! If your image is corrupted, this may not end well..."
./build/custom_recovery_with_fastbootd/magiskboot repack "./build/custom_recovery_with_fastbootd/header.img" "./build/custom_recovery_with_fastbootd/output/output.img"

if existance "./build/custom_recovery_with_fastbootd/output/output.img"; then
    console_print "Assembled output.img!"
    cd "./build/custom_recovery_with_fastbootd/"
else
    abort "output.img not found, exiting.."
fi

# Sign patched image with keyfile
console_print "Signing patched image with generated openssh key..."
python3 "./dependencies/bin/avbtool" extract_public_key --key "./build/custom_recovery_with_fastbootd/keys/phh.pem" --output "./build/custom_recovery_with_fastbootd/keys/phh.pub.bin" &&
python3 "./dependencies/bin/avbtool" add_hash_footer --image "./build/custom_recovery_with_fastbootd/output/output.img" --partition_name recovery --partition_size "$(wc -c < "$csd/raw.img")" --key "./build/custom_recovery_with_fastbootd/keys/phh.pem" --algorithm SHA256_RSA4096
console_print "Signed image successfully!"

if ask "Do you want to make an odin tar for flashing the patched recovery image?"; then
    tar -cvf "./build/custom_recovery_with_fastbootd/output/output.tar" "./build/custom_recovery_with_fastbootd/output/output.img"
    md5sum -t "./build/custom_recovery_with_fastbootd/output/output.tar" >> "./build/custom_recovery_with_fastbootd/output/output.tar"
    mv "./build/custom_recovery_with_fastbootd/output/output.tar" "./build/custom_recovery_with_fastbootd/output/output.tar.md5"
fi

console_print "Image has been patched and it's saved in the ./build/custom_recovery_with_fastbootd/output/ directory.."