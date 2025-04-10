#!/usr/bin/env bash

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

# misc variables
BUILD_USERNAME="$(string_format --upper "$(id -un | cut -c 1-1)")$(id -un | cut -c 2-200)"
thisConsoleTempLogFile="./local_build/logs/hux_build.log"
rm -rf ./local_build/logs/*
TMPDIR="$(mktemp -d)"
TMPFILE="$(mktemp)"

# ok, fbans dropped!
if [ ! -f "cloud" ]; then
	# Check if required files exist
	for i in ./src/makeconfigs.prop ./src/misc/build_scripts/util_functions.sh ./src/monika.conf; do
		if [ ! -f "$i" ]; then
			echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] [:\e[0;36mABORT\e[0;37m:] -\e[0;31m Can't find $i file, please try again later...\e[0;37m"
			sleep 0.5
			exit 1
		else
			debugPrint "Executing ${i}.."
			source "$i"
		fi
	done
	# Check dependencies
	for dependenciesRequiredForTheBuild in java python3 zip; do
		if [ -z "$(command -v ${dependenciesRequiredForTheBuild})" ]; then
			abort "${dependenciesRequiredForTheBuild} is not found in the build environment, please check the guide again.."
		fi
	done
	# mako mako mako mako those who know💀
	for i in system/product/priv-app system/product/etc system/product/overlay \
			system/etc/permissions system/product/etc/permissions custom_recovery_with_fastbootd/ \
			system/etc/init/ tmp/hux/; do
		mkdir -p "./local_build/$i"
		debugPrint "Making ./local_build/${i} directory.."
	done
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
	console_print "The Current Username : $BUILD_USERNAME"
	console_print "CPU Architecture : $(lscpu | grep Architecture | awk '{print $2}')"
	console_print "CPU Manufacturer and model : $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)"
	console_print "L2 Cache Memory Size : $(lscpu | grep L2 | awk '{print $3}')KB/MB"
	console_print "Available RAM Memory : $(free -h | grep Mem | awk '{print $7}')B"
	console_print "The Computer is turned on since : $(uptime --pretty | awk '{print substr($0, 4)}')"
else
	source ./src/monica.conf
	source ./src/makeconfigs.prop
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
BUILD_TARGET_MODEL="$(grep_prop "ro.product.system.model" "${HORIZON_SYSTEM_PROPERTY_FILE}")"

# device specific customization:
if [ -d "./target/${TARGET_BUILD_PRODUCT_NAME}" ]; then
	debugPrint "build.sh: Device specific config and blobs are found, customizing the rom...."
	source "./src/target/${TARGET_BUILD_PRODUCT_NAME}/buildTargetProperties.conf"
else
	debugPrint "- Using genericTargetProperties.conf for configs..."
	source "./src/genericTargetProperties.conf"
fi

################ boom
if boolReturn $TARGET_BUILD_IS_FOR_DEBUGGING; then
	debugPrint "Debug flags are getting enabled"
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

# Stack build properties into a temporary directory
console_print "Storing the ROM's build properties into a temporary directory..."
stack_build_properties

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

boolReturn $TARGET_REMOVE_USELESS_SAMSUNG_APPLICATIONS_STUFFS && . ${SCRIPTS[5]}

if boolReturn $TARGET_INCLUDE_UNLIMITED_BACKUP; then
	console_print "Adding unlimited backup feature...."
	. ${SCRIPTS[0]}
fi

if boolReturn $BUILD_TARGET_REQUIRES_BLUETOOTH_LIBRARY_PATCHES; then
	console_print "Patching bluetooth...."
	[ -f "$SYSTEM_DIR/lib64/libbluetooth_jni.so" ] || abort "The \"libbluetooth_jni.so\" file from the system/lib64 wasn't found, copy and put them in a random directory and try again.."
	HEX_PATCH "$SYSTEM_DIR/lib64/libbluetooth_jni.so" "6804003528008052" "2b00001428008052"
fi

boolReturn $BUILD_TARGET_INCLUDE_FASTBOOTD_PATCH_BY_RATCODED && . ${SCRIPTS[2]}

if boolReturn $TARGET_INCLUDE_CUSTOM_SETUP_WELCOME_MESSAGES; then
	console_print "Adding custom setup wizard text...."
	custom_setup_finished_messsage
	build_and_sign ./src/horizon/overlay_packages/sec_setup_wizard_horizonux_overlay $HORIZON_FALLBACK_OVERLAY_PATH
fi

if boolReturn $TARGET_REMOVE_NONE_SECURITY_OPTION; then
	console_print "Removing none security option from lockscreen settings..."
	change_xml_values "config_hide_none_security_option" "true" "./src/horizon/overlay_packages/settings/oneui3/horizonux.autogenerated_rro/res/values/bools.xml"
fi

if boolReturn $TARGET_REMOVE_SWIPE_SECURITY_OPTION; then
	console_print "Removing swipe security option from lockscreen settings..."
	change_xml_values "config_hide_swipe_security_option" "true" "./src/horizon/overlay_packages/settings/oneui3/horizonux.autogenerated_rro/res/values/bools.xml"
fi

if boolReturn "$TARGET_REMOVE_NONE_SECURITY_OPTION" || boolReturn "$TARGET_REMOVE_SWIPE_SECURITY_OPTION"; then
	build_and_sign ./src/horizon/overlay_packages/settings/oneui3/horizonux.autogenerated_rro $HORIZON_FALLBACK_OVERLAY_PATH
fi

if boolReturn $TARGET_ADD_EXTRA_ANIMATION_SCALES; then
	console_print "Cooking extra animation scales.."
	build_and_sign ./src/horizon/overlay_packages/settings/oneui3/extra_animation_scales $HORIZON_FALLBACK_OVERLAY_PATH
fi

if boolReturn $TARGET_ADD_ROUNDED_CORNERS_TO_THE_PIP_WINDOWS; then
	console_print "Cooking rounded corners on pip window...."
	build_and_sign ./src/horizon/overlay_packages/systemui/oneui3/rounded_corners_on_pip $HORIZON_FALLBACK_OVERLAY_PATH
fi

if boolReturn $TARGET_FLOATING_FEATURE_INCLUDE_GAMELAUNCHER_IN_THE_HOMESCREEN; then
	console_print "Enabling Game Launcher..."
	change_xml_values "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_DEFAULT_GAMELAUNCHER_ENABLE" "TRUE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
else
	console_print "Disabling Game Launcher..."
	change_xml_values "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_DEFAULT_GAMELAUNCHER_ENABLE" "FALSE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
fi

if boolReturn $BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES; then
	console_print "Switching the default refresh rate to ${BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE}Hz..."
	change_xml_values "SEC_FLOATING_FEATURE_LCD_CONFIG_HFR_DEFAULT_REFRESH_RATE" "${BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE}" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
else
	console_print "Switching the default refresh rate to 60Hz (due to the BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES variable being set to false)."
	change_xml_values "SEC_FLOATING_FEATURE_LCD_CONFIG_HFR_DEFAULT_REFRESH_RATE" "60" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
fi

if boolReturn $TARGET_FLOATING_FEATURE_INCLUDE_SPOTIFY_AS_ALARM; then
	console_print "Adding spotify as an option in the clock app.."
	add_float_xml_values "SEC_FLOATING_FEATURE_CLOCK_CONFIG_ALARM_SOUND" "spotify"
fi

if boolReturn $TARGET_FLOATING_FEATURE_BATTERY_SUPPORT_BSOH_SETTINGS; then
	console_print "This feature needs some patches to work on some roms, if you dont"
	console_print "see anything in the battery settings, please remove this on the next build."
	add_float_xml_values "SEC_FLOATING_FEATURE_BATTERY_SUPPORT_BSOH_SETTINGS" "TRUE"
fi

if boolReturn $TARGET_FLOATING_FEATURE_INCLUDE_CLOCK_LIVE_ICON; then
	console_print "Disabling the live clock icon from the launcher, great move!"
	change_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_SUPPORT_CLOCK_LIVE_ICON" "TRUE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
else
	console_print "Enabling the live clock icon from the launcher, bad move!"
	change_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_SUPPORT_CLOCK_LIVE_ICON" "FALSE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
fi

if boolReturn $TARGET_FLOATING_FEATURE_INCLUDE_EASY_MODE; then
	console_print "Enabling Easy Mode..."
	change_xml_values "SEC_FLOATING_FEATURE_SETTINGS_SUPPORT_EASY_MODE" "TRUE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
else
	console_print "Disabling Easy Mode..."
	change_xml_values "SEC_FLOATING_FEATURE_SETTINGS_SUPPORT_EASY_MODE" "FALSE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
fi

if boolReturn $TARGET_FLOATING_FEATURE_DISABLE_BLUR_EFFECTS; then
    console_print "Disabling blur effects..."
    for blur_effects in SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_PARTIAL_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_CAPTURED_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_3D_SURFACE_TRANSITION_FLAG; do
        change_xml_values "$blur_effects" "FALSE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
    done
else
	if [ "$BUILD_TARGET_SDK_VERSION" == "32|33|34|35" ]; then
		warns "Actual blur from flagship device is not available for now, so stay tuned!" "CRYABOUTTHISPLEASE"
	elif [ "$BUILD_TARGET_SDK_VERSION" == "28|28|30|31|32|33|34|35" ]; then
		console_print "Enabling blur effects..."
		for blur_effects in SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_PARTIAL_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_CAPTURED_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_3D_SURFACE_TRANSITION_FLAG; do
			change_xml_values "$blur_effects" "TRUE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
		done
		for props in "ro.surface_flinger.supports_background_blur 1" "persist.sys.sf.disable_blurs 0" "ro.sf.blurs_are_expensive 1"; do
			setprop --system "$(echo "$props" | awk '{print $1}')" "$(echo "$props" | awk '{print $2}')"
		done
		for files in ./src/device_dumps/beyond0ltexx/${BUILD_TARGET_SDK_VERSION}/system/{bin/*,lib/*,lib64/*}; do
			if existance "$files"; then
				case "$files" in
					*lib64/*)
						cp "$files" "$SYSTEM_DIR/lib64/" || abort "Failed to copy $files to $SYSTEM_DIR/lib64"
					;;
					*lib/*)
						cp "$files" "$SYSTEM_DIR/lib/" || abort "Failed to copy $files to $SYSTEM_DIR/lib"
					;;
					*bin/*)
						cp "$files" "$SYSTEM_DIR/bin/" || abort "Failed to copy $files to $SYSTEM_DIR/bin"
					;;
				esac
			fi
		done
	fi
fi

if boolReturn $TARGET_FLOATING_FEATURE_ENABLE_ENHANCED_PROCESSING; then
	console_print "Enabling Enhanced Processing.."
	for enhanced_gaming in SEC_FLOATING_FEATURE_SYSTEM_SUPPORT_LOW_HEAT_MODE SEC_FLOATING_FEATURE_COMMON_SUPPORT_HIGH_PERFORMANCE_MODE SEC_FLOATING_FEATURE_SYSTEM_SUPPORT_ENHANCED_CPU_RESPONSIVENESS; do
		change_xml_values "$enhanced_gaming" "TRUE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
	done
fi

if boolReturn $TARGET_FLOATING_FEATURE_ENABLE_EXTRA_SCREEN_MODES; then
	console_print "Adding support for extra screen modes...."
	for led_modes in SEC_FLOATING_FEATURE_LCD_SUPPORT_MDNIE_HW SEC_FLOATING_FEATURE_LCD_SUPPORT_WIDE_COLOR_GAMUT; do
		change_xml_values "${led_modes}" "FALSE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
	done
fi

if boolReturn $BUILD_TARGET_SUPPORTS_WIRELESS_POWER_SHARING; then
	console_print "Enabling Wireless powershare...."
	for wireless_power_sharing_core in SEC_FLOATING_FEATURE_BATTERY_SUPPORT_HV SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_HV SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_NIGHT_MODE \
		SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_TX; do
		add_float_xml_values "${wireless_power_sharing_core}" "TRUE"
	done
fi

if boolReturn $TARGET_FLOATING_FEATURE_ENABLE_ULTRA_POWER_SAVING; then
	console_print "Enabling Ultra Power Saver mode...."
	add_float_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_ULTRA_POWER_SAVING" "TRUE"
fi

if boolReturn $TARGET_FLOATING_FEATURE_DISABLE_SMART_SWITCH; then
	console_print "Disabling Smart Switch feature in setup...."
	change_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_SMART_SWITCH" "FALSE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
	apply_diff_patches "$SYSTEM_DIR/etc/init/init.rilcommon.rc" "${DIFF_UNIFIED_PATCHES[20]}"
fi

if boolReturn $TARGET_FLOATING_FEATURE_SUPPORTS_DOLBY_IN_GAMES; then
	console_print "Enabling dolby encoding in games...."
	for dolby_in_games in SEC_FLOATING_FEATURE_AUDIO_SUPPORT_DEFAULT_ON_DOLBY_IN_GAME SEC_FLOATING_FEATURE_AUDIO_SUPPORT_DOLBY_GAME_PROFILE; do
		add_float_xml_values "${dolby_in_games}" "TRUE"
	done
fi

# let's download goodlook modules from corsicanu's repo.
debugPrint "Starting to check and try to download goodlook modules, logs can be seen below if any errors spawn upon the process"
boolReturn $TARGET_INCLUDE_SAMSUNG_THEMING_MODULES && check_internet_connection "GOODLOCK_MODULES" && download_glmodules 2>> $thisConsoleTempLogFile

# installs audio resampler.
if boolReturn $TARGET_INCLUDE_HORIZON_AUDIO_RESAMPLER; then
	console_print "Enabling HorizonUX audio resampler..."
	setprop --system "persist.horizonux.audio.resampler" "available"
else
	console_print "Disabling HorizonUX audio resampler..."
	setprop --system "persist.horizonux.audio.resampler" "unavailable"
fi

# L, see the dawn makeconfigs.prop file :\
if boolReturn $TARGET_INCLUDE_HORIZON_OEMCRYPTO_DISABLER; then
	for part in $SYSTEM_DIR $VENDOR_DIR; do
		for libdir in "$part/lib" "$part/lib64"; do
			[ -f "$part/$libdir/liboemcrypto.so" ] && touch "$part/$libdir/liboemcrypto.so"
		done
	done
fi

# custom wallpaper-res resources_info.json generator.
boolReturn $CUSTOM_WALLPAPER_RES_JSON_GENERATOR && . ${SCRIPTS[3]}

# removes useless samsung stuffs from the vendor partition.
if boolReturn $TARGET_REMOVE_USELESS_VENDOR_STUFFS; then
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
                remove_attributes "${useless_service_def}" "${useless_service_def}__" "vendor.samsung.hardware.security.vaultkeeper"
                remove_attributes "${useless_service_def}" "${useless_service_def}__" "vendor.samsung.hardware.security.proca"
                remove_attributes "${useless_service_def}" "${useless_service_def}__" "vendor.samsung.hardware.security.wsm"
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
        "${VENDOR_DIR}/etc/init/boringssl_self_test.rc" "${VENDOR_DIR}/overlay/AccentColorSpace" &> "$thisConsoleTempLogFile"
        if [ "${TARGET_DISABLE_FILE_BASED_ENCRYPTION}" == "true" ]; then
            for fstab__ in $VENDOR_DIR/etc/fstab.*; do
                sed -i -e 's/^\([^#].*\)fileencryption=[^,]*\(.*\)$/# &\n\1encryptable\2/g' ${fstab__}
            done
        fi
    fi
	console_print "Finished removing useless vendor file(s)"
	console_print "if you have bootloops, dm my bot with logs"
fi

# nukes display refresh rate overrides on some video platforms.
if boolReturn $DISABLE_DISPLAY_REFRESH_RATE_OVERRIDE; then
	console_print "Disabling Refresh rate override from surfaceflinger..."
	sed -i "/max_frame_buffer_acquired_buffers/a ro.surface_flinger.enable_frame_rate_override=false" "$VENDOR_DIR/default.prop"	
fi

# disable's DRC shit
if boolReturn $DISABLE_DYNAMIC_RANGE_COMPRESSION; then
	console_print "Disabling Dynamic Range Compression..."
	if [ -f "$VENDOR_DIR/etc/audio_policy_configuration.xml" ]; then
		sed -i 's/speaker_drc_enabled="true"/speaker_drc_enabled="false"/g' "$VENDOR_DIR/etc/audio_policy_configuration.xml"
		debugPrint "Disabled speaker DRC in audio_policy_configuration.xml"
	else
		abort "Error: audio_policy_configuration.xml not found!"
	fi
fi

if boolReturn $DISABLE_SAMSUNG_ASKS_SIGNATURE_VERFICATION; then
	console_print "Disabling Samsung's ASKS..."
	setprop --system ro.build.official.release false
fi

if boolReturn $FORCE_HARDWARE_ACCELERATION; then
	warns "Enabling hardware acceleration..." "MISC"
	for i in "debug.hwui.renderer skiagl" "video.accelerate.hw 1" "debug.sf.hw 1" "debug.performance.tuning 0" "debug.egl.hw 1" "debug.composition.type gpu"; do
		setprop --system "$(echo "${i}" | awk '{printf $1}')" "$(echo "${i}" | awk '{printf $2}')"
	done
fi

if boolReturn "$TARGET_BUILD_REMOVE_SYSTEM_LOGGING"; then
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
	debugPrint "Patching atrace, dumpstate, and logd for ${BUILD_TARGET_SDK_VERSION} if possible...."
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
		fi
	fi
fi

if boolReturn "$TARGET_BUILD_BRING_NEWGEN_ASSISTANT"; then
	console_print "Enabling New Gen Google Assistant..."
	setprop --system "ro.opa.eligible_device" "true"
fi

if boolReturn "$TARGET_BUILD_ADD_MOBILE_DATA_TOGGLE_IN_POWER_MENU"; then
	console_print "Enabling Mobile data toggle in the power menu.."
	add_csc_xml_values "CscFeature_Framework_SupportDataModeSwitchGlobalAction" "TRUE"
fi

if boolReturn "$TARGET_BUILD_FORCE_FIVE_BAR_NETICON"; then
	console_print "Enabling 5 network bars..."
	add_csc_xml_values "CscFeature_SystemUI_ConfigMaxRssiLevel" "5"
fi

if boolReturn "$TARGET_BUILD_FORCE_SYSTEM_TO_PLAY_MUSIC_WHILE_RECORDING"; then
	console_print "Forcing the system to not close music apps while recording a video..."
	add_csc_xml_values "CscFeature_Camera_CamcorderDoNotPauseMusic" "TRUE"
fi

if boolReturn "$TARGET_BUILD_ADD_NETWORK_SPEED_WIDGET"; then
	console_print "Enabling network speed bar in qs.."
	add_csc_xml_values "CscFeature_Setting_SupportRealTimeNetworkSpeed" "TRUE"
	[ "$BUILD_TARGET_SDK_VERSION" -ge "34" ] && add_csc_xml_values "CscFeature_Common_SupportZProjectFunctionInGlobal" "TRUE"
fi

if boolReturn "$TARGET_BUILD_FORCE_SYSTEM_TO_NOT_CLOSE_CAMERA_WHILE_CALLING"; then
	console_print "Forcing system to not close the camera app while calling..."
	add_csc_xml_values "CscFeature_Camera_EnableCameraDuringCall" "TRUE"
fi

if boolReturn "$TARGET_BUILD_ADD_CALL_RECORDING_IN_SAMSUNG_DIALER"; then
	console_print "Adding call recording feature in samsung dialler, please note that I'm not responsible for legal actions against you!"
	add_csc_xml_values "CscFeature_VoiceCall_ConfigRecording" "RecordingAllowedByMenu"
fi

if boolReturn "$BUILD_TARGET_DISABLE_KNOX_PROPERTIES"; then
	console_print "Disabling Knox and applying rmm fix.."
	setprop --system "ro.securestorage.knox" "false"
	setprop --system "ro.security.vaultkeeper.native" "0"
	# Thanks salvo!
	if [ "$BUILD_TARGET_SDK_VERSION" == "34" ]; then
		setprop --system security.mdf.result " "
		setprop --system security.mdf " "
		setprop --system ro.security.mdf.ver " "
		setprop --system ro.security.mdf.release " "
		setprop --system ro.security.wlan.ver " "
		setprop --system ro.security.wlan.release " "
		setprop --system ro.security.bt.ver " "
		setprop --system ro.security.bt.release " "
		setprop --system ro.security.bio.ver " "
		setprop --system ro.security.bio.release " "
		setprop --system ro.security.mdf.ux " "
		setprop --system "ro.security.fips.ux" "Disabled"
		setprop --system ro.security.fips_bssl.ver " "
		setprop --vendor ro.security.fips_skc.ver " "
		setprop --vendor ro.security.fips_scrypto.ver " "
	fi
	add_csc_xml_values "CscFeature_Knox_SupportKnoxGuard" "FALSE"
fi

if boolReturn "$TARGET_BUILD_DISABLE_WIFI_CALLING"; then
	console_print "Disabling Wifi calling.."
	add_csc_xml_values "CscFeature_Setting_SupportWifiCall" "FALSE"
	add_csc_xml_values "CscFeature_Setting_SupportWiFiCallingMenu" "FALSE"
else 
	console_print "Enabling Wifi calling.."
	add_csc_xml_values "CscFeature_Setting_SupportWifiCall" "TRUE"
	add_csc_xml_values "CscFeature_Setting_SupportWiFiCallingMenu" "TRUE"
fi

if boolReturn "$TARGET_BUILD_SKIP_SETUP_JUNKS"; then
	console_print "Disabling junks on setup...."
	add_csc_xml_values "CscFeature_Setting_SkipWifiActvDuringSetupWizard" "FALSE"
	add_csc_xml_values "CscFeature_Setting_SkipStepsDuringSamsungSetupWizard" "TRUE"
fi

if boolReturn "$BLOCK_NOTIFICATION_SOUNDS_DURING_PLAYBACK"; then
	console_print "Blocking notification sounds on playbacks.."
	add_csc_xml_values "CscFeature_Video_BlockNotiSoundDuringStreaming" "TRUE"
fi

if boolReturn "$TARGET_BUILD_FORCE_SYSTEM_TO_PLAY_SMTH_WHILE_CALL"; then
	add_csc_xml_values "CscFeature_Video_SupportPlayDuringCall" "TRUE"
	console_print "Forced the system to play media while call..."
fi

if boolReturn "$FORCE_ENABLE_POP_UP_PLAYER_ON_SVP"; then
	add_csc_xml_values "CscFeature_Video_EnablePopupPlayer" "TRUE"
	console_print "Forced samsung video player to work on pop-up window..."
fi

if boolReturn "$TARGET_BUILD_FORCE_DISABLE_SETUP_WIZARD"; then
	console_print "Disabling Setup Wizard...."
	add_csc_xml_values "CscFeature_SetupWizard_DisablePrivacyPolicyAgreement" "TRUE"
fi

# init - ellen + bro board | Courtesy: @BrotherBoard
if [[ "${TARGET_INCLUDE_HORIZONUX_ELLEN}" == "true" || "${TARGET_INCLUDE_HORIZON_TOUCH_FIX}" == "true" ]]; then
	console_print "Starting to compile bashScriptLoader.."
	make loader &>>$thisConsoleTempLogFile
	console_print "bashScriptLoader compiled successfully!"
	mv ./local_build/binaries/bashScriptLoader $SYSTEM_DIR/bin/ || abort "Failed to move bashScriptLoader to $SYSTEM_DIR/bin/"
	if [ "${TARGET_INCLUDE_HORIZONUX_ELLEN}" == "true" ]; then
		console_print "HorizonUX Ellen is enabled, please note that this feature is experimental and may cause bootloops, if you face any bootloops, please dm me with the logs."
		setprop --system "persist.horizonux.ellen" "available"
		cp -af ./src/horizon/rom_tweaker_script/horizonux_ellen.sh $SYSTEM_DIR/bin/ || abort "Failed to move horizonux_ellen.sh to $SYSTEM_DIR/bin/"
	fi
	if [ "${TARGET_INCLUDE_HORIZON_TOUCH_FIX}" == "true" ]; then
		console_print "Adding brotherboard's GSI touch fix..."
		setprop --system "persist.horizonux.brotherboard.touch_fix" "available"
		cp -af ./src/horizon/rom_tweaker_script/brotherboard_touch_fix.sh $SYSTEM_DIR/bin/
	fi
	cp -af ./src/horizon/rom_tweaker_script/init.ellen.rc $SYSTEM_DIR/etc/init/
fi

if [ "${BUILD_TARGET_SDK_VERSION}" == "34|35" ] && boolReturn "$BRINGUP_CN_SMARTMANAGER_DEVICE"; then
	console_print "Replacing stock smartmanager and device care with the chinese version..."
	mkdir -p ./local_build/etc/permissions/ ./local_build/etc/app/SmartManager_v6_DeviceSecurity \
	./local_build/etc/app/SmartManager_v6_DeviceSecurity_CN ./local_build/etc/priv-app/SmartManager_v5 ./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity \
	./local_build/etc/priv-app/SmartManagerCN ./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity_CN ./local_build/etc/priv-app/SAppLock ./local_build/etc/priv-app/Firewall;
	{
		debugPrint "Moving SmartManager and Device Care to a temporary directory.."
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
		mv "$SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity/*" "./local_build/etc/app/SmartManager_v6_DeviceSecurity"
		mv "$SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity_CN/*" "./local_build/etc/app/SmartManager_v6_DeviceSecurity_CN"
		mv "$SYSTEM_DIR/priv-app/SmartManager_v5/*" "./local_build/etc/priv-app/SmartManager_v5"
		mv "$SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity/*" "./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity"
		mv "$SYSTEM_DIR/priv-app/SmartManagerCN/*" "./local_build/etc/priv-app/SmartManagerCN"
		mv "$SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity_CN/*" "./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity_CN"
		mv "$SYSTEM_DIR/priv-app/SAppLock/*" "./local_build/etc/priv-app/SAppLock"
		mv "$SYSTEM_DIR/priv-app/Firewall/*" "./local_build/etc/priv-app/Firewall"
		# change float values, as per updater-script from @saadelasfur/SmartManager/Installers/SmartManagerCN/updater-script
		# https://github.com/saadelasfur/SmartManager/blob/5a547850d8049ce0bfd6528d660b2735d6a18291/Installers/SmartManagerCN/updater-script#L87
		#                                                          -                                                                           #
		# https://github.com/saadelasfur/SmartManager/blob/5a547850d8049ce0bfd6528d660b2735d6a18291/Installers/SmartManagerCN/updater-script#L99
	} &>>$thisConsoleTempLogFile
	debugPrint "Moved SmartManager and Device Care to a temporary directory.."
	change_xml_values "SEC_FLOATING_FEATURE_SMARTMANAGER_CONFIG_PACKAGE_NAME" "com.samsung.android.sm_cn" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
	change_xml_values "SEC_FLOATING_FEATURE_SECURITY_CONFIG_DEVICEMONITOR_PACKAGE_NAME" "com.samsung.android.sm.devicesecurity.tcm" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
	add_float_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_NAL_PRELOADAPP_REGULATION" "TRUE"
	for i in ${SMARTMANAGER_CN_DOWNLOADABLE_CONTENTS[@]}; do
		for j in ${SMARTMANAGER_CN_DOWNLOADABLE_CONTENTS_SAVE_PATHS[@]}; do
			download_stuffs "${i}" "${j}" || {
				{
					debugPrint "Looks like one of the loop is failed, restoring the backup..."
					# actual thing
					mv "./local_build/etc/priv-app/Firewall/*" "$SYSTEM_DIR/priv-app/Firewall/"
					mv "./local_build/etc/priv-app/SAppLock/*" "$SYSTEM_DIR/priv-app/SAppLock/"
					mv "./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity_CN/*" "$SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity_CN/"
					mv "./local_build/etc/priv-app/SmartManagerCN/*" "$SYSTEM_DIR/priv-app/SmartManagerCN/"
					mv "./local_build/etc/priv-app/SmartManager_v6_DeviceSecurity/*" "$SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity/"
					mv "./local_build/etc/priv-app/SmartManager_v5/*" "$SYSTEM_DIR/priv-app/SmartManager_v5/"
					mv "./local_build/etc/app/SmartManager_v6_DeviceSecurity_CN/*" "$SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity_CN/"
					mv "./local_build/etc/app/SmartManager_v6_DeviceSecurity/*" "$SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity/"
					# xmls
					mv "./local_build/etc/permissions/privapp-permissions-com.sec.android.app.firewall.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.applock.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity.tcm_v6.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/signature-permissions-com.samsung.android.sm_cn.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.sm_cn.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity_v6.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/signature-permissions-com.samsung.android.lool.xml" "$SYSTEM_DIR/etc/permissions/"
					mv "./local_build/etc/permissions/privapp-permissions-com.samsung.android.lool.xml" "$SYSTEM_DIR/etc/permissions/"
					debugPrint "Seems like i did restore those files? didn't i?"
					warns "Failed to download stuffs from @saadelasfur github repo, moved everything to their places!" "FAILED_TO_DOWNLOAD_SMARTMANAGER"
					break
				} &>>$thisConsoleTempLogFile
			}
		done
	done
fi
if boolReturn "$TINKER_MAX_REFRESH_RATE"; then
	if [[ -z "${DTBO_IMAGE_PATH}" || ! -f "${DTBO_IMAGE_PATH}" ]]; then
		warns "Can't patch dtbo because the dtbo image path is inaccessable." "DTBO_PATCH_FAILED"
	else
		. ${SCRIPTS[6]}
	fi
fi

# device customization script
[ -f "./src/target/${TARGET_BUILD_PRODUCT_NAME}/customizer.sh" ] && . ./src/target/${TARGET_BUILD_PRODUCT_NAME}/customizer.sh

# let's extend audio offload buffer size to 256kb and plug some of our things.
debugPrint "End of the script, running misc stuffs.."
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
change_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE" "${TARGET_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE}" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
setprop --vendor "vendor.audio.offload.buffer.size.kb" "256"
rm -rf "$SYSTEM_DIR/hidden" "$SYSTEM_DIR/preload" "$SYSTEM_DIR/recovery-from-boot.p" "$SYSTEM_DIR/bin/install-recovery.sh"
cp -af ./misc/etc/ringtones_and_etc/media/audio/* "$SYSTEM_DIR/media/audio/"
change_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_SAMSUNG_MARKETING_INFO" "FALSE" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
boolReturn "$TARGET_INCLUDE_CUSTOM_BRAND_NAME" && change_xml_values "SEC_FLOATING_FEATURE_SETTINGS_CONFIG_BRAND_NAME" "${BUILD_TARGET_CUSTOM_BRAND_NAME}" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
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
esac
if [[ "${BUILD_TARGET_SDK_VERSION}" -ge "28" && "${BUILD_TARGET_SDK_VERSION}" -le "30" ]]; then
    apply_diff_patches "$SYSTEM_DIR/etc/init/freecess.rc" "${DIFF_UNIFIED_PATCHES[22]}"
fi
if [[ "${BUILD_TARGET_SDK_VERSION}" -ge "28" && "${BUILD_TARGET_SDK_VERSION}" -le "31" ]]; then
    apply_diff_patches "$SYSTEM_DIR/etc/init/init.rilcommon.rc" "${DIFF_UNIFIED_PATCHES[21]}"
fi
if [[ "${BUILD_TARGET_SDK_VERSION}" -ge "29" && "${BUILD_TARGET_SDK_VERSION}" -le "33" ]]; then
    apply_diff_patches "$SYSTEM_DIR/etc/restart_radio_process.sh" "${DIFF_UNIFIED_PATCHES[19]}"
fi
if ask "Do you want to add a stub app for missing activities?"; then
	mkdir -p "$SYSTEM_DIR/app/HorizonStub/"
	build_and_sign "./src/horizon/packages/HorizonStub" "$SYSTEM_DIR/app/HorizonStub/"
fi
tinkerWithCSCFeaturesFile --encode
rm -rf "$TMPDIR" "${BUILD_TARGET_FLOATING_FEATURE_PATH}.bak"