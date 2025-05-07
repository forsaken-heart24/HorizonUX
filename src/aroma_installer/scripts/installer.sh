# import the functions and variables.
source "${INSTALLER}/scripts/util_functions.sh"

# installer variables, please change these:
# every images should be in that specified format!
imageType="raw"

# put your flashable images list here:
flashables="horizon/example.img -> example horizon/example1.img -> example1"

# now the real functions start!
consolePrint "########################################################################"
consolePrint "   _  _     _   _            _                _   ___  __"
consolePrint " _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \/ /"
consolePrint "|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / "
consolePrint "|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ "
consolePrint "  |_||_|   |_| |_|\___/|_|  |_/___\\___/|_| |_|\___//_/\\_\\"
consolePrint "                                                         "
consolePrint "########################################################################"
consolePrint "Flashing example image unconditionally..."
unmountPartitions && consolePrint "Successfully unmounted partitions!"
set -- $flashables
while [ "$1" ]; do
    image="$1"
    shift
    delimiter="$1"
    shift
    target="$1"
    shift
    if [ "$delimiter" = "->" ]; then
        installImages "$image" "$target"
    else
        consolePrint "Error: Expected '->' but got '$delimiter'"
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
consolePrint "Flashing example image done!"
busybox fstrim /data
busybox fstrim /system