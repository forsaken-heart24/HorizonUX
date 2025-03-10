# Copyright 2025 BrotherBoard & Luna
# BrotherBoard's Telegram >> @GalaxyA14user
# Luna's Telegram >> @forsaken_heart24

# base variables:
DTBO_IMAGE="$1"
REFRESH_RATE="$2"
OUTPUT="dtbo.${REFRESH_RATE}Hz"
REFRESH_RATE__=$(printf '%X' $REFRESH_RATE)

# initial checks.
for dependencies in mkdtimg imjtool; do
    command -v $dependencies || { warns "Please install $i to continue" "DTHZ_MISSING_DEPENDENCIES"; errors=$(( $errors + 1 )); }
done

[ "$errors" -ge "1" ] && abort "Install those dependencies to continue."
[ ! -f "config.cfg" ] && abort "Device specific configuration file is not found"

if [ "$REFRESH_RATE" -ge "70" ]; then
    warns "you've chose to overclock your device more than 70Hz, please do this at your own risk!" "OVERCLOCK_WARNING"
    warns "revert back to the stock or try to change refresh rate configs again if the device is unable to boot" "OVERCLOCK_WARNING"
fi

# main
echo " - Extracting image"
imjtool $DTBO_IMAGE extract 
mv extracted $OUTPUT
cd $OUTPUT
echo " - Converting dtb to dts"
for DeviceTreeBlobs in DeviceTree*.dtb; do
    dtc -I dtb -O dts -o "${f%.dtb}.dts" "$f" 
done
rm -rf *.dtb

# fix matches
echo " - Overriding rate matches to ${REFRESH_RATE} (${REFRESH_RATE__})"
find . -type f -exec sed -i "s/timing,refresh = <0x..>/timing,refresh = <0x${rate}>/g" {} +
find . -type f -exec sed -i "s/active_fps = <0x..>/active_fps = <0x${rate}>/g" {} +
find . -type f -exec sed -i "s/display_mode = <0x438 0x968 0x.. 0x00 0x00 0x00 0x00/display_mode = <0x438 0x968 0x${rate} 0x00 0x00 0x00 0x00/g" {} +

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