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

console_print "Do you want to mount super image and proceed?"
if ask "Type \"yes\" to mount the super image..."; then
    printf "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)\e[0;37m] / [:\e[0;36mMESSAGE\e[0;37m:] / [:\e[0;32mJOB\e[0;37m:] -\e[0;33m Please enter the path to the super.img file: \e[0;37m"
    read super_image_path
    if [ ! -f "$super_image_path" ]; then
        abort "Invalid image path: $super_image_path. Ensure the correct path is provided."
    fi
    mount_super_image "$super_image_path"
    BATTLEMAGE_BUILD=true
    execute_scripts "./build.sh"
else
    BATTLEMAGE_BUILD=false
    execute_scripts "./build.sh"
fi

# Cache these headaches
if ! $BATTLEMAGE_BUILD; then
    if [ ! -f "${SYSTEM_DIR}/build.prop" ] && [ ! -f "${SYSTEM_DIR}/system/build.prop" ]; then
        abort "The system partition is not found."
    elif [ ! -f "${SYSTEM_EXT_DIR}/etc" ] && [ ! -f "${SYSTEM_EXT_DIR}/system_ext/etc" ]; then
        abort "The system_ext partition is not found."
    elif [ ! -f "${VENDOR_DIR}" ] && [ ! -f "${VENDOR_DIR}/vendor" ]; then
        abort "The vendor partition is not found."
    elif [ ! -f "${PRODUCT_DIR}" ] && [ ! -f "${PRODUCT_DIR}/product" ]; then
        abort "The product partition is not found."
    fi
else
    for partition in system vendor product; do
        if echo "$katarenai" | grep -q "$partition"; then
            if check_build_prop "$HASH_KEY_FOR_SUPER_BLOCK_PATH/$partition"; then
                set_partition_flag "$partition"
            fi
        fi
    done
    HORIZON_PRODUCT_DIR=$(kang_dir "product")
    HORIZON_SYSTEM_DIR=$(kang_dir "system")
    HORIZON_SYSTEM_EXT_DIR=$(kang_dir "system_ext")
    HORIZON_VENDOR_DIR=$(kang_dir "vendor")
fi

if ! $BATTLEMAGE_BUILD; then
    for partition in system vendor product; do
        check_partition_in_target "$partition"
        if ! check_build_prop "$HASH_KEY_FOR_SUPER_BLOCK_PATH/$partition"; then
            abort "The $partition partition doesn't have a build.prop file. Please extract or mount the images again..."
        fi
    done
    HORIZON_PRISM_DIR=$PRISM_DIR
    HORIZON_PRODUCT_DIR=$PRODUCT_DIR
    HORIZON_SYSTEM_DIR=$SYSTEM_DIR
    HORIZON_SYSTEM_EXT_DIR=$SYSTEM_EXT_DIR
    HORIZON_VENDOR_DIR=$VENDOR_DIR
fi

for partition in system vendor; do
    check_partition_in_target "$partition"
done

# Stack build properties into a temporary directory
console_print "Storing the ROM's build properties into a temporary directory..."
stack_build_properties

# cook a temporary file.. 
if command -v mktemp; then
	TMPFILE=$(mktemp)
else
	TMPFILE="../local_build/logs/bomboclattt"
fi

# make a variable to route to the build.prop files directly
HORIZON_PRISM_PROPERTY_FILE=$(find_partition_property_file "prism")
HORIZON_PRODUCT_PROPERTY_FILE=$(find_partition_property_file "product")
HORIZON_SYSTEM_PROPERTY_FILE=$(find_partition_property_file "system")
HORIZON_SYSTEM_EXT_PROPERTY_FILE=$(find_partition_property_file "system_ext")
HORIZON_VENDOR_PROPERTY_FILE=$(find_partition_property_file "vendor")

# make a variable to route to the overlay directly
HORIZON_PRODUCT_OVERLAY=$(
    if [ -f "$HORIZON_PRODUCT_DIR/overlay" ]; then
        echo "$HORIZON_PRODUCT_DIR/overlay"
    elif [ -f "$HORIZON_SYSTEM_DIR/product/overlay" ]; then
        echo "$HORIZON_SYSTEM_DIR/product/overlay"
    fi
)
HORIZON_VENDOR_OVERLAY=$HORIZON_HORIZON_VENDOR_DIR/overlay
HORIZON_FALLBACK_OVERLAY_PATH=$(
    if [ ! -f "$HORIZON_PRODUCT_OVERLAY" ] || [ -z "$HORIZON_PRODUCT_OVERLAY" ]; then
        echo "$HORIZON_VENDOR_OVERLAY"
    else 
        echo "$HORIZON_PRODUCT_OVERLAY"
    fi
)

# boom
if ! $testEnv; then
	if [ ! -d "${SCRIPTS[1]}" ]; then
		abort "Script files are missing, exiting..."
	elif [ -z "$(command -v zip)" ]; then
		abort "zip is not installed. Please install it to proceed."
	elif [ ! -d "$(command -v python3)" ]; then
		warns "python3 is not installed. It's not required unless you want to patch your recovery image." "$(echo "DEPENDENCIES_ERRORS" | tr '[:lower:]' '[:upper:]')"
	elif [ -z "${JAVA_HOME}" ]; then
		abort "Please install the latest openjdk to proceed."
	fi
fi

# bomboclatt
for i in $HORIZON_SYSTEM_DIR/etc/floating_feature.xml $HORIZON_VENDOR_DIR/etc/floating_feature.xml; do
    if [ -f "${i}" ]; then
        TARGET_BUILD_FLOATING_FEATURE_PATH="${i}"
        break
    fi
done
TARGET_BUILD_CSC_FEATURE_PATH="$HORIZON_PRODUCT_DIR/omc/${PRODUCT_CSC_NAME}/conf/cscfeature.xml"
if [ ! -f "$TARGET_BUILD_CSC_FEATURE_PATH" ]; then
    abort " Product CSC File is not found, please change the \"PRODUCT_CSC_NAME\" (in makeconfigs.prop) according to the one in your product image"
else
    file $TARGET_BUILD_CSC_FEATURE_PATH | grep -q "cscfeature.xml: data" && tinkerWithCSCFeaturesFile --decode
fi

# idk bruv
BUILD_USERNAME="$(string_format --upper "$(id -un | cut -c 1-1)")$(id -un | cut -c 2-200)"
thisConsole=$(command -v x-terminal-emulator || command -v gnome-terminal || command -v xfce4-terminal || command -v konsole || command -v xterm || command -v urxvt || command -v mate-terminal || command -v lxterminal)
thisConsoleTempLogFile=$(mktemp || touch /tmp/$(generate_random_hash "20"))
[ ! -n "$thisConsole" ] && warns "Can't find your terminal to show logs, the logs were stored as a file as always." "LOGVIEWER"
if [ "$(string_format -l $openSeperateConsoleForDebugging)" == "true" ]; then
    if [ -n "$thisConsoleTempLogFile" ] && [ -f "$thisConsoleTempLogFile" ]; then
        {
            echo -e "########################################################################"
            echo -e "   _  _     _   _            _                _   ___  __"
            echo -e " _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \/ /"
            echo -e "|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / "
            echo -e "|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ "
            echo -e "  |_||_|   |_| |_|\___/|_|  |_/___\\___/|_| |_|\___//_/\\_\\"
            echo -e "                                                         "
            echo -e "########################################################################"
        } >> $thisConsoleTempLogFile
        nohup "${thisConsole}" -e bash -c "tail -f '$thisConsoleTempLogFile'; exec bash" > /dev/null 2>&1 &
        pid=$!
    fi
fi