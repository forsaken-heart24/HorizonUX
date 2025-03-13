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

# nuke the old log file.
rm -rf ..local_build/logs/*
TMPDIR=$(mktemp --tmpdir=.)

# mako mako mako mako Those who know💀
for i in system/product/priv-app system/product/etc system/product/overlay system/etc/permissions system/product/etc/permissions custom_recovery_with_fastbootd/ system/etc/init/; do
    mkdir -p ../local_build/$i
done

# check if mentioned files do exist or not.
for i in "./misc/build_scripts/util_functions.sh" "./monika.conf" "./makeconfigs.prop" "./misc/build_scripts/target_configs.sh"; do
	if [ ! -f "$i" ]; then
		echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] [:\e[0;36mABORT\e[0;37m:] -\e[0;31m Can't find $i file, please try again later...\e[0;37m"
		sleep 0.5
		exit 1
	else
		. "$i"
	fi
done

# ok, fbans dropped!
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
console_print "L2 Cache Memory Size : $(lscpu | grep L2 | awk '{print $3}')"
console_print "Available RAM Memory : $(free -h | grep Mem | awk '{print $7}')B"
console_print "The Computer is turned on since : $(uptime --pretty | awk '{print substr($0, 4)}')"

################ boom
if boolReturn $TARGET_BUILD_IS_FOR_DEBUGGING; then
	echo -e "\n############ WARNING, EXPERIMENTAL FLAGS AHEAD!\nlogcat.live=enable\nsys.lpdumpd=1\npersist.debug.atrace.boottrace=1\npersist.device_config.global_settings.sys_traced=1\npersist.traced.enable=1\nlog.tag.ConnectivityManager=V\nlog.tag.ConnectivityService=V\nlog.tag.NetworkLogger=V\nlog.tag.IptablesRestoreController=V\nlog.tag.ClatdController=V\npersist.sys.lmk.reportkills=false\nsecurity.dsmsd.enable=true\npersist.log.ewlogd=1\nsys.config.freecess_monitor=true\npersist.heapprofd.enable=1\ntraced.lazy.heapprofd=1\ndebug.enable=true\nsys.wifitracing.started=1\nsecurity.edmaudit=false\nro.sys.dropdump.on=On\npersist.systemserver.sa_bindertracker=false\n############ WARNING, EXPERIMENTAL FLAGS AHEAD!" >> $HORIZON_SYSTEM_PROPERTY_FILE 
	echo -e "\n############ WARNING, EXPERIMENTAL FLAGS AHEAD!\nsetprop log.tag.snap_api::snpe VERBOSE\nsetprop log.tag.snap_api::V3 VERBOSE\nsetprop log.tag.snap_api::V2 VERBOSE\nsetprop log.tag.snap_compute::V3 VERBOSE\nsetprop log.tag.snap_compute::V2 VERBOSE\nsetprop log.tag.snaplite_lib VERBOSE\nsetprop log.tag.snap_api::snap_eden::V3 VERBOSE\nsetprop log.tag.snap_api::snap_ofi::V1 VERBOSE\nsetprop log.tag.snap_hidl_v3 VERBOSE\nsetprop log.tag.snap_service@1.2 VERBOSE\n############ WARNING, EXPERIMENTAL FLAGS AHEAD!" > $HORIZON_HORIZON_SYSTEM_DIR/etc/init/init.debug_castleprops.rc
	warns "Debugging stuffs are enabled in this build, please proceed with caution and do remember that your device will heat more due to debugging process running in the background.." "DEBUGGING_ENABLER"
	# change the values to enable debugging without authorization.
	for i in "ro.debuggable 1" "ro.adb.secure 0"; do 
		setprop --system "$(echo $i | awk '{print $1}')" "$(echo $i | awk '{print $2}')"
	done
	for i in $HORIZON_PRODUCT_PROPERTY_FILE $HORIZON_SYSTEM_DIR/product/*/build.prop;
		existance "${i}" && setprop --product "persist.sys.usb.config" "mtp,adb"
	done
fi

if [ "$BUILD_TARGET_ANDROID_VERSION" == "14" ]; then
	console_print "removing some bloats, thnx Salvo!"
	rm -rf $HORIZON_SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.kgclient.xml \
	$HORIZON_SYSTEM_DIR/etc/public.libraries-wsm.samsung.txt \
	$HORIZON_SYSTEM_DIR/lib/libhal.wsm.samsung.so \
	$HORIZON_SYSTEM_DIR/lib/vendor.samsung.hardware.security.wsm.service-V1-ndk.so \
	$HORIZON_SYSTEM_DIR/lib64/libhal.wsm.samsung.so \
	$HORIZON_SYSTEM_DIR/lib64/vendor.samsung.hardware.security.wsm.service-V1-ndk.so \
	$HORIZON_SYSTEM_DIR/priv-app/KnoxGuard
fi

if boolReturn $TARGET_REMOVE_USELESS_SAMSUNG_APPLICATIONS_STUFFS; then
	. ${SCRIPTS[5]}
fi

if boolReturn $TARGET_INCLUDE_UNLIMITED_BACKUP; then
	console_print "Adding unlimited backup feature...."
	. ${SCRIPTS[0]}
fi

if boolReturn $TARGET_REQUIRES_BLUETOOTH_LIBRARY_PATCHES; then
	console_print "Patching bluetooth...."
	existance "$HORIZON_SYSTEM_DIR/lib64/libbluetooth_jni.so" || abort "The \"libbluetooth_jni.so\" file from the system/lib64 wasn't found, copy and put them in a random directory and try again.."
	# patch this weird device lib.
	HEX_PATCH "$HORIZON_SYSTEM_DIR/lib64/libbluetooth_jni.so" "6804003528008052" "2b00001428008052"
fi

if boolReturn $TARGET_INCLUDE_FASTBOOTD_PATCH_BY_RATCODED; then
	console_print "Patching recovery image..."
	. ${SCRIPTS[2]}
fi

if boolReturn $TARGET_INCLUDE_CUSTOM_SETUP_WELCOME_MESSAGES; then
	console_print "adding custom setup wizard text...."
	custom_setup_finished_messsage
	build_and_sign ./horizon/overlay_packages/sec_setup_wizard_horizonux_overlay/ $HORIZON_FALLBACK_OVERLAY_PATH
fi

if boolReturn $TARGET_REMOVE_NONE_SECURITY_OPTION; then
	warns_api_limitations "11"
	console_print "removing none security option from lockscreen settings..."
	echo -e "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<resources>\n\t<bool name=\"config_hide_none_security_option\">true</bool>\n" > ./horizon/packages/settings/oneui3/remove_none_option_on_security_tab/res/values/bools.xml
fi

if boolReturn $TARGET_REMOVE_SWIPE_SECURITY_OPTION; then
	console_print "removing swipe security option from lockscreen settings..."
	warns_api_limitations "11"
	echo -e "\t<bool name=\"config_hide_swipe_security_option\">true</bool>\n</resources>" >> ./horizon/packages/settings/oneui3/remove_none_option_on_security_tab/res/values/bools.xml
else
	echo "</resources>" >> ./horizon/packages/settings/oneui3/remove_none_option_on_security_tab/res/values/bools.xml
fi

if boolReturn $TARGET_REMOVE_SWIPE_SECURITY_OPTION; then
	warns_api_limitations "11"
	build_and_sign ./horizon/overlay_packages/settings/oneui3/remove_none_option_on_security_tab/ $HORIZON_FALLBACK_OVERLAY_PATH
fi

if boolReturn $TARGET_ADD_EXTRA_ANIMATION_SCALES; then
	console_print "cooking extra animation scales.."
	build_and_sign ./horizon/overlay_packages/settings/oneui3/extra_animation_scales/ $HORIZON_FALLBACK_OVERLAY_PATH
fi

if boolReturn $TARGET_ADD_ROUNDED_CORNERS_TO_THE_PIP_WINDOWS; then
	console_print "cooking rounded corners on pip window...."
	warns_api_limitations "11"
	build_and_sign ./horizon/overlay_packages/systemui/oneui3/rounded_corners_on_pip/ $HORIZON_FALLBACK_OVERLAY_PATH
fi

if boolReturn $TARGET_FLOATING_FEATURE_INCLUDE_GAMELAUNCHER_IN_THE_HOMESCREEN; then
	console_print "Enabling Game Launcher..."
	change_xml_values "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_DEFAULT_GAMELAUNCHER_ENABLE" "TRUE"
else
	warns "Disabling Game Launcher..." "TARGET_FEATURE_CONFIGURATION"
	change_xml_values "SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_DEFAULT_GAMELAUNCHER_ENABLE" "FALSE"
fi

if boolReturn $BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES; then
	console_print "Switching the default refresh rate to ${BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE}Hz..."
	change_xml_values "SEC_FLOATING_FEATURE_LCD_CONFIG_HFR_DEFAULT_REFRESH_RATE" "${BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE}"
else
	warns "Switching the default refresh rate to 60Hz (due to the BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES variable being set to false)." "TARGET_FEATURE_CONFIGURATION"
	change_xml_values "SEC_FLOATING_FEATURE_LCD_CONFIG_HFR_DEFAULT_REFRESH_RATE" "60"
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
	change_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_SUPPORT_CLOCK_LIVE_ICON" "TRUE"
else
	console_print "Enabling the live clock icon from the launcher, bad move!"
	change_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_SUPPORT_CLOCK_LIVE_ICON" "FALSE"
fi

if boolReturn $TARGET_FLOATING_FEATURE_INCLUDE_EASY_MODE; then
	console_print "Enabling Easy Mode..."
	change_xml_values "SEC_FLOATING_FEATURE_SETTINGS_SUPPORT_EASY_MODE" "TRUE"
else
	console_print "Disabling Easy Mode..."
	change_xml_values "SEC_FLOATING_FEATURE_SETTINGS_SUPPORT_EASY_MODE" "FALSE"
fi

if boolReturn $TARGET_FLOATING_FEATURE_DISABLE_BLUR_EFFECTS; then
    console_print "Disabling blur effects..."
    for blur_effects in SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_PARTIAL_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_CAPTURED_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_3D_SURFACE_TRANSITION_FLAG; do
        change_xml_values "$blur_effects" "FALSE"
    done
else
	if [ "$BUILD_TARGET_SDK_VERSION" -ge "32" ]; then
		warns "Actual blur from flagship device is not available for now, so stay tuned!" "CRYABOUTTHISPLEASE"
	elif [ "$BUILD_TARGET_SDK_VERSION" -ge "28" ]; then
		console_print "Enabling blur effects..."
		for blur_effects in SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_PARTIAL_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_CAPTURED_BLUR SEC_FLOATING_FEATURE_GRAPHICS_SUPPORT_3D_SURFACE_TRANSITION_FLAG; do
			change_xml_values "$blur_effects" "TRUE"
		done
		for props in "ro.surface_flinger.supports_background_blur 1" "persist.sys.sf.disable_blurs 0" "ro.sf.blurs_are_expensive 1"; do
			setprop --system "$(echo "$props" | awk '{print $1}')" "$(echo "$props" | awk '{print $2}')"
		done
		for files in ./device_dumps/beyond0ltexx/${BUILD_TARGET_SDK_VERSION}/system/{bin/*,lib/*,lib64/*}; do
			if existance "$files"; then
				case "$files" in
					*lib64/*)
						cp "$files" "$HORIZON_SYSTEM_DIR/lib64/" || abort "Failed to copy $files to $HORIZON_SYSTEM_DIR/lib64"
					;;
					*lib/*)
						cp "$files" "$HORIZON_SYSTEM_DIR/lib/" || abort "Failed to copy $files to $HORIZON_SYSTEM_DIR/lib"
					;;
					*bin/*)
						cp "$files" "$HORIZON_SYSTEM_DIR/bin/" || abort "Failed to copy $files to $HORIZON_SYSTEM_DIR/bin"
					;;
				esac
			fi
		done
	fi
fi

if boolReturn $TARGET_FLOATING_FEATURE_ENABLE_ENHANCED_PROCESSING; then
	console_print "Enabling Enhanced Processing.."
	for enhanced_gaming in SEC_FLOATING_FEATURE_SYSTEM_SUPPORT_LOW_HEAT_MODE SEC_FLOATING_FEATURE_COMMON_SUPPORT_HIGH_PERFORMANCE_MODE SEC_FLOATING_FEATURE_SYSTEM_SUPPORT_ENHANCED_CPU_RESPONSIVENESS; do
		change_xml_values "$enhanced_gaming" "TRUE"
	done
fi

if boolReturn $TARGET_FLOATING_FEATURE_ENABLE_EXTRA_SCREEN_MODES; then
	console_print "Adding support for extra screen modes...."
	for led_modes in SEC_FLOATING_FEATURE_LCD_SUPPORT_MDNIE_HW SEC_FLOATING_FEATURE_LCD_SUPPORT_WIDE_COLOR_GAMUT; do
		change_xml_values "${led_modes}" "FALSE"
	done
fi

if boolReturn $TARGET_FLOATING_FEATURE_SUPPORTS_WIRELESS_POWER_SHARING; then
	console_print "Enabling Wireless powershare...."
	for wireless_power_sharing_lore in SEC_FLOATING_FEATURE_BATTERY_SUPPORT_HV SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_HV SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_NIGHT_MODE \
		SEC_FLOATING_FEATURE_BATTERY_SUPPORT_WIRELESS_TX; do
		add_float_xml_values "${wireless_power_sharing_lore}" "TRUE"
	done
fi

if boolReturn $TARGET_FLOATING_FEATURE_ENABLE_ULTRA_POWER_SAVING; then
	console_print "Enabling Ultra Power Saver mode...."
	add_float_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_ULTRA_POWER_SAVING" "TRUE"
fi

if boolReturn $TARGET_FLOATING_FEATURE_DISABLE_SMART_SWITCH; then
	console_print "Disabling Smart Switch feature in setup...."
	change_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_SMART_SWITCH" "FALSE"
	apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/init_rilcommon.rc" "${DIFF_UNIFIED_PATCHES[20]}"
fi

if boolReturn $TARGET_FLOATING_FEATURE_SUPPORTS_DOLBY_IN_GAMES; then
	console_print "Enabling dolby encoding in games...."
	for dolby_in_games in SEC_FLOATING_FEATURE_AUDIO_SUPPORT_DEFAULT_ON_DOLBY_IN_GAME SEC_FLOATING_FEATURE_AUDIO_SUPPORT_DOLBY_GAME_PROFILE; do
		add_float_xml_values "${dolby_in_games}" "TRUE"
	done
fi

# let's download goodlook modules from corsicanu's repo.
echo -e "[$(date +%d-%m-%Y) - $(date +%H:%M%p)] / [:WARN:] - Starting to check and try to download goodlook modules, logs can be seen below if any errors spawn upon the process" >> $thisConsoleTempLogFile
boolReturn $TARGET_INCLUDE_SAMSUNG_THEMING_MODULES && check_internet_connection "GOODLOCK_MODULES" && download_glmodules 2>> $thisConsoleTempLogFile

# installs audio resampler.
if boolReturn $TARGET_INCLUDE_HORIZON_AUDIO_RESAMPLER; then
	console_print "Enabling HorizonUX audio resampler..."
	setprop --system "persist.horizonux.audio.resampler" "available"
else
	console_print "Disabling HorizonUX audio resampler..."
	setprop --system "persist.horizonux.audio.resampler" "unavailable"
fi

if boolReturn $TARGET_INCLUDE_HORIZON_TOUCH_FIX; then
	console_print "Adding brotherboard's GSI touch fix..."
	setprop --system "persist.horizonux.brotherboard.touch_fix" "available"
	cp -af ./horizon/rom_tweaker_script/brotherboard_touch_fix.sh $HORIZON_SYSTEM_DIR/bin/
fi

# L, see the dawn makeconfigs.prop file :\
if boolReturn $TARGET_INCLUDE_HORIZON_OEMCRYPTO_DISABLER_PLUGIN; then
	for part in $HORIZON_SYSTEM_DIR $HORIZON_VENDOR_DIR; do
		for libdir in $part/lib $part/lib64; Do
			if existance "$part/$libdir/liboemcrypto.so"; then
				touch "$part/$libdir/liboemcrypto.so"
			fi 
		done
	done
fi

# custom wallpaper-res resources_info.json generator.
if boolReturn $CUSTOM_WALLPAPER_RES_JSON_GENERATOR; then
	console_print "Opening resources_info.json generator....."
	. ${SCRIPTS[3]}
fi

# removes useless samsung stuffs from the vendor partition.
if boolReturn $TARGET_REMOVE_USELESS_VENDOR_STUFFS; then
	console_print "Nuking useless vendor stuffs..."
    nuke_stuffs
	console_print "Finished removing useless vendor file(s), "
	console_print "Don't worry, if you have bootloops, then dm my bot with logs"
fi

# nukes display refresh rate overrides on some video platforms.
if boolReturn $DISABLE_DISPLAY_REFRESH_RATE_OVERRIDE; then
	console_print "Disabling Refresh rate override from surfaceflinger..."
	sed -i \
		"/max_frame_buffer_acquired_buffers/a ro.surface_flinger.enable_frame_rate_override=false" \
		"$HORIZON_VENDOR_DIR/default.prop"	
fi

# disable's DRC shit
if boolReturn $DISABLE_DYNAMIC_RANGE_COMPRESSION; then
	console_print "Disabling Dynamic Range Compression..."
	sed -i 's/speaker_drc_enabled="true"/speaker_drc_enabled="false"/' $HORIZON_VENDOR_DIR/etc/audio_policy_configuration.xml
fi

if boolReturn $DISABLE_SAMSUNG_ASKS_SIGNATURE_VERFICATION; then
	console_print "Disabling Samsung's ASKS..."
	check_existence_of_property "ro.build.official.release" > $TMPFILE && setprop --$(absolute_path --$(cat $TMPFILE)) "ro.build.official.release" "false"
fi

if boolReturn $FORCE_HARDWARE_ACCELERATION; then
	warns "Enabling hardware acceleration..." "MISC"
	for i in "debug.hwui.renderer skiagl" "video.accelerate.hw 1" "debug.sf.hw 1" \
	"debug.performance.tuning 0" "debug.egl.hw 1" "debug.composition.type gpu"; do
		# use echo to null-terminate the var value.
		setprop --system "$(echo "${i}" | awk '{printf $1}')" "$(echo "${i}" | awk '{printf $2}')"
	done
fi

if boolReturn "$BUILD_TARGET_REMOVE_SYSTEM_LOGGING"; then
	console_print "Disabling unnecessary logging stuffs in android..."
	add_float_xml_values "SEC_FLOATING_FEATURE_SYSTEM_CONFIG_SYSINT_DQA_LOGLEVEL" "3"
	setprop --system "logcat.live" "disable"
	setprop --system "sys.dropdump.on" "Off"
	setprop --system "persist.debug.atrace.boottrace" "0"
	setprop --system "persist.log.ewlogd" "0"
	setprop --system "sys.lpdumpd" "0"
	setprop --system "persist.device_config.global_settings.sys_traced" "0"
	setprop --system "persist.traced.enable" "0"
	setprop --system "persist.sys.lmk.reportkills" "false"
	setprop --system "log.tag.ConnectivityManager" "S"
	setprop --system "log.tag.ConnectivityService" "S"
	setprop --system "log.tag.NetworkLogger" "S"
	setprop --system "log.tag.IptablesRestoreController" "S"
	setprop --system "log.tag.ClatdController" "S"
if [[ "${BUILD_TARGET_SDK_VERSION}" -ge 28 && "${BUILD_TARGET_SDK_VERSION}" -le 31 ]]; then
    apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/init_rilcommon.rc" "${DIFF_UNIFIED_PATCHES[20]}"
    if [[ "${BUILD_TARGET_SDK_VERSION}" -eq 28 ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[0]}"
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[6]}"
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[9]}"
    elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq 29 ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[7]}"
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[1]}"
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[10]}"
    elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq 30 ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[8]}"
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[2]}"
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[11]}"
    elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq 31 ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[9]}"
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[3]}"
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/logd.rc" "${DIFF_UNIFIED_PATCHES[12]}"
    fi
fi

if boolReturn "$BUILD_TARGET_BRING_NEWGEN_ASSISTANT"; then
	console_print "Enabling New Gen Google Assistant..."
	setprop --system "ro.opa.eligible_device" "true"
fi

if boolReturn "$BUILD_TARGET_ADD_MOBILE_DATA_TOGGLE_IN_POWER_MENU"; then
	console_print "Enabling Mobile data toggle in the power menu.."
	add_csc_xml_values "CscFeature_Framework_SupportDataModeSwitchGlobalAction" "TRUE"
fi

if boolReturn "$BUILD_TARGET_FORCE_FIVE_BAR_NETICON"; then
	console_print "Enabling 5 network bars..."
	add_csc_xml_values "CscFeature_SystemUI_ConfigMaxRssiLevel" "5"
fi

if boolReturn "$BUILD_TARGET_FORCE_SYSTEM_TO_PLAY_MUSIC_WHILE_RECORDING"; then
	console_print "Forcing the system to not close music apps while recording a video..."
	add_csc_xml_values "CscFeature_Camera_CamcorderDoNotPauseMusic" "TRUE"
fi

if boolReturn "$BUILD_TARGET_ADD_NETWORK_SPEED_WIDGET"; then
	console_print "Enabling network speed bar in qs.."
	add_csc_xml_values "CscFeature_Setting_SupportRealTimeNetworkSpeed" "TRUE"
	[ "$BUILD_TARGET_SDK_VERSION" -ge "34" ] && add_csc_xml_values "CscFeature_Common_SupportZProjectFunctionInGlobal" "TRUE"
fi

if boolReturn "$BUILD_TARGET_FORCE_SYSTEM_TO_NOT_CLOSE_CAMERA_WHILE_CALLING"; then
	console_print "Forcing system to not close the camera app while calling..."
	add_csc_xml_values "CscFeature_Camera_EnableCameraDuringCall" "TRUE"
fi

if boolReturn "$BUILD_TARGET_ADD_CALL_RECORDING_IN_SAMSUNG_DIALER"; then
	console_print "Adding call recording feature in samsung dialler, please note that im not responsible for legal actions against you!"
	add_csc_xml_values "CscFeature_VoiceCall_ConfigRecording" "RecordingAllowedByMenu"
fi

if boolReturn "$BUILD_TARGET_DISABLE_KNOX_PROPERTIES"; then
	console_print "Disabling Knox and applying rmm fix.."
	setprop --system "ro.securestorage.knox" "false"
	setprop --system "ro.security.vaultkeeper.native" "0"
	if [ "$BUILD_TARGET_SDK_VERSION" == "34" ]; then
		# Thanks salvo!
		setprop --system security.mdf.result   "                       "
		setprop --system security.mdf   "                       "
		setprop --system ro.security.mdf.ver   "                       "
		setprop --system ro.security.mdf.release   "                       "
		setprop --system ro.security.wlan.ver   "                       "
		setprop --system ro.security.wlan.release   "                       "
		setprop --system ro.security.bt.ver   "                       "
		setprop --system ro.security.bt.release  "                       "
		setprop --system ro.security.bio.ver "                  "
		setprop --system ro.security.bio.release  "                   "
		setprop --system ro.security.mdf.ux "        "
		setprop --system "ro.security.fips.ux" "Disabled"
		setprop --system ro.security.fips_bssl.ver "                     "
		setprop --vendor ro.security.fips_skc.ver "                       "
		setprop --vendor ro.security.fips_scrypto.ver "                  "
	fi
	add_csc_xml_values "CscFeature_Knox_SupportKnoxGuard" "FALSE"
fi

if boolReturn "$BUILD_TARGET_DISABLE_WIFI_CALLING"; then
	console_print "Disabling Wifi calling.."
	add_csc_xml_values "CscFeature_Setting_SupportWifiCall" "FALSE"
	add_csc_xml_values "CscFeature_Setting_SupportWiFiCallingMenu" "FALSE"
else 
	console_print "Enabling Wifi calling.."
	add_csc_xml_values "CscFeature_Setting_SupportWifiCall" "TRUE"
	add_csc_xml_values "CscFeature_Setting_SupportWiFiCallingMenu" "TRUE"
fi

if boolReturn "$BUILD_TARGET_SKIP_SETUP_JUNKS"; then
	console_print "Disabling junks on setup...."
	add_csc_xml_values "CscFeature_Setting_SkipWifiActvDuringSetupWizard" "FALSE"
	add_csc_xml_values "CscFeature_Setting_SkipStepsDuringSamsungSetupWizard" "TRUE"
fi

if boolReturn "$BLOCK_NOTIFICATION_SOUNDS_DURING_PLAYBACK"; then
	console_print "Blocking notification sounds on playbacks.."
	add_csc_xml_values "CscFeature_Video_BlockNotiSoundDuringStreaming" "TRUE"
fi

if boolReturn "$BUILD_TARGET_FORCE_SYSTEM_TO_PLAY_SMTH_WHILE_CALL"
	add_csc_xml_values "CscFeature_Video_SupportPlayDuringCall" "TRUE"
	console_print "Forced the system to play media while call..."
fi

if boolReturn "$FORCE_ENABLE_POP_UP_PLAYER_ON_SVP"; then
	add_csc_xml_values "CscFeature_Video_EnablePopupPlayer" "TRUE"
	console_print "Forced samsung video player to work on pop-up window..."
fi

if boolReturn "$BUILD_TARGET_FORCE_DISABLE_SETUP_WIZARD"; then
	console_print "Disabling Setup Wizard...."
	add_csc_xml_values "CscFeature_SetupWizard_DisablePrivacyPolicyAgreement" "TRUE"
fi

if [ "${BUILD_TARGET_SDK_VERSION}" -ge "34" ] && boolReturn "$BRINGUP_CN_SMARTMANAGER_DEVICE"; then
	console_print "Replacing stock smartmanager and device care with the chinese version..."
	# mkdir at the temp dir
	mkdir -p ../local_build/etc/permissions/ ../local_build/etc/app/SmartManager_v6_DeviceSecurity \
	../local_build/etc/app/SmartManager_v6_DeviceSecurity_CN ../local_build/etc/priv-app/SmartManager_v5 ../local_build/etc/priv-app/SmartManager_v6_DeviceSecurity \
	../local_build/etc/priv-app/SmartManagerCN ../local_build/etc/priv-app/SmartManager_v6_DeviceSecurity_CN ../local_build/etc/priv-app/SAppLock ../local_build/etc/priv-app/Firewall;
	{
		# now move these for a quick revert if anything goes wrong.
		# xmls
		mv "$HORIZON_SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.lool.xml" "../local_build/etc/permissions/"
		mv "$HORIZON_SYSTEM_DIR/etc/permissions/signature-permissions-com.samsung.android.lool.xml" "../local_build/etc/permissions/"
		mv "$HORIZON_SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity_v6.xml" "../local_build/etc/permissions/"
		mv "$HORIZON_SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.sm_cn.xml" "../local_build/etc/permissions/"
		mv "$HORIZON_SYSTEM_DIR/etc/permissions/signature-permissions-com.samsung.android.sm_cn.xml" "../local_build/etc/permissions/"
		mv "$HORIZON_SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity.tcm_v6.xml" "../local_build/etc/permissions/"
		mv "$HORIZON_SYSTEM_DIR/etc/permissions/privapp-permissions-com.samsung.android.applock.xml" "../local_build/etc/permissions/"
		mv "$HORIZON_SYSTEM_DIR/etc/permissions/privapp-permissions-com.sec.android.app.firewall.xml" "../local_build/etc/permissions/"
		# actual thing
		mv "$HORIZON_SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity/*" "../local_build/etc/app/SmartManager_v6_DeviceSecurity"
		mv "$HORIZON_SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity_CN/*" "../local_build/etc/app/SmartManager_v6_DeviceSecurity_CN"
		mv "$HORIZON_SYSTEM_DIR/priv-app/SmartManager_v5/*" "../local_build/etc/priv-app/SmartManager_v5"
		mv "$HORIZON_SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity/*" "../local_build/etc/priv-app/SmartManager_v6_DeviceSecurity"
		mv "$HORIZON_SYSTEM_DIR/priv-app/SmartManagerCN/*" "../local_build/etc/priv-app/SmartManagerCN"
		mv "$HORIZON_SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity_CN/*" "../local_build/etc/priv-app/SmartManager_v6_DeviceSecurity_CN"
		mv "$HORIZON_SYSTEM_DIR/priv-app/SAppLock/*" "../local_build/etc/priv-app/SAppLock"
		mv "$HORIZON_SYSTEM_DIR/priv-app/Firewall/*" "../local_build/etc/priv-app/Firewall"
		# change float values, as per updater-script from @saadelasfur/SmartManager/Installers/SmartManagerCN/updater-script
		# https://github.com/saadelasfur/SmartManager/blob/5a547850d8049ce0bfd6528d660b2735d6a18291/Installers/SmartManagerCN/updater-script#L87
		#                                                          -                                                                           #
		# https://github.com/saadelasfur/SmartManager/blob/5a547850d8049ce0bfd6528d660b2735d6a18291/Installers/SmartManagerCN/updater-script#L99
	} &>$thisConsoleTempLogFile
	change_xml_values "SEC_FLOATING_FEATURE_SMARTMANAGER_CONFIG_PACKAGE_NAME" "com.samsung.android.sm_cn"
	change_xml_values "SEC_FLOATING_FEATURE_SECURITY_CONFIG_DEVICEMONITOR_PACKAGE_NAME" "com.samsung.android.sm.devicesecurity.tcm"
	add_float_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_NAL_PRELOADAPP_REGULATION" "TRUE"
	for i in ${SMARTMANAGER_CN_DOWNLOADABLE_CONTENTS[@]}; do
		for j in ${SMARTMANAGER_CN_DOWNLOADABLE_CONTENTS_SAVE_PATHS[@]}; do
			download_stuffs "${i}" "${j}" || {
				{
					# actual thing
					mv "../local_build/etc/priv-app/Firewall/*" "$HORIZON_SYSTEM_DIR/priv-app/Firewall/"
					mv "../local_build/etc/priv-app/SAppLock/*" "$HORIZON_SYSTEM_DIR/priv-app/SAppLock/"
					mv "../local_build/etc/priv-app/SmartManager_v6_DeviceSecurity_CN/*" "$HORIZON_SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity_CN/"
					mv "../local_build/etc/priv-app/SmartManagerCN/*" "$HORIZON_SYSTEM_DIR/priv-app/SmartManagerCN/"
					mv "../local_build/etc/priv-app/SmartManager_v6_DeviceSecurity/*" "$HORIZON_SYSTEM_DIR/priv-app/SmartManager_v6_DeviceSecurity/"
					mv "../local_build/etc/priv-app/SmartManager_v5/*" "$HORIZON_SYSTEM_DIR/priv-app/SmartManager_v5/"
					mv "../local_build/etc/app/SmartManager_v6_DeviceSecurity_CN/*" "$HORIZON_SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity_CN/"
					mv "../local_build/etc/app/SmartManager_v6_DeviceSecurity/*" "$HORIZON_SYSTEM_DIR/app/SmartManager_v6_DeviceSecurity/"
					# xmls
					mv "../local_build/etc/permissions/privapp-permissions-com.sec.android.app.firewall.xml" "$HORIZON_SYSTEM_DIR/etc/permissions/"
					mv "../local_build/etc/permissions/privapp-permissions-com.samsung.android.applock.xml" "$HORIZON_SYSTEM_DIR/etc/permissions/"
					mv "../local_build/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity.tcm_v6.xml" "$HORIZON_SYSTEM_DIR/etc/permissions/"
					mv "../local_build/etc/permissions/signature-permissions-com.samsung.android.sm_cn.xml" "$HORIZON_SYSTEM_DIR/etc/permissions/"
					mv "../local_build/etc/permissions/privapp-permissions-com.samsung.android.sm_cn.xml" "$HORIZON_SYSTEM_DIR/etc/permissions/"
					mv "../local_build/etc/permissions/privapp-permissions-com.samsung.android.sm.devicesecurity_v6.xml" "$HORIZON_SYSTEM_DIR/etc/permissions/"
					mv "../local_build/etc/permissions/signature-permissions-com.samsung.android.lool.xml" "$HORIZON_SYSTEM_DIR/etc/permissions/"
					mv "../local_build/etc/permissions/privapp-permissions-com.samsung.android.lool.xml" "$HORIZON_SYSTEM_DIR/etc/permissions/"
				} &>$thisConsoleTempLogFile
				warns "Failed to download stuffs from @saadelasfur github repo, moved everything to their places!" "FAILED_TO_DOWNLOAD_SMARTMANAGER"
			}
		done
	done
fi

# brotherboard
{
	if boolReturn "$TINKER_MAX_REFRESH_RATE"; then
		if [[ -z "${DTBO_IMAGE_PATH}" || ! -f "${DTBO_IMAGE_PATH}" ]]; then
			warns "Can't patch dtbo because the dtbo image path is inaccessable." "DTBO_PATCH_FAILED"
		else
			. ${SCRIPTS[6]}
		fi
	fi
}
# brotherboard

# let's extend audio offload buffer size to 256kb and plug some of our things.
console_print "Running misc jobs..."
add_csc_xml_values "CscFeature_Setting_InfinitySoftwareUpdate" "TRUE"
add_csc_xml_values "CscFeature_Setting_DisableMenuSoftwareUpdate" "TRUE"
add_csc_xml_values "CscFeature_Settings_GOTA" "TRUE"
add_csc_xml_values "CscFeature_Settings_FOTA" "FALSE"
if [[ -n "${BUILD_TARGET_BOOT_ANIMATION_FPS}" && "${BUILD_TARGET_BOOT_ANIMATION_FPS}" -le "60" && -n "${BUILD_TARGET_SHUTDOWN_ANIMATION_FPS}" && "${BUILD_TARGET_SHUTDOWN_ANIMATION_FPS}" -le "60" ]]; then
	setprop --system "boot.fps" "${BUILD_TARGET_BOOT_ANIMATION_FPS}"
	setprop --system "shutdown.fps" "${BUILD_TARGET_SHUTDOWN_ANIMATION_FPS}"
fi
default_language_configuration ${NEW_DEFAULT_LANGUAGE_ON_PRODUCT} ${NEW_DEFAULT_LANGUAGE_COUNTRY_ON_PRODUCT}
change_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE" "${TARGET_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE}"
setprop --vendor "vendor.audio.offload.buffer.size.kb" "256"
rm -rf $HORIZON_SYSTEM_DIR/hidden $HORIZON_SYSTEM_DIR/preload $HORIZON_SYSTEM_DIR/recovery-from-boot.p $HORIZON_SYSTEM_DIR/bin/install-recovery.sh
cp -af ./misc/etc/ringtones_and_etc/media/audio/* $HORIZON_SYSTEM_DIR/media/audio/
cp -af ./horizon/rom_tweaker_script/init.ellen.rc $HORIZON_SYSTEM_DIR/etc/init/
cp -af ./horizon/rom_tweaker_script/ellenJoe.sh $HORIZON_SYSTEM_DIR/bin/
boolReturn $TARGET_INCLUDE_HORIZON_TOUCH_FIX && echo -e "\nservice brotherboard_touch_fix /system/bin/bashScriptLoader --brotherboard-touch-fix\n\tuser root\n\tgroup root\n\toneshot\n\n# let's start this daemon on sys.boot_completed = 1\non property:sys.boot_completed=1\n\tstart brotherboard_touch_fix\n# Thanks brotherboard" >> $HORIZON_SYSTEM_DIR/etc/init/init.ellen.rc
change_xml_values "SEC_FLOATING_FEATURE_COMMON_SUPPORT_SAMSUNG_MARKETING_INFO" "FALSE"
boolReturn $TARGET_INCLUDE_CUSTOM_BRAND_NAME && change_xml_values "SEC_FLOATING_FEATURE_SETTINGS_CONFIG_BRAND_NAME" "${BUILD_TARGET_CUSTOM_BRAND_NAME}"
existance "$HORIZON_SYSTEM_DIR/$(fetch_rom_arch --libpath)/libhal.wsm.samsung.so" && touch $HORIZON_SYSTEM_DIR/$(fetch_rom_arch --libpath)/libhal.wsm.samsung.so
for i in "logcat.live disable" "sys.dropdump.on Off" "profiler.force_disable_err_rpt 1" "profiler.force_disable_ulog 1" \
		 "sys.lpdumpd 0" "persist.device_config.global_settings.sys_traced 0" "persist.traced.enable 0" "persist.sys.lmk.reportkills false" \
		 "log.tag.ConnectivityManager S" "log.tag.ConnectivityService S" "log.tag.NetworkLogger S" \
		 "log.tag.IptablesRestoreController S" "log.tag.ClatdController S"; do
			# use echo to null-terminate the var value.
			setprop --system "$(echo "${i}" | awk '{printf $1}')" "$(echo "${i}" | awk '{printf $2}')"
done
if existance "./horizon/bootanimations/${BUILD_TARGET_SCREEN_WIDTH}x${BUILD_TARGET_SCREEN_HEIGHT}/"; then
	cp -af ./horizon/bootanimations/${BUILD_TARGET_SCREEN_WIDTH}x${BUILD_TARGET_SCREEN_HEIGHT}/bootsamsungloop.qmg $HORIZON_SYSTEM_DIR/media/
	cp -af ./horizon/bootanimations/${BUILD_TARGET_SCREEN_WIDTH}x${BUILD_TARGET_SCREEN_HEIGHT}/bootsamsung.qmg $HORIZON_SYSTEM_DIR/media/
fi
if [[ "${BUILD_TARGET_SDK_VERSION}" -ge "28" && "${BUILD_TARGET_SDK_VERSION}" -le "33" ]]; then
    if [[ "$BUILD_TARGET_SDK_VERSION" -eq "28" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[4]}"
    fi
    # Let's patch restart_radio_process for my own will. PLEASE LET THIS SLIDE OUTT!!!!
    if [[ "${BUILD_TARGET_SDK_VERSION}" -ge "29" && "${BUILD_TARGET_SDK_VERSION}" -le "33" ]]; then
        apply_diff_patches "$HORIZON_SYSTEM_DIR/etc/restart_radio_process.sh" "${DIFF_UNIFIED_PATCHES[19]}"
    fi
    if [[ "${BUILD_TARGET_SDK_VERSION}" -eq "29" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[5]}"
    elif [[ "${BUILD_TARGET_SDK_VERSION}" -ge "30" && "${BUILD_TARGET_SDK_VERSION}" -le "31" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[17]}"
    elif [[ "${BUILD_TARGET_SDK_VERSION}" -ge "32" && "${BUILD_TARGET_SDK_VERSION}" -le "33" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[18]}"
    fi
    if [[ "${BUILD_TARGET_SDK_VERSION}" -eq "30" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/uncrypt.rc" "${DIFF_UNIFIED_PATCHES[19]}"
        apply_diff_patches "$HORIZON_SYSTEM_DIR/etc/init/vold.rc" "${DIFF_UNIFIED_PATCHES[22]}"
    elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq "31" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/bootchecker.rc" "${DIFF_UNIFIED_PATCHES[16]}"
    fi
fi
if [[ "${BUILD_TARGET_SDK_VERSION}" -ge "28" && "${BUILD_TARGET_SDK_VERSION}" -le "30" ]]; then
    cat ./diff_patches/system/etc/init/freecess.rc > "$HORIZON_SYSTEM_DIR/etc/init/freecess.rc"
fi
if ask "Do you want to add a stub app for missing activities?"; then
	mkdir -p $HORIZON_SYSTEM_DIR/app/HorizonStub/
	build_and_sign "./horizon/packages/HorizonStub" "$HORIZON_SYSTEM_DIR/app/HorizonStub/"
fi
console_print "Check the ../local_build/ folder for the items you have built."
console_print "Please sign the built overlay or application packages manually with your own private keys;"
console_print "Do not use any public keys provided by any application building software. "
console_print "script errors are moved to the ../local_build/logs/error_ring.log file, please consider checking it out! "
if boolReturn "${BATTLEMAGE_BUILD}"; then
	console_print "Please review the image for the changes, if the changes aren't applied you can always extract and mod them"
    umount $HASH_KEY_FOR_SUPER_BLOCK_PATH
    rmdir $HASH_KEY_FOR_SUPER_BLOCK_PATH
fi

[ "${isXmlDecoded}" == "true" ] && tinkerWithCSCFeaturesFile --encode
mv $thisConsoleTempLogFile ../local_build/logs/$thisConsoleTempLogFile.log

# fuck this fucking directory before it fucking fucks up the fucking use cases man, fuck this fucking bullshit that i have to fuck with
# hope this fucking shit ends fucking soon.
rm -rf $TMPDIR

[ "$(string_format -l $openSeperateConsoleForDebugging)" == "true" ] || { \
	echo "[$(date +%d-%m-%Y) - $(date +%H:%M%p)] / [:WARN:] - This console will get killed soon, share the logs to the developer's handle if you are concerned about anything!" >> $thisConsoleTempLogFile;
	kill $pid &>/dev/null;
}