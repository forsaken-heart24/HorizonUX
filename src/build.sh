#!/usr/bin/env bash
#
# Copyright (C) 2025 Luna <luna.realm.io.bennett24@outlook.com>
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

# misc variables
BUILD_USERNAME="$2"
[ -z "${BUILD_USERNAME}" ] && BUILD_USERNAME="$(tr '[:lower:]' '[:upper:]' <<< "$(id -un | cut -c1-1)")$(id -un | cut -c2-)"
thisConsoleTempLogFile="./local_build/logs/hux_build.log"
rm -rf ./local_build/logs/*
TMPDIR="$(mktemp -d)"
TMPFILE="$(mktemp)"
[ ! -f "${thisConsoleTempLogFile}" ] && touch $thisConsoleTempLogFile
argOne="$1"
loggedFloatingFeaturePATH="no"

# Trap the SIGINT signal (Ctrl+C) and call handle_sigint when it's caught
trap 'abort "Aborting the build....."' SIGINT

# jst execve ts 2 fix bugs:
for i in ./src/misc/build_scripts/util_functions.sh ./src/makeconfigs.prop ./src/monika.conf; do
	if [ ! -f "$i" ]; then
		echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] [:\e[0;36mABORT\e[0;37m:] -\e[0;31m Can't find $i file, please try again later...\e[0;37m"
		sleep 0.5
		exit 1
	else
		debugPrint "build.sh: Executing ${i}.."
		source "$i"
	fi
done

# ok, fbans dropped!
for dependenciesRequiredForTheBuild in java python3 zip lz4; do
	command -v ${dependenciesRequiredForTheBuild} &>/dev/null || abort "${dependenciesRequiredForTheBuild} is not found in the build environment, please check the guide again.."
done

# shit was cringy before lfmao 💀🙏
for i in system/product/priv-app system/product/etc system/product/overlay \
		system/etc/permissions system/product/etc/permissions custom_recovery_with_fastbootd/ \
		system/etc/init/ tmp/hux/ etc/extract/super_extract etc/imageSetup/product etc/imageSetup/system etc/imageSetup/vendor etc/imageSetup/optics etc/downloadedContents \
		etc/buildedContents; do
			[ -f "./local_build/${i}" ] || continue
			mkdir -p "./local_build/$i"
			debugPrint "build.sh: Making ./local_build/${i} directory.."
done

# TODO: re-run the script with root permissions to manage mounted images
case "$(id -u)" in
	0)
		clear
		debugPrint "build.sh: Script ran once again with root privilages."
	;;
	*)
		if string_format -l "$(file "${argOne}")" | grep -q zip || echo "$argOne" | grep -qE "samfw|samfwpremium"; then
			console_print "You will be prompted to put your sudo password to mount stuff in ./local_build/etc/imageSetup"
			console_print "if you are worried, you can always check the script before entering the sudo password."
			debugPrint "build.sh: Relaunching the script with root privilages..."
			sudo "$0" "$argOne" "$BUILD_USERNAME"
		fi
	;;
esac

# bruh
clear
echo -e "\033[0;31m########################################################################"
echo -e "   _  _     _   _            _                _   ___  __"
echo -e " _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \/ /"
echo -e "|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / "
echo -e "|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ "
echo -e "  |_||_|   |_| |_|\___/|_|  |_/___\\___/|_| |_|\___//_/\\_\\"
echo -e "                                                         "
echo -e "########################################################################\033[0m"
console_print "Starting to build HorizonUX ${CODENAME} - v${CODENAME_VERSION_REFERENCE_ID} on ${BUILD_USERNAME}'s computer..."
console_print "Build started by $BUILD_USERNAME at $(date +%I:%M%p) on $(date +%d\ %B\ %Y)"
console_print "CPU Architecture : $(lscpu | grep Architecture | awk '{print $2}')"
console_print "Available RAM Memory : $(free -h --giga | grep Mem | awk '{print $7}')"
console_print "The Computer is turned on since : $(uptime --pretty | awk '{print substr($0, 4)}')"

# check:
if [ -n "$argOne" ]; then
	if string_format --lower "$(file $argOne)" | grep -q zip; then
		if [ ! -f "./local_build/lpunpack_and_lpmake" ]; then
			check_internet_connection &>/dev/null || abort "Please proceed with an active internet connection to build LonelyFool's lptools from source."
			cd ./local_build/
			branchToFork=android10
			ask "Your build SDK version is above or equal to 30 right?" && branchToFork=android11
			git clone --branch $branchToFork "https://github.com/LonelyFool/lpunpack_and_lpmake.git"
			cd lpunpack_and_lpmake
			chmod +x ./make.sh
			console_print "Building LonelyFool's lptools from source, this might take sometime..."
			console_print "This is a one time build, future builds won't rebuild the tool or require internet connection to build."
			./make.sh &>/dev/ || abort "Failed to build lptools, please try again.." "build.sh"
			cd ../
			# we are outside local_build
			mv ./local_build/lpunpack_and_lpmake/bin/* ./src/dependencies/bin/
			export PATH="$PATH:$(dirname "$(realpath "$0")")/src/dependencies/bin"
		else
			export PATH="$PATH:$(dirname "$(realpath "$0")")/src/dependencies/bin"
		fi
		if unzip -l "$argOne" | grep -qE "AP_|HOME_CSC"; then
			# skip extracting if the archives were found.
			if [[ -f "$(echo -e ./local_build/etc/extract/AP_*.tar.md5)" && -f "$(echo -e ./local_build/etc/extract/HOME_CSC_*.tar.md5)" ]]; then
				console_print "Skipping firmware extraction, target firmware files are already extracted and saved."
				extractedAPFilePath="$(echo -e ./local_build/etc/extract/AP_*.tar.md5)"
				extractedHomeCSCFilePath="$(echo -e ./local_build/etc/extract/HOME_CSC_*.tar.md5)"
			else
				# unzip -o test.zip nos/README_Kernel.txt -d nos | grep inflating | awk '{print $2}'
				console_print "Trying to extract $(unzip -l $argOne | grep AP_ | awk '{print $4}') from the archive...."
				extractedAPFilePath=$(unzip -o $argOne $(unzip -l $argOne | grep AP_ | awk '{print $4}') -d ./local_build/etc/extract/ | grep inflating | awk '{print $2}')
				[ -z "${extractedAPFilePath}" ] && abort "Failed to extract AP from $argOne" "build.sh"
				debugPrint "Processing AP tar file from the given firmware package...."
				tar -tf "$extractedAPFilePath" | grep -qE "system|super|vendor|optics" || abort "The $extractedAPFilePath doesn't have system, vendor, optics or even super. Try again with a samfw.com dump!" "build.sh"
				console_print "Trying to extract $(unzip -l $argOne | grep HOME_CSC | awk '{print $4}') from the archive...."
				extractedHomeCSCFilePath=$(unzip -o $argOne $(unzip -l $argOne | grep HOME_CSC | awk '{print $4}') -d ./local_build/etc/extract/ | grep inflating | awk '{print $2}')
				[ -z "${extractedHomeCSCFilePath}" ] && abort "Failed to extract HOME_CSC from $argOne" "build.sh"
			fi
			# ight, so, basically even if we have both of these on our firmware, wwe dont need to worry cuz ive made sure that CSC features sets to omc/*/conf/cscfeature.xml
			# like product/omc/*/conf/cscfeature.xml and optics/omc/*/conf/cscfeature.xml *ONLY* if that XML file was found!
			for cscStuff in product optics; do
				tar -tf "$extractedHomeCSCFilePath" | grep -q "${cscStuff}.img.lz4" || continue
				console_print "Extracting ${cscStuff}..."
				tar -C ./local_build/etc/extract/ -xf $extractedHomeCSCFilePath ${cscStuff}.img.lz4 &>> ${thisConsoleTempLogFile}
				logInterpreter "Trying to extract ${cscStuff}.img from an LZ4 archive..." "lz4 -d ./local_build/etc/extract/${cscStuff}.img.lz4 ./local_build/etc/extract/${cscStuff}.img" || abort "Failed to extract $cscStuff from an lz4 archive." "logInterpreter"
				rm -rf ./local_build/etc/extract/${cscStuff}.img.lz4
				# TODO: convert images into raw if not already:
				logInterpreter "Converting $cscStuff from sparse to raw image factor...." "simg2img ./local_build/etc/extract/${cscStuff}.img ./local_build/etc/extract/${cscStuff}_raw.img"
				rm ./local_build/etc/extract/${cscStuff}.img
				mv ./local_build/etc/extract/${cscStuff}_raw.img ./local_build/etc/extract/${cscStuff}.img
				setupLocalImage ./local_build/etc/extract/${cscStuff}.img ./local_build/etc/imageSetup/${cscStuff}
			done
			for androidOS in super system vendor; do
				if [ "${androidOS}" == "super" ]; then
					tar -tf "$extractedAPFilePath" | grep -q "super.img.lz4" || continue
					console_print "Extracting super..."
					tar -C "./local_build/etc/extract/" -xf "$extractedAPFilePath" "super.img.lz4" &>> ${thisConsoleTempLogFile} || abort "Failed to extract super.img.lz4 from the tar file." "build.sh"
					logInterpreter "Trying to extract super.img from an LZ4 archive..." "lz4 -d ./local_build/etc/extract/super.img.lz4 ./local_build/etc/extract/" || abort "Failed to extract super image from an lz4 archive." "build.sh"
					rm -rf ./local_build/etc/extract/super.img.lz4
					lpdump "./local_build/etc/extract/super.img" > ./local_build/etc/dumpOfTheSuperBlock &>>$thisConsoleTempLogFile || abort "Failed to dump metadata from super.img" "build.sh"
					lpunpack "./local_build/etc/extract/super.img" "./local_build/etc/extract/super_extract/" &>>$thisConsoleTempLogFile || abort "Failed to unpack super.img" "build.sh"
					for COMMON_FIRMWARE_BLOCKS in ./local_build/etc/extract/super_extract/*.img; do 
						echo "$(basename "${COMMON_FIRMWARE_BLOCKS}" .img)" | grep -qE "system|vendor|product" || continue
						mountPath="./local_build/etc/imageSetup/$(basename ${COMMON_FIRMWARE_BLOCKS} .img)"
						setupLocalImage "${COMMON_FIRMWARE_BLOCKS}" "${mountPath}"
					done
				else
					console_print "Extracting $androidOS..."
					tar -tf "$extractedAPFilePath" | grep -q "${androidOS}.img.lz4" && tar -C ./local_build/etc/extract -xf $extractedAPFilePath ${androidOS}.img.lz4 &>> ${thisConsoleTempLogFile} || abort "Failed to extract $androidOS from an tar file." "build.sh"
					logInterpreter "Trying to extract ${androidOS}.img from an LZ4 archive..." "lz4 -d ./local_build/etc/extract/${androidOS}.img.lz4 ./local_build/etc/extract/${androidOS}.img" || abort "Failed to extract $androidOS from an lz4 archive." "build.sh"
					rm -rf ./local_build/etc/extract/${androidOS}.img.lz4
					# TODO: convert images into raw if not already:
					logInterpreter "Converting $androidOS from sparse to raw image factor...." "simg2img ./local_build/etc/extract/${androidOS}.img ./local_build/etc/extract/${androidOS}_raw.img"
					rm ./local_build/etc/extract/${androidOS}.img
					mv ./local_build/etc/extract/${androidOS}_raw.img ./local_build/etc/extract/${androidOS}.img
					setupLocalImage ./local_build/etc/extract/${androidOS}.img ./local_build/etc/imageSetup/${androidOS}
				fi
			done
			# TODO: switch to device config if the ro.product.system.device is supported
			# source the props again to replace the values.
			source "./src/makeconfigs.prop"
			touch ./localFirmwareBuildPending
		elif echo "$argOne" | grep -qE "samfw|samfwpremium"; then
			check_internet_connection &>/dev/null || abort "I don't have internet access to download given samfw firmware package." "build.sh"
			download_stuffs $argOne ./local_build/etc/downloadedContents/firmware.zip
			# re-exec because we alr have code to manage with zip files.
			./src/build.sh "./local_build/etc/downloadedContents/firmware.zip"
		fi
	fi
else
	# TODO: Check system,vendor before modding stuffs:
	[[ -f "${SYSTEM_DIR}/build.prop" && -f "${VENDOR_DIR}/build.prop" ]] || abort "System or vendor partition is not a valid partition!" "build.sh"
fi

# Locate build.prop files
HORIZON_PRODUCT_PROPERTY_FILE=$(check_build_prop "${PRODUCT_DIR}")
HORIZON_SYSTEM_PROPERTY_FILE=$(check_build_prop "${SYSTEM_DIR}")
HORIZON_SYSTEM_EXT_PROPERTY_FILE=$(check_build_prop "${SYSTEM_EXT_DIR}")
HORIZON_VENDOR_PROPERTY_FILE=$(check_build_prop "${VENDOR_DIR}")

# Locate overlay paths
if [ -d "$PRODUCT_DIR/overlay" ]; then
    HORIZON_PRODUCT_OVERLAY="$PRODUCT_DIR/overlay"
elif [ -d "$SYSTEM_DIR/product/overlay" ]; then
    HORIZON_PRODUCT_OVERLAY="$SYSTEM_DIR/product/overlay"
fi
HORIZON_VENDOR_OVERLAY="$VENDOR_DIR/overlay"
HORIZON_FALLBACK_OVERLAY_PATH="${HORIZON_VENDOR_OVERLAY}"

# fix: "grep: /build.prop: No such file or directory" moved to build.sh to fix that error.
BUILD_TARGET_ANDROID_VERSION="$(grep_prop "ro.build.version.release" "${HORIZON_SYSTEM_PROPERTY_FILE}")"
BUILD_TARGET_SDK_VERSION="$(grep_prop "ro.build.version.sdk" "${HORIZON_SYSTEM_PROPERTY_FILE}")"
BUILD_TARGET_VENDOR_SDK_VERSION="$(grep_prop "ro.vndk.version" "${HORIZON_VENDOR_PROPERTY_FILE}")"
BUILD_TARGET_MODEL="$(grep_prop "ro.product.system.model" "${HORIZON_SYSTEM_PROPERTY_FILE}")"
[ -z "${TARGET_BUILD_PRODUCT_NAME}" ] && TARGET_BUILD_PRODUCT_NAME="$(grep_prop "ro.product.system.device" "${HORIZON_SYSTEM_PROPERTY_FILE}")"

# device specific customization:
if [ -d "./target/${TARGET_BUILD_PRODUCT_NAME}" ]; then
	debugPrint "build.sh: Device specific config and blobs are found, customizing the rom...."
	source "./src/target/${TARGET_BUILD_PRODUCT_NAME}/buildTargetProperties.conf"
else
	debugPrint "build.sh: Using genericTargetProperties.conf for configs..."
	source "./src/genericTargetProperties.conf"
fi

################ boom
if [ "$TARGET_BUILD_IS_FOR_DEBUGGING" == "true" ]; then
	debugPrint "build.sh: Debug flags are getting enabled"
    for i in "logcat.live enable" "sys.lpdumpd 1" "persist.debug.atrace.boottrace 1" "persist.device_config.global_settings.sys_traced 1" \
		"persist.traced.enable 1" "log.tag.ConnectivityManager V" "log.tag.ConnectivityService V" "log.tag.NetworkLogger V" "log.tag.IptablesRestoreController V" \
		"log.tag.ClatdController V" "persist.sys.lmk.reportkills false" "security.dsmsd.enable true" "persist.log.ewlogd 1" \
		"sys.config.freecess_monitor true" "persist.heapprofd.enable 1" "traced.lazy.heapprofd 1" "debug.enable true" "sys.wifitracing.started 1" \
		"security.edmaudit false" "ro.sys.dropdump.on On" "persist.systemserver.sa_bindertracker false"; do
		setprop --system "$(echo $i | awk '{print $1}')" "$(echo $i | awk '{print $2}')"
    done
	echo -e "\n############ WARNING, EXPERIMENTAL FLAGS AHEAD!\nsetprop log.tag.snap_api::snpe VERBOSE\nsetprop log.tag.snap_api::V3 VERBOSE\nsetprop log.tag.snap_api::V2 VERBOSE\nsetprop log.tag.snap_compute::V3 VERBOSE\nsetprop log.tag.snap_compute::V2 VERBOSE\nsetprop log.tag.snaplite_lib VERBOSE\nsetprop log.tag.snap_api::snap_eden::V3 VERBOSE\nsetprop log.tag.snap_api::snap_ofi::V1 VERBOSE\nsetprop log.tag.snap_hidl_v3 VERBOSE\nsetprop log.tag.snap_service@1.2 VERBOSE\n############ WARNING, EXPERIMENTAL FLAGS AHEAD!" > $SYSTEM_DIR/etc/init/init.debug_castleprops.rc
	warns "Debugging stuffs are enabled in this build, please proceed with caution and do remember that your device will heat more due to debugging process running in the background.." "DEBUGGING_ENABLER"
	# change the values to enable debugging without authorization.
	for i in "ro.debuggable 1" "ro.adb.secure 0"; do 
		setprop --system "$(echo $i | awk '{print $1}')" "$(echo $i | awk '{print $2}')"
	done
	setprop --product "persist.sys.usb.config" "mtp,adb"
fi

# warn users about test key
[ "$MY_KEYSTORE_PATH" == "./test-keys/HorizonUX-testkey.jks" ] && warns "NOTE: You are using HorizonUX test-key! This is not safe for public builds. Use your own key!" "TEST_KEY_WARNS"

if [ "$BUILD_TARGET_ANDROID_VERSION" == "14" ]; then
	console_print "Removing some bloats, thnx Salvo!"
	rm -rf $SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.kgclient.xml $SYSTEM_DIR/etc/public.libraries-wsm.samsung.txt \
	$SYSTEM_DIR/lib/libhal.wsm.samsung.so \
	$SYSTEM_DIR/lib/vendor.samsung.hardware.security.wsm.service-V1-ndk.so \
	$SYSTEM_DIR/lib64/libhal.wsm.samsung.so \
	$SYSTEM_DIR/lib64/vendor.samsung.hardware.security.wsm.service-V1-ndk.so \
	$SYSTEM_DIR/priv-app/KnoxGuard
fi

if [[ "$TARGET_REMOVE_USELESS_SAMSUNG_APPLICATIONS_STUFFS" == "true" && -f "./target/${TARGET_BUILD_PRODUCT_NAME}/debloater.sh" ]]; then
	. "./target/${TARGET_BUILD_PRODUCT_NAME}/debloater.sh"
elif [[ "$TARGET_REMOVE_USELESS_SAMSUNG_APPLICATIONS_STUFFS" == "true" ]]; then
	. ${SCRIPTS[5]}
fi

if [ "$TARGET_INCLUDE_UNLIMITED_BACKUP" == "true" ]; then
	console_print "Adding unlimited backup feature...."
	. ${SCRIPTS[0]}
fi

if [ "$BUILD_TARGET_REQUIRES_BLUETOOTH_LIBRARY_PATCHES" == "true" ]; then
	console_print "Patching bluetooth...."
	[ -f "$SYSTEM_DIR/lib64/libbluetooth_jni.so" ] || abort "The \"libbluetooth_jni.so\" file from the system/lib64 wasn't found" "build.sh"
	magiskboot hexpatch "$SYSTEM_DIR/lib64/libbluetooth_jni.so" "6804003528008052" "2b00001428008052" || warns "Failed to patch the bluetooth library, please try again!" "BLUETOOTH_PATCH_FAIL"
fi

[ "$BUILD_TARGET_INCLUDE_FASTBOOTD_PATCH" == "true" ] && . ${SCRIPTS[2]}

if [ "$TARGET_REMOVE_NONE_SECURITY_OPTION" == "true" ]; then
	console_print "Removing none security option from lockscreen settings..."
	change_xml_values "config_hide_none_security_option" "true" "./src/horizon/overlay_packages/settings/horizonux.autogenerated_rro/res/values/bools.xml"
fi

if [ "$TARGET_REMOVE_SWIPE_SECURITY_OPTION" == "true" ]; then
	console_print "Removing swipe security option from lockscreen settings..."
	change_xml_values "config_hide_swipe_security_option" "true" "./src/horizon/overlay_packages/settings/horizonux.autogenerated_rro/res/values/bools.xml"
fi

if [[ "$TARGET_REMOVE_NONE_SECURITY_OPTION" == "true" || "$TARGET_REMOVE_SWIPE_SECURITY_OPTION" == "true" ]]; then
	console_print "Building the overlay for disabling unsecure security options..."
	build_and_sign "${DECODEDAPKTOOLPATHS[0]}" "$HORIZON_FALLBACK_OVERLAY_PATH"
fi

if [ "$TARGET_ADD_EXTRA_ANIMATION_SCALES" == "true" ]; then
	console_print "Adding Extra animation scales.."
	build_and_sign "${DECODEDAPKTOOLPATHS[1]}" "$HORIZON_FALLBACK_OVERLAY_PATH"
fi

if [[ "$TARGET_ADD_ROUNDED_CORNERS_TO_THE_PIP_WINDOWS" == "true" && "$BUILD_TARGET_ANDROID_VERSION" == "11" ]]; then
	console_print "Adding rounded corners on pip window...."
	build_and_sign "${DECODEDAPKTOOLPATHS[2]}" "$HORIZON_FALLBACK_OVERLAY_PATH"
fi

if [ "$TARGET_FLOATING_FEATURE_INCLUDE_GAMELAUNCHER_IN_THE_HOMESCREEN" == "true" ]; then
	console_print "Enabling Game Launcher..."
	add_float_xml_values "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_DEFAULT_GAMELAUNCHER_ENABLE" "TRUE"
else
	console_print "Disabling Game Launcher..."
	add_float_xml_values "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_DEFAULT_GAMELAUNCHER_ENABLE" "FALSE"
fi

if [ "$BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES" == "true" ]; then
	console_print "Switching the default refresh rate to ${BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE}Hz..."
	add_float_xml_values "SEC_FLOATING_FEATURE_LCD_CONFIG_HFR_DEFAULT_REFRESH_RATE" "${BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE}"
else
	console_print "Switching the default refresh rate to 60Hz"
	add_float_xml_values "SEC_FLOATING_FEATURE_LCD_CONFIG_HFR_DEFAULT_REFRESH_RATE" "60"
fi

if [ "$TARGET_FLOATING_FEATURE_INCLUDE_SPOTIFY_AS_ALARM" == "true" ]; then
	console_print "Adding spotify as an option in the clock app.."
	add_float_xml_values "SEC_FLOATING_FEATURE_CLOCK_CONFIG_ALARM_SOUND" "spotify"
fi

if [ "$TARGET_FLOATING_FEATURE_BATTERY_SUPPORT_BSOH_SETTINGS" == "true" ]; then
	console_print "This feature needs some patches to work on some roms, if you dont"
	console_print "see anything in the settings, please remove this on the next build."
	add_float_xml_values "SEC_FLOATING_FEATURE_BATTERY_SUPPORT_BSOH_SETTINGS" "TRUE"
fi

if [ "$TARGET_FLOATING_FEATURE_INCLUDE_CLOCK_LIVE_ICON" == "true" ]; then
	console_print "Disabling the live clock icon from the launcher"
	add_float_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_SUPPORT_CLOCK_LIVE_ICON" "TRUE"
else
	console_print "Enabling the live clock icon from the launcher"
	add_float_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_SUPPORT_CLOCK_LIVE_ICON" "FALSE"
fi

if [ "$TARGET_FLOATING_FEATURE_INCLUDE_EASY_MODE" == "true" ]; then
	console_print "Enabling Easy Mode..."
	add_float_xml_values "SEC_FLOATING_FEATURE_SETTINGS_SUPPORT_EASY_MODE" "TRUE"
else
	console_print "Disabling Easy Mode..."
	add_float_xml_values "SEC_FLOATING_FEATURE_SETTINGS_SUPPORT_EASY_MODE" "FALSE"
fi

if [ "$TARGET_FLOATING_FEATURE_ENABLE_BLUR_EFFECTS" == "true" ]; then
	console_print "Enabling live blur effects..."
	for blur_effects in SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_PARTIAL_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_CAPTURED_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_3D_SURFACE_TRANSITION_FLAG; do
		add_float_xml_values "$blur_effects" "TRUE"
	done
	if [ -f "${VENDOR_DIR}/etc/fstab.qcom" ]; then
		if echo "${BUILD_TARGET_SDK_VERSION}" | grep -qE "33|34"; then
			cp ./src/target/soc/snapdragon/${BUILD_TARGET_SDK_VERSION}/system/bin/surfaceflinger ${SYSTEM_DIR}/bin/surfaceflinger
			cp ./src/target/soc/snapdragon/${BUILD_TARGET_SDK_VERSION}/system/lib/libgui.so ${SYSTEM_DIR}/lib/libgui.so
			cp ./src/target/soc/snapdragon/${BUILD_TARGET_SDK_VERSION}/system/lib64/libgui.so ${SYSTEM_DIR}/lib64/libgui.so
		else
			console_print "SDK ${BUILD_TARGET_SDK_VERSION} is not supported."
		fi
	elif [[ -f ${VENDOR_DIR}/etc/fstab.exynos* || -f "${VENDOR_DIR}/bin/vaultkeeperd" ]]; then
		if echo "${BUILD_TARGET_SDK_VERSION}" | grep -qE "28|29|30|31|33|34"; then
			cp ./src/target/soc/exynos/${BUILD_TARGET_SDK_VERSION}/system/bin/surfaceflinger ${SYSTEM_DIR}/bin/surfaceflinger
			cp ./src/target/soc/exynos/${BUILD_TARGET_SDK_VERSION}/system/lib/libgui.so ${SYSTEM_DIR}/lib/libgui.so
			cp ./src/target/soc/exynos/${BUILD_TARGET_SDK_VERSION}/system/lib64/libgui.so ${SYSTEM_DIR}/lib64/libgui.so
		else
			console_print "SDK ${BUILD_TARGET_SDK_VERSION} is not supported."
		fi
	fi
fi

if [ "$TARGET_FLOATING_FEATURE_ENABLE_ENHANCED_PROCESSING" == "true" ]; then
	console_print "Enabling Enhanced Processing.."
	for enhanced_gaming in SEC_FLOATING_FEATURE_SYSTEM_SUPPORT_LOW_HEAT_MODE SEC_FLOATING_FEATURE_COMMON_SUPPORT_HIGH_PERFORMANCE_MODE SEC_FLOATING_FEATURE_SYSTEM_SUPPORT_ENHANCED_CPU_RESPONSIVENESS; do
		add_float_xml_values "$enhanced_gaming" "TRUE"
	done
fi

if [ "$TARGET_FLOATING_FEATURE_ENABLE_EXTRA_SCREEN_MODES" == "true" ]; then
	console_print "Adding support for extra screen modes...."
	for led_modes in SEC_FLOATING_FEATURE_LCD_SUPPORT_MDNIE_HW SEC_FLOATING_FEATURE_LCD_SUPPORT_WIDE_COLOR_GAMUT; do
		add_float_xml_values "${led_modes}" "FALSE"
	done
fi

if [ "$BUILD_TARGET_SUPPORTS_WIRELESS_POWER_SHARING" == "true" ]; then
	console_print "Enabling Wireless powershare...."
	for wireless_power_sharing_core in SEC_FLOATING_FEATURE_BATTERY_SUPPORT_HV SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_HV SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_NIGHT_MODE \
		SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_TX; do
		add_float_xml_values "${wireless_power_sharing_core}" "TRUE"
	done
fi

if [ "$TARGET_FLOATING_FEATURE_ENABLE_ULTRA_POWER_SAVING" == "true" ]; then
	console_print "Enabling Ultra Power Saver mode...."
	add_float_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_ULTRA_POWER_SAVING" "TRUE"
fi

if [ "$TARGET_FLOATING_FEATURE_DISABLE_SMART_SWITCH" == "true" ]; then
	console_print "Disabling Smart Switch feature in setup...."
	add_float_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_SMART_SWITCH" "FALSE"
	apply_diff_patches "$SYSTEM_DIR/etc/init/init.rilcommon.rc" "${DIFF_UNIFIED_PATCHES[20]}"
fi

if [ "$TARGET_FLOATING_FEATURE_SUPPORTS_DOLBY_IN_GAMES" == "true" ]; then
	console_print "Enabling dolby encoding in games...."
	for dolby_in_games in SEC_FLOATING_FEATURE_AUDIO_SUPPORT_DEFAULT_ON_DOLBY_IN_GAME SEC_FLOATING_FEATURE_AUDIO_SUPPORT_DOLBY_GAME_PROFILE; do
		add_float_xml_values "${dolby_in_games}" "TRUE"
	done
fi

# let's download goodlook modules from corsicanu's repo.
debugPrint "build.sh: Starting to check and try to download goodlook modules, logs can be seen below if any errors spawn upon the process"
[ "$TARGET_INCLUDE_SAMSUNG_THEMING_MODULES" == "true" ] && download_glmodules 2>> $thisConsoleTempLogFile

# installs audio resampler.
if [ "$TARGET_INCLUDE_HORIZON_AUDIO_RESAMPLER" == "true" ]; then
	console_print "Enabling HorizonUX audio resampler..."
	setprop --system "persist.horizonux.audio.resampler" "available"
else
	console_print "Disabling HorizonUX audio resampler..."
	setprop --system "persist.horizonux.audio.resampler" "unavailable"
fi

# L, see the dawn makeconfigs.prop file :\
if [ "$TARGET_INCLUDE_HORIZON_OEMCRYPTO_DISABLER" == "true" ]; then
	for part in $SYSTEM_DIR $VENDOR_DIR; do
		for libdir in "$part/lib" "$part/lib64"; do
			[ -f "$part/$libdir/liboemcrypto.so" ] && touch "$part/$libdir/liboemcrypto.so"
		done
	done
fi

# custom wallpaper-res resources_info.json generator.
if [ "$CUSTOM_WALLPAPER_RES_JSON_GENERATOR" == "true" ]; then
	debugPrint "build.sh: Java path: $(command -v java)"
	command -v java &>/dev/null || abort "\e[1;36m - Please install openjdk or any java toolchain to continue.\e[0;37m" "build.sh"
	special_index=00
	the_homescreen_wallpaper_has_been_set=false
	the_lockscreen_wallpaper_has_been_set=false
	printf "\e[1;36m - How many wallpapers do you need to add to the Wallpaper App?\e[0;37m "
	read wallpaper_count
	debugPrint "build.sh: User requested ${wallpaper_count} metadata to generate for wallpaper-res"
	[[ "$wallpaper_count" =~ ^[0-9]+$ ]] && abort "\e[0;31m - Invalid input. Please enter a valid number. Exiting...\e[0;37m" "build.sh"
	clear
	rm -rf ./src/horizon/packages/flosspaper_purezza/raw/resources_info.json
	echo -e "{\n\t\"version\": \"0.0.1\",\n\t\"phone\": [" > ./src/horizon/packages/flosspaper_purezza/raw/resources_info.json
	for ((i = 1; i <= wallpaper_count; i++)); do
		[ "${i}" -ge "10" ] && special_index=0
		printf "\e[0;36m - Adding configurations for wallpaper_${special_index}${i}.png.\e[0;37m\n"
		special_symbol=$(
			if [[ $i -eq $wallpaper_count ]]; then
				echo ","
			else
				echo ""
			fi
		)
		if [[ "$the_lockscreen_wallpaper_has_been_set" == true && "$the_homescreen_wallpaper_has_been_set" == true ]]; then
			ADD_THE_WALLPAPER_METADATA "${special_index}${i}" "additional" "$i"
		else
			clear
			echo -e "\e[1;36m - What do you want to do with wallpaper_${special_index}${i}.png?\e[0;37m"
			[[ "$the_lockscreen_wallpaper_has_been_set" == false ]] && echo "[1] - Set as default lockscreen wallpaper"
			[[ "$the_homescreen_wallpaper_has_been_set" == false ]] && echo "[2] - Set as default homescreen wallpaper"
			echo "[3] - Include in additional wallpapers"
			printf "\e[1;36mType your choice: \e[0;37m"
			read user_choice
			case "$user_choice" in
					1) 
					if [ "$the_lockscreen_wallpaper_has_been_set" == "false" ]; then
						the_lockscreen_wallpaper_has_been_set=true
						ADD_THE_WALLPAPER_METADATA "${special_index}${i}" "lock" "$i"
					else
						ADD_THE_WALLPAPER_METADATA "${special_index}${i}" "additional" "$i"
					fi
					;;
				2) 
					if [ "$the_homescreen_wallpaper_has_been_set" == "false" ]; then
						the_homescreen_wallpaper_has_been_set=true
						ADD_THE_WALLPAPER_METADATA "${special_index}${i}" "home" "$i"
					else
						ADD_THE_WALLPAPER_METADATA "${special_index}${i}" "additional" "$i"
					fi
					;;
				3) ADD_THE_WALLPAPER_METADATA "${special_index}${i}" "additional" "$i" ;;
				*) echo -e "\e[0;31m Invalid response! Exiting...\e[0;37m"; exit 1 ;;
			esac
		fi
	done
	echo -e "  ]\n}" >> ./src/horizon/packages/flosspaper_purezza/raw/resources_info.json
	rm -rf "${SYSTEM_DIR}/priv-app/wallpaper-res/*"
	build_and_sign "${DECODEDAPKTOOLPATHS[3]}" "${SYSTEM_DIR}/priv-app/wallpaper-res/"
	echo -e "\e[0;31m######################################################################"
	echo "#       __        ___    ____  _   _ ___ _   _  ____ _               #"
	echo "#       \ \      / / \  |  _ \| \ | |_ _| \ | |/ ___| |              #"
	echo "#        \ \ /\ / / _ \ | |_) |  \| || ||  \| | |  _| |              #"
	echo "#         \ V  V / ___ \|  _ <| |\  || || |\  | |_| |_|              #"
	echo "#          \_/\_/_/   \_\_| \_\_| \_|___|_| \_|\____(_)              #"
	echo "#                                                                    #"
	echo "######################################################################"
	echo -e "  This function is still in beta stages. Please check \" ./src/horizon/packages/flosspaper_purezza/raw/resources_info.json\" if you're concerned about issues.\e[0;37m"
fi

# removes useless samsung stuffs from the vendor partition.
if [ "$TARGET_REMOVE_USELESS_VENDOR_STUFFS" == "true" ]; then
	console_print "Nuking useless vendor stuffs..."
    if [[ "${BUILD_TARGET_SDK_VERSION}" -ge 29 && "${BUILD_TARGET_SDK_VERSION}" -le 34 ]]; then
        console_print "Removing services from the system config files..."
        if grep_prop "ro.product.vendor.model" "${HORIZON_VENDOR_PROPERTY_FILE}" | grep -E 'G97([035][FNUW0]|7[BNUW])|N97([05][FNUW0]|6[BNQ0]|1N)|T860|F90(0[FN]|7[BN])|M[23]15F'; then
            for cass in ${SYSTEM_DIR}/../init.rc $VENDOR_DIR/etc/init/cass.rc; do
                sed -i -e 's/^[^#].*cass.*$/# &/' -re '/\/(system|vendor)\/bin\/cass/,/^#?$/s/^[^#]*$/#&/' "${cass}"
            done
        fi
        if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == "false" ]; then
            for useless_service_def in $VENDOR_DIR/etc/vintf/manifest.xml $SYSTEM_DIR/etc/vintf/compatibility_matrix.device.xml $VENDOR_DIR/etc/vintf/manifest/vaultkeeper_manifest.xml; do
                remove_attributes "${useless_service_def}" "vendor.samsung.hardware.security.vaultkeeper"
                remove_attributes "${useless_service_def}" "vendor.samsung.hardware.security.proca"
                remove_attributes "${useless_service_def}" "vendor.samsung.hardware.security.wsm"
            done
            for vk in $SYSTEM_DIR/etc/init/vk*.rc $VENDOR_DIR/etc/init/vk*.rc $VENDOR_DIR/etc/init/vaultkeeper*.rc; do
                [ -f "${vk}" ] && sed -i -e 's/^[^#].*$/# &/' ${vk} && console_print "Disabled VaultKeeper service."
            done
            for proca in $VENDOR_DIR/etc/init/pa_daemon*.rc; do
                [ -f "${proca}" ] && sed -i -e 's/^[^#]/# &/' ${proca} && console_print "Disabled Proca (Process Authenticator) service."
            done
        fi
        rm -rf "${VENDOR_DIR}/overlay/AccentColorBlack" "${VENDOR_DIR}/overlay/AccentColorCinnamon" "${VENDOR_DIR}/overlay/AccentColorGreen" \
        "${VENDOR_DIR}/overlay/AccentColorOcean" "${VENDOR_DIR}/overlay/AccentColorOrchid" "${VENDOR_DIR}/overlay/AccentColorPurple" \
        "${VENDOR_DIR}/etc/init/boringssl_self_test.rc" "${VENDOR_DIR}/etc/init/dumpstate-default.rc" "${VENDOR_DIR}/etc/init/vendor_flash_recovery.rc" \
		"${VENDOR_DIR}/etc/vintf/manifest/dumpstate-default.xml" "${VENDOR_DIR}/overlay/AccentColorSpace" &>/dev/null
        if [ "${TARGET_DISABLE_FILE_BASED_ENCRYPTION}" == "true" ]; then
            for fstab__ in $VENDOR_DIR/etc/fstab.*; do
				[ "${fstab__}" == "fstab.ramplus" ] && continue
                sed -i -e 's/^\([^#].*\)fileencryption=[^,]*\(.*\)$/# &\n\1encryptable\2/g' ${fstab__}
            done
        fi
    fi
	console_print "Finished removing useless vendor file(s)"
fi

# nukes display refresh rate overrides on some video platforms.
if [ "$DISABLE_DISPLAY_REFRESH_RATE_OVERRIDE" == "true" ]; then
	console_print "Disabling Refresh rate override from surfaceflinger..."
	setprop --custom "$VENDOR_DIR/default.prop" "ro.surface_flinger.enable_frame_rate_override" "false"	
fi

# disables DRC shit
if [ "$DISABLE_DYNAMIC_RANGE_COMPRESSION" == "true" ]; then
	console_print "Disabling Dynamic Range Compression..."
	if [ -f "$VENDOR_DIR/etc/audio_policy_configuration.xml" ]; then
		sed -i 's/speaker_drc_enabled="true"/speaker_drc_enabled="false"/g' "$VENDOR_DIR/etc/audio_policy_configuration.xml"
		debugPrint "build.sh: Disabled speaker DRC in audio_policy_configuration.xml"
	else
		abort "Error: audio_policy_configuration.xml not found!" "build.sh"
	fi
fi

if [ "$DISABLE_SAMSUNG_ASKS_SIGNATURE_VERFICATION" == "true" ]; then
	console_print "Disabling Samsung's ASKS..."
	setprop --system ro.build.official.release false
fi

if [ "$FORCE_HARDWARE_ACCELERATION" == "true" ]; then
	warns "Enabling hardware acceleration..." "MISC"
	for i in "debug.hwui.renderer skiagl" "video.accelerate.hw 1" "debug.sf.hw 1" "debug.performance.tuning 0" "debug.egl.hw 1" "debug.composition.type gpu"; do
		setprop --system "$(echo "${i}" | awk '{printf $1}')" "$(echo "${i}" | awk '{printf $2}')"
	done
fi

[[ "${BUILD_TARGET_SDK_VERSION}" == "35" && -n "${bring_experimental_features}" ]] && build_and_sign "${DECODEDAPKTOOLPATHS[4]}" $HORIZON_FALLBACK_OVERLAY_PATH

if [ "$TARGET_BUILD_REMOVE_SYSTEM_LOGGING" == "true" ]; then
	console_print "Disabling unnecessary logging stuffs in android..."
	add_float_xml_values "SEC_FLOATING_FEATURE_SYSTEM_CONFIG_SYSINT_DQA_LOGLEVEL" '3'
	setprop --system "logcat.live" "disable"
	setprop --system "sys.dropdump.on" "Off"
	setprop --system "persist.debug.atrace.boottrace" '0'
	setprop --system "persist.log.ewlogd" '0'
	setprop --system "sys.lpdumpd" '0'
	setprop --system "persist.device_config.global_settings.sys_traced" '0'
	setprop --system "persist.traced.enable" '0'
	setprop --system "persist.sys.lmk.reportkills" "false"
	setprop --system "log.tag.ConnectivityManager" "S"
	setprop --system "log.tag.ConnectivityService" "S"
	setprop --system "log.tag.NetworkLogger" "S"
	setprop --system "log.tag.IptablesRestoreController" "S"
	setprop --system "log.tag.ClatdController" "S"
	debugPrint "build.sh: Patching atrace, dumpstate, and logd for ${BUILD_TARGET_SDK_VERSION} if possible...."
	if [[ "${BUILD_TARGET_SDK_VERSION}" -ge 28 && "${BUILD_TARGET_SDK_VERSION}" -le 31 ]]; then
		if [[ "${BUILD_TARGET_SDK_VERSION}" -eq 28 ]]; then
			apply_diff_patches "$SYSTEM_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[6]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[0]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[9]}"
		elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq 29 ]]; then
			apply_diff_patches "$SYSTEM_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[7]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[1]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[10]}"
		elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq 30 ]]; then
			apply_diff_patches "$SYSTEM_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[8]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[2]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[11]}"
		elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq 31 ]]; then
			apply_diff_patches "$SYSTEM_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[9]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[3]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[12]}"
		elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq 33 ]]; then
			apply_diff_patches "$SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[24]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[26]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[27]}"
		elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq 34 ]]; then
			apply_diff_patches "$SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[28]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[30]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[31]}"
		elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq 35 ]]; then
			apply_diff_patches "$SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[32]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[34]}"
			apply_diff_patches "$SYSTEM_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[35]}"
		fi
	fi
fi

if [ "$TARGET_BUILD_BRING_NEWGEN_ASSISTANT" == "true" ]; then
	console_print "Enabling New Gen Google Assistant..."
	setprop --system "ro.opa.eligible_device" "true"
fi

if [ "$TARGET_BUILD_ADD_MOBILE_DATA_TOGGLE_IN_POWER_MENU" == "true" ]; then
	console_print "Enabling Mobile data toggle in the power menu.."
	add_csc_xml_values "CscFeature_Framework_SupportDataModeSwitchGlobalAction" "TRUE"
fi

if [ "$TARGET_BUILD_FORCE_FIVE_BAR_NETICON" == "true" ]; then
	console_print "Enabling 5 network bars..."
	add_csc_xml_values "CscFeature_SystemUI_ConfigMaxRssiLevel" "5"
fi

if [ "$TARGET_BUILD_FORCE_SYSTEM_TO_PLAY_MUSIC_WHILE_RECORDING" == "true" ]; then
	console_print "Forcing the system to not close music apps while recording a video..."
	add_csc_xml_values "CscFeature_Camera_CamcorderDoNotPauseMusic" "TRUE"
fi

if [ "$TARGET_BUILD_ADD_NETWORK_SPEED_WIDGET" == "true" ]; then
	console_print "Enabling network speed bar in qs.."
	add_csc_xml_values "CscFeature_Setting_SupportRealTimeNetworkSpeed" "TRUE"
	[ "$BUILD_TARGET_SDK_VERSION" -ge "34" ] && add_csc_xml_values "CscFeature_Common_SupportZProjectFunctionInGlobal" "TRUE"
fi

if [ "$TARGET_BUILD_FORCE_SYSTEM_TO_NOT_CLOSE_CAMERA_WHILE_CALLING" == "true" ]; then
	console_print "Forcing system to not close the camera app while calling..."
	add_csc_xml_values "CscFeature_Camera_EnableCameraDuringCall" "TRUE"
fi

if [ "$TARGET_BUILD_ADD_CALL_RECORDING_IN_SAMSUNG_DIALER" == "true" ]; then
	console_print "Adding call recording feature in samsung dialler, please note that I'm not responsible for legal actions against you!"
	add_csc_xml_values "CscFeature_VoiceCall_ConfigRecording" "RecordingAllowedByMenu"
fi

if [ "$BUILD_TARGET_DISABLE_KNOX_PROPERTIES" == "true" ]; then
	console_print "Disabling Knox and applying rmm fix.."
	setprop --system "ro.securestorage.knox" "false"
	setprop --system "ro.security.vaultkeeper.native" "0"
	# Thanks salvo!
	if [ "$BUILD_TARGET_SDK_VERSION" == "34" ]; then
		for properties in security.mdf.result security.mdf ro.security.mdf.ver ro.security.mdf.release ro.security.wlan.ver ro.security.wlan.release ro.security.bt.ver \
			ro.security.bt.release ro.security.bio.ver ro.security.bio.release ro.security.mdf.ux ro.security.fips_bssl.ver ro.security.fips_skc.ver ro.security.fips_scrypto.ver; do
				setprop --force-delete "${properties}"
			done
		setprop --system "ro.security.fips.ux" "Disabled"
	fi
	add_csc_xml_values "CscFeature_Knox_SupportKnoxGuard" "FALSE"
fi

if [ "$TARGET_BUILD_DISABLE_WIFI_CALLING" == "true" ]; then
	console_print "Disabling Wifi calling.."
	add_csc_xml_values "CscFeature_Setting_SupportWifiCall" "FALSE"
	add_csc_xml_values "CscFeature_Setting_SupportWiFiCallingMenu" "FALSE"
else 
	console_print "Enabling Wifi calling.."
	add_csc_xml_values "CscFeature_Setting_SupportWifiCall" "TRUE"
	add_csc_xml_values "CscFeature_Setting_SupportWiFiCallingMenu" "TRUE"
fi

if [ "$TARGET_BUILD_SKIP_SETUP_JUNKS" == "true" ]; then
	console_print "Disabling junks on setup...."
	add_csc_xml_values "CscFeature_Setting_SkipWifiActvDuringSetupWizard" "FALSE"
	add_csc_xml_values "CscFeature_Setting_SkipStepsDuringSamsungSetupWizard" "TRUE"
fi

if [ "$BLOCK_NOTIFICATION_SOUNDS_DURING_PLAYBACK" == "true" ]; then
	console_print "Blocking notification sounds on playbacks.."
	add_csc_xml_values "CscFeature_Video_BlockNotiSoundDuringStreaming" "TRUE"
fi

if [ "$TARGET_BUILD_FORCE_SYSTEM_TO_PLAY_SMTH_WHILE_CALL" == "true" ]; then
	add_csc_xml_values "CscFeature_Video_SupportPlayDuringCall" "TRUE"
	console_print "Forced the system to play media while call..."
fi

if [ "$FORCE_ENABLE_POP_UP_PLAYER_ON_SVP" == "true" ]; then
	add_csc_xml_values "CscFeature_Video_EnablePopupPlayer" "TRUE"
	console_print "Forced samsung video player to work on pop-up window..."
fi

if [ "$TARGET_BUILD_FORCE_DISABLE_SETUP_WIZARD" == "true" ]; then
	console_print "Disabling Setup Wizard...."
	add_csc_xml_values "CscFeature_SetupWizard_DisablePrivacyPolicyAgreement" "TRUE"
fi

# init - ellen + bro board | Courtesy: @BrotherBoard
if [[ "${TARGET_INCLUDE_HORIZONUX_ELLEN}" == "true" || "${TARGET_INCLUDE_HORIZON_TOUCH_FIX}" == "true" ]]; then
	make loader &>>$thisConsoleTempLogFile
	mv ./local_build/binaries/bashScriptLoader $SYSTEM_DIR/bin/ || abort "Failed to move bashScriptLoader to $SYSTEM_DIR/bin/" "build.sh"
	if [ "${TARGET_INCLUDE_HORIZONUX_ELLEN}" == "true" ]; then
		console_print "HorizonUX Ellen is enabled, please note that this feature is experimental and may cause bootloops, if you face any bootloops, please dm me with the logs."
		setprop --system "persist.horizonux.ellen" "available"
		cp -af ./src/horizon/rom_tweaker_script/horizonux_ellen.sh $SYSTEM_DIR/bin/ || abort "Failed to move horizonux_ellen.sh to $SYSTEM_DIR/bin/" "build.sh"
	fi
	if [ "${TARGET_INCLUDE_HORIZON_TOUCH_FIX}" == "true" ]; then
		console_print "Adding brotherboard's GSI touch fix..."
		setprop --system "persist.horizonux.brotherboard.touch_fix" "available"
		cp -af ./src/horizon/rom_tweaker_script/brotherboard_touch_fix.sh $SYSTEM_DIR/bin/
	fi
	cp -af ./src/horizon/rom_tweaker_script/init.ellen.rc $SYSTEM_DIR/etc/init/
fi

if [ "$TARGET_BUILD_MAKE_DEODEXED_ROM" == "true" ]; then
	console_print "Deodexing the rom.."
	for deletableO_VDexFiles in $SYSTEM_DIR/app/*/*/*.odex $SYSTEM_DIR/app/*/*/*.vdex $SYSTEM_DIR/priv-app/*/*/*.odex $SYSTEM_DIR/priv-app/*/*/*.vdex \
		$PRODUCT_DIR/app/*/*/*.odex $PRODUCT_DIR/priv-app/*/*/*.vdex \
		$VENDOR_DIR/app/*/*/*.odex $VENDOR_DIR/priv-app/*/*/*.vdex \
		$SYSTEM_EXT_DIR/app/*/*/*.odex $SYSTEM_EXT_DIR/app/*/*/*.vdex $SYSTEM_EXT_DIR/priv-app/*/*/*.odex $SYSTEM_EXT_DIR/priv-app/*/*/*.vdex; do
		[ -f "${deletableO_VDexFiles}" ] && rm -rf ${deletableO_VDexFiles}
	done
	console_print "Deodexed the rom successfully!"
fi

if [[ "${TARGET_FLOATING_FEATURE_ENABLE_VOICE_MEMO_ON_NOTES}" == "true" && "${BUILD_TARGET_SDK_VERSION}" == "35" ]]; then
	console_print "Enabling Voice Memo on Samsung Notes..."
	add_float_xml_values "SEC_FLOATING_FEATURE_VOICERECORDER_CONFIG_DEF_MODE" "normal,interview,voicememo"
fi

# Use xmlstarlet to update the version inside vendor-ndk
if [ "${TARGET_BUILD_FIX_ANDROID_SYSTEM_DEVICE_WARNING}" == "true" ]; then
	console_print "Fixing android warning after boot. Thanks to @AlexFurina (github)"
	xmlstarlet ed -L -u "/manifest/vendor-ndk/version" -v "${BUILD_TARGET_VENDOR_SDK_VERSION}" "${SYSTEM_EXT_DIR}/etc/vintf/manifest.xml" || abort "Failed to fix android warning, please try again" "build.sh"
fi

if [ "${TARGET_BUILD_ADD_SCREENRESOLUTION_CHANGER}" == "true" ]; then
	[[ -z "${BUILD_TARGET_SCREEN_WIDTH}" || -z "${BUILD_TARGET_SCREEN_HEIGHT}" ]] && abort "The screen resolution is not specified on the property file."
	if [[ "${BUILD_TARGET_SCREEN_WIDTH}" == "1080" && "${BUILD_TARGET_SCREEN_HEIGHT}" == "2340" ]]; then
		console_print "Building screen resolution controller app, Thanks to @Yanndroid"
		. ${SCRIPTS[1]}
		rm -rf $SYSTEM_DIR/priv-app/screenResolution
		mkdir -p $SYSTEM_DIR/priv-app/screenResolution
		tar -C "./src/horizon/packages/" -xf "${DECODEDAPKTOOLPATHS[5]}.tar"
		build_and_sign "${DECODEDAPKTOOLPATHS[5]}" "$SYSTEM_DIR/priv-app/screenResolution"
	else
		console_print "Your display resolution is not valid, skipping the building process..."
	fi
fi

if [[ "${BUILD_TARGET_SDK_VERSION}" == "34|35" && "$BRINGUP_CN_SMARTMANAGER_DEVICE" == "true" ]]; then
	console_print "Replacing stock smartmanager and device care with the chinese version..."
	mkdir -p ./local_build/etc/permissions/ ./local_build/etc/app/SmartManager_v6_DeviceSecurity \
	./local_build/etc/app/SmartManager_v6_DeviceSecurity_CN ./local_build/etc/priv-app/SmartManager_v5 ./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity \
	./local_build/etc/priv-app/SmartManagerCN ./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity_CN ./local_build/etc/priv-app/SAppLock ./local_build/etc/priv-app/Firewall;
	{
		debugPrint "build.sh: Moving SmartManager and Device Care to a temporary directory.."
		# now move these for a quick revert if anything goes wrong.
		# xmls
		mv "$SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.lool.xml" "./local_build/etc/permissions/"
		mv "$SYSTEM_DIR/etc/permissions/signature-permissions-com.samsung.android.lool.xml" "./local_build/etc/permissions/"
		mv "$SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity_v6.xml" "./local_build/etc/permissions/"
		mv "$SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.sm_cn.xml" "./local_build/etc/permissions/"
		mv "$SYSTEM_DIR/etc/permissions/signature-permissions-com.samsung.android.sm_cn.xml" "./local_build/etc/permissions/"
		mv "$SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity.tcm_v6.xml" "./local_build/etc/permissions/"
		mv "$SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.applock.xml" "./local_build/etc/permissions/"
		mv "$SYSTEM_DIR/etc/permissions/privapp-permissions-com.sec.android.app.firewall.xml" "./local_build/etc/permissions/"
		# actual thing
		mv $SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity/* "./local_build/etc/app/SmartManager_v6_DeviceSecurity"
		mv $SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity_CN/* "./local_build/etc/app/SmartManager_v6_DeviceSecurity_CN"
		mv $SYSTEM_DIR/priv-app/SmartManager_v5/* "./local_build/etc/priv-app/SmartManager_v5"
		mv $SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity/* "./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity"
		mv $SYSTEM_DIR/priv-app/SmartManagerCN/* "./local_build/etc/priv-app/SmartManagerCN"
		mv $SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity_CN/* "./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity_CN"
		mv $SYSTEM_DIR/priv-app/SAppLock/* "./local_build/etc/priv-app/SAppLock"
		mv $SYSTEM_DIR/priv-app/Firewall/* "./local_build/etc/priv-app/Firewall"
		# change float values, as per updater-script from @saadelasfur/SmartManager/Installers/SmartManagerCN/updater-script
		# https://github.com/saadelasfur/SmartManager/blob/5a547850d8049ce0bfd6528d660b2735d6a18291/Installers/SmartManagerCN/updater-script#L87
		#                                                          -                                                                           #
		# https://github.com/saadelasfur/SmartManager/blob/5a547850d8049ce0bfd6528d660b2735d6a18291/Installers/SmartManagerCN/updater-script#L99
	} &>>$thisConsoleTempLogFile
	debugPrint "build.sh: Moved SmartManager and Device Care to a temporary directory.."
	add_float_xml_values "SEC_FLOATING_FEATURE_SMARTMANAGER_CONFIG_PACKAGE_NAME" "com.samsung.android.sm_cn"
	add_float_xml_values "SEC_FLOATING_FEATURE_SECURITY_CONFIG_DEVICEMONITOR_PACKAGE_NAME" "com.samsung.android.sm.devicesecurity.tcm"
	add_float_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_NAL_PRELOADAPP_REGULATION" "TRUE"
	for i in ${SMARTMANAGER_CN_DOWNLOADABLE_CONTENTS[@]}; do
		for j in ${SYSTEM_DIR}/${SMARTMANAGER_CN_DOWNLOADABLE_CONTENTS_SAVE_PATHS[@]}; do
			download_stuffs "${i}" "${j}" || {
				{
					debugPrint "build.sh:  like one of the loop is failed, restoring the backup..."
					# actual thing
					mv ./local_build/etc/priv-app/Firewall/* "$SYSTEM_DIR/priv-app/Firewall/"
					mv ./local_build/etc/priv-app/SAppLock/* "$SYSTEM_DIR/priv-app/SAppLock/"
					mv ./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity_CN/* "$SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity_CN/"
					mv ./local_build/etc/priv-app/SmartManagerCN/* "$SYSTEM_DIR/priv-app/SmartManagerCN/"
					mv ./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity/* "$SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity/"
					mv ./local_build/etc/priv-app/SmartManager_v5/* "$SYSTEM_DIR/priv-app/SmartManager_v5/"
					mv ./local_build/etc/app/SmartManager_v6_DeviceSecurity_CN/* "$SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity_CN/"
					mv ./local_build/etc/app/SmartManager_v6_DeviceSecurity/* "$SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity/"
					# xmls
					mv "./local_build/etc/permissions/privapp-permissions-com.sec.android.app.firewall.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.applock.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity.tcm_v6.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/signature-permissions-com.samsung.android.sm_cn.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.sm_cn.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity_v6.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/signature-permissions-com.samsung.android.lool.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.lool.xml" "$SYSTEM_DIR/etc/permissions/"
					debugPrint "build.sh: Seems like i did restore those files? didn't i?"
					warns "Failed to download stuffs from @saadelasfur github repo, moved everything to their places!" "FAILED_TO_DOWNLOAD_SMARTMANAGER"
					break
				} &>>$thisConsoleTempLogFile
			}
		done
	done
fi
if [ "$TINKER_MAX_REFRESH_RATE" == "true" ]; then
	if [[ -z "${DTBO_IMAGE_PATH}" || ! -f "${DTBO_IMAGE_PATH}" ]]; then
		warns "Can't patch dtbo because the dtbo image path is inaccessable." "DTBO_PATCH_FAILED"
	else
		. ${SCRIPTS[6]}
	fi
fi

# device customization script
[ -f "./src/target/${TARGET_BUILD_PRODUCT_NAME}/customizer.sh" ] && . ./src/target/${TARGET_BUILD_PRODUCT_NAME}/customizer.sh

# let's extend audio offload buffer size to 256kb and plug some of our things.
debugPrint "build.sh: End of the script, running misc stuffs.."
console_print "Running misc jobs..."
add_csc_xml_values "CscFeature_Setting_InfinitySoftwareUpdate" "TRUE"
add_csc_xml_values "CscFeature_Setting_DisableMenuSoftwareUpdate" "TRUE"
add_csc_xml_values "CscFeature_Settings_GOTA" "TRUE"
add_csc_xml_values "CscFeature_Settings_FOTA" "FALSE"
setprop --system ro.config.iccc_version "iccc_disabled"
setprop --system ro.config.dmverity "false"
for defaultHorizonAlertSounds in "ro.config.ringtone whatever.ogg" "ro.config.ringtone_2 whatever.ogg" "ro.config.notification_sound Bling.ogg" "ro.config.notification_sound_2 Luna.ogg"; do
	setprop --vendor "$(echo "${defaultHorizonAlertSounds}" | awk '{print $1}')" "$(echo "${defaultHorizonAlertSounds}" | awk '{print $2}')"
done
if [[ -n "${BUILD_TARGET_BOOT_ANIMATION_FPS}" && "${BUILD_TARGET_BOOT_ANIMATION_FPS}" -le "60" && -n "${BUILD_TARGET_SHUTDOWN_ANIMATION_FPS}" && "${BUILD_TARGET_SHUTDOWN_ANIMATION_FPS}" -le "60" ]]; then
	setprop --system "boot.fps" "${BUILD_TARGET_BOOT_ANIMATION_FPS}"
	setprop --system "shutdown.fps" "${BUILD_TARGET_SHUTDOWN_ANIMATION_FPS}"
fi
default_language_configuration ${NEW_DEFAULT_LANGUAGE_ON_PRODUCT} ${NEW_DEFAULT_LANGUAGE_COUNTRY_ON_PRODUCT}
add_float_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE" "${TARGET_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE}"
setprop --vendor "vendor.audio.offload.buffer.size.kb" "256"
rm -rf "$SYSTEM_DIR/hidden" "$SYSTEM_DIR/preload" "$SYSTEM_DIR/recovery-from-boot.p" "$SYSTEM_DIR/bin/install-recovery.sh"
cp -af ./src/misc/etc/ringtones_and_etc/media/audio/* "$SYSTEM_DIR/media/audio/"
add_float_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_SAMSUNG_MARKETING_INFO" "FALSE"
[ "$TARGET_INCLUDE_CUSTOM_BRAND_NAME" == "true" ] && add_float_xml_values "SEC_FLOATING_FEATURE_SETTINGS_CONFIG_BRAND_NAME" "${BUILD_TARGET_CUSTOM_BRAND_NAME}"
[ -f "$SYSTEM_DIR/$(fetch_rom_arch --libpath)/libhal.wsm.samsung.so" ] && touch "$SYSTEM_DIR/$(fetch_rom_arch --libpath)/libhal.wsm.samsung.so"
for i in "logcat.live disable" "sys.dropdump.on Off" "profiler.force_disable_err_rpt 1" "profiler.force_disable_ulog 1" \
		 "sys.lpdumpd 0" "persist.device_config.global_settings.sys_traced 0" "persist.traced.enable 0" "persist.sys.lmk.reportkills false" \
		 "log.tag.ConnectivityManager S" "log.tag.ConnectivityService S" "log.tag.NetworkLogger S" \
		 "log.tag.IptablesRestoreController S" "log.tag.ClatdController S"; do
		setprop --system "$(echo "${i}" | awk '{printf $1}')" "$(echo "${i}" | awk '{printf $2}')"
done
case "${BUILD_TARGET_SDK_VERSION}" in
    28)
        apply_diff_patches "$VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[4]}"
    ;;
    29)
        apply_diff_patches "$VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[5]}"
        apply_diff_patches "$SYSTEM_DIR/etc/init/bootchecker.rc" "${DIFF_UNIFIED_PATCHES[14]}"
    ;;
    30)
        apply_diff_patches "$VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[17]}"
        apply_diff_patches "$SYSTEM_DIR/etc/init/uncrypt.rc" "${DIFF_UNIFIED_PATCHES[20]}"
        apply_diff_patches "$SYSTEM_DIR/etc/init/vold.rc" "${DIFF_UNIFIED_PATCHES[22]}"
        apply_diff_patches "$SYSTEM_DIR/etc/init/bootchecker.rc" "${DIFF_UNIFIED_PATCHES[15]}"
    ;;
    31)
        apply_diff_patches "$VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[17]}"
        apply_diff_patches "$SYSTEM_DIR/etc/init/bootchecker.rc" "${DIFF_UNIFIED_PATCHES[16]}"
    ;;
	33)
        apply_diff_patches "$SYSTEM_DIR/etc/init/bootchecker.rc" "${DIFF_UNIFIED_PATCHES[25]}"
	;;
	34)
        apply_diff_patches "$SYSTEM_DIR/etc/init/bootchecker.rc" "${DIFF_UNIFIED_PATCHES[29]}"
	;;
	35)
        apply_diff_patches "$SYSTEM_DIR/etc/init/bootchecker.rc" "${DIFF_UNIFIED_PATCHES[33]}"
	;;
esac

[[ "${BUILD_TARGET_SDK_VERSION}" -ge "28" && "${BUILD_TARGET_SDK_VERSION}" -le "30" ]] && apply_diff_patches "$SYSTEM_DIR/etc/init/freecess.rc" "${DIFF_UNIFIED_PATCHES[22]}"
[[ "${BUILD_TARGET_SDK_VERSION}" -ge "28" && "${BUILD_TARGET_SDK_VERSION}" -le "34" ]] && apply_diff_patches "$SYSTEM_DIR/etc/init/init.rilcommon.rc" "${DIFF_UNIFIED_PATCHES[21]}"
[[ "${BUILD_TARGET_SDK_VERSION}" -ge "29" && "${BUILD_TARGET_SDK_VERSION}" -le "35" ]] && apply_diff_patches "$SYSTEM_DIR/etc/restart_radio_process.sh" "${DIFF_UNIFIED_PATCHES[19]}"
if ask "Do you want to add a stub app for missing activities?"; then
	mkdir -p "$SYSTEM_DIR/app/HorizonStub/"
	build_and_sign "${DECODEDAPKTOOLPATHS[6]}" "$SYSTEM_DIR/app/HorizonStub/"
fi
tinkerWithCSCFeaturesFile --encode
rm -rf "$TMPDIR"

if [ -f "./localFirmwareBuildPending" ]; then
	if [ -f "./local_build/etc/extract/super_extract/system" ]; then
		repackSuperFromDump "./local_build/etc/buildedContents/super.img" 
		console_print "Super image can be found at: \"./local_build/etc/buildedContents/super.img\""
		buildImage "./local_build/etc/imageSetup/optics" "/optics" 
	else
		buildImage "./local_build/etc/imageSetup/system" "/"
		buildImage "./local_build/etc/imageSetup/vendor" "/vendor"
		buildImage "./local_build/etc/imageSetup/product" "/product" 
	fi
fi