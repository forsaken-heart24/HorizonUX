#!/usr/bin/env bash

#
# Copyright (C) 2025 BrotherBoard & Luna
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
# BrotherBoard's Telegram >> @GalaxyA14user
# Luna's Telegram >> @forsaken_heart24

# base variables:
OUTPUT="dtbo.${THIS_IS_MY_DEVICE_MAX_REFRESH_RATE}Hz"
THIS_IS_MY_DEVICE_MAX_REFRESH_RATE__=$(printf '%X' $THIS_IS_MY_DEVICE_MAX_REFRESH_RATE)

# initial checks.
for dependencies in mkdtimg imjtool; do
    command -v $dependencies || { warns "Please install $i to continue" "DTHZ_MISSING_DEPENDENCIES"; errors=$(( $errors + 1 )); }
done

[ "$errors" -ge "1" ] && abort "Install those dependencies to continue."
[ ! -f "./config.cfg" ] && abort "Device specific configuration file is not found"

if [ "$THIS_IS_MY_DEVICE_MAX_REFRESH_RATE" -ge "70" ]; then
    warns "you've chose to overclock your device more than 70Hz, please do this at your own risk!" "OVERCLOCK_WARNING"
    warns "revert back to the stock or try to change refresh rate configs again if the device is unable to boot" "OVERCLOCK_WARNING"
fi

# main
echo " - Extracting image"
imjtool $DTBO_IMAGE_PATH extract 
mv extracted $OUTPUT
cd $OUTPUT
echo " - Converting dtb to dts"
for DeviceTreeBlobs in DeviceTree*.dtb; do
    dtc -I dtb -O dts -o "${f%.dtb}.dts" "$f" 
done
rm -rf *.dtb

# fix matches
echo " - Overriding rate matches to ${THIS_IS_MY_DEVICE_MAX_REFRESH_RATE} (${THIS_IS_MY_DEVICE_MAX_REFRESH_RATE__})"
find . -type f -exec sed -i "s/timing,refresh = <0x..>/timing,refresh = <0x${THIS_IS_MY_DEVICE_MAX_REFRESH_RATE__}>/g" {} +
find . -type f -exec sed -i "s/active_fps = <0x..>/active_fps = <0x${THIS_IS_MY_DEVICE_MAX_REFRESH_RATE__}>/g" {} +
find . -type f -exec sed -i "s/display_mode = <0x438 0x968 0x.. 0x00 0x00 0x00 0x00/display_mode = <0x438 0x968 0x${THIS_IS_MY_DEVICE_MAX_REFRESH_RATE__} 0x00 0x00 0x00 0x00/g" {} +

# convert these minions
echo " - Converting dts to dtb"
for DeviceTreeBlobs in DeviceTree*.dts; do
    dtc -I dts -O dtb -o "${f%.dts}.dtb" "$f" 
done
mkdir -p dts
mv *.dts dts/

# finalize these.
if mkdtimg cfg_create ${OUTPUT}.img ../config.cfg -d .; then 
    mv $OUTPUT ..
    mkdir dtb
    mv *.dtb dtb/
    echo " - This build is successful, please do note that:"
    echo "                                                  - no one is responsible for any damage you made to your device"
    echo "                                                  - overclocking more than the stock refresh rate might brake display quality and it's lifetime if it's not capable of running such refresh rates."
    echo -e "\n - The dtbo file is located at $(pwd)/$OUTPUT"
    echo "- Thanks to brotherboard for the base script"
else
    warns "This build is failed" "DTHZ_BUILD_FAILED"
fi