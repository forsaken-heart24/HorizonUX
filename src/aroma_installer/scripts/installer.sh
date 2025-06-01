# import the functions and variables.
source "${INSTALLER}/scripts/util_functions.sh"

# put your flashable images list here:
flashables="horizon/system_example.img -> system -> raw horizon/vendor_example.img -> vendor -> sparse"

# device codename / model detection, better put your device's codename / model for checking it
# the "|" works as a separator.
supportedDeviceCodenameList="surya|karna"

# now the real functions start!
consolePrint "########################################################################"
consolePrint "   _  _     _   _            _                _   ___  __"
consolePrint " _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \/ /"
consolePrint "|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / "
consolePrint "|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ "
consolePrint "  |_||_|   |_| |_|\___/|_|  |_/___\\___/|_| |_|\___//_/\\_\\"
consolePrint "                                                         "
consolePrint "########################################################################"
getprop ro.product.system.device | grep -qE "${supportedDeviceCodenameList}" || abort "This build is made for ${supportedDeviceCodenameList} not for your device."
unmountPartitions && consolePrint "Successfully unmounted partitions!" || abort "Failed to unmount partitions, please try again after a reboot."
set -- $flashables
while [ "$1" ]; do
image="$1"
    shift
    delimiter="$1"
    shift
    target="$1"
    shift
    shift
    imageType="$1"
    shift
    if [ "$delimiter" = "->" ]; then
        consolePrint "Patching $(basename "${image}" .img) image unconditionally..."
        installImages "$image" "$target" "${imageType}"
    else
        abort "Error: Expected '->' but got '$delimiter'"
    fi
done
if [ "$(getAromaProp "item.1.1" "/tmp/example.prop")" = "1" ]; then
    consolePrint "Installing Option1 add-on..."
    sleep 1
fi
if [ "$(getAromaProp "item.1.2" "/tmp/example.prop")" = "1" ]; then
    consolePrint "Installing Option2 add-on..."
    sleep 1
fi
if [ "$(getAromaProp "item.1.3" "/tmp/example.prop")" = "1" ]; then
    consolePrint "Installing Option3 add-on..."
    sleep 1
fi