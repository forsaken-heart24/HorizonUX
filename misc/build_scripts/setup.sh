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
	echo -e "\n# HorizonUX Audio resampler manager prop\npersist.horizonux.audio.resampler=available\n" >> $HORIZON_SYSTEM_PROPERTY_FILE
else
	console_print "Disabling HorizonUX audio resampler..."
	echo -e "\n# HorizonUX Audio resampler manager prop\npersist.horizonux.audio.resampler=unavailable\n" >> $HORIZON_SYSTEM_PROPERTY_FILE
fi

if boolReturn $TARGET_INCLUDE_HORIZON_TOUCH_FIX; then
	console_print "Adding brotherboard's GSI touch fix..."
	echo -e "persist.horizonux.brotherboard.touch_fix=available\n" >> $HORIZON_SYSTEM_PROPERTY_FILE
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
	mkdir -p ./build/vendor/etc/init/
    nuke_stuffs
	console_print "Finished removing stuffs from wifi.rc file, checkout patched_resources/vendor/etc/init/ folder"
	console_print " and yeah besure to copy that into your actual vendor/etc/init folder and try if it works or not!"
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

# let's extend audio offload buffer size to 256kb and plug some of our things.
console_print "Running misc jobs..."
default_language_configuration ${NEW_DEFAULT_LANGUAGE_ON_PRODUCT} ${NEW_DEFAULT_LANGUAGE_COUNTRY_ON_PRODUCT}
change_xml_values "SEC_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE" "${TARGET_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE}"
setprop --vendor "vendor.audio.offload.buffer.size.kb" "256"
rm -rf $HORIZON_SYSTEM_DIR/hidden $HORIZON_SYSTEM_DIR/preload $HORIZON_SYSTEM_DIR/recovery-from-boot.p $HORIZON_SYSTEM_DIR/bin/install-recovery.sh
cp -af ./misc/etc/ringtones_and_etc/media/audio/* $HORIZON_SYSTEM_DIR/media/audio/
cp -af ./horizon/rom_tweaker_script/init.ishimiiiiiiiiiiiiiii.rc $HORIZON_SYSTEM_DIR/etc/init/
cp -af ./horizon/rom_tweaker_script/ishimiiiiiiiiii.sh $HORIZON_SYSTEM_DIR/bin/
boolReturn $TARGET_INCLUDE_HORIZON_TOUCH_FIX && echo -e "\nservice brotherboard_touch_fix /system/bin/sh -c /system/bin/brotherboard_touch_fix.sh\n\tuser root\n\tgroup root\n\toneshot" >> $HORIZON_SYSTEM_DIR/etc/init/init.ishimiiiiiiiiiiiiiii.rc
# boolReturn "$SWITCH_TO_HIGH_REFRESH_RATE_ON_LOCKSCREEN" && {
#	gcc -I../../include/ ../../include/horizonutils.c ../../include/horizonux.c ./changeToPeakRefreshRateifTheDeviceisInLockscreen.c -o changeToPeakRefreshRateifTheDeviceisInLockscreen.elf
#	cp changeToPeakRefreshRateifTheDeviceisInLockscreen.elf $HORIZON_SYSTEM_DIR/bin/changeToPeakRefreshRateifTheDeviceisInLockscreen
#	rm -rf changeToPeakRefreshRateifTheDeviceisInLockscreen.elf
#	echo -e "\nservice changeToPeakRefreshRateifTheDeviceisInLockscreen /system/bin/changeToPeakRefreshRateifTheDeviceisInLockscreen \n\tuser system\n\tgroup system\n\n#make this junk run after the boot\non property:sys.boot_completed=1\n\tstart changeToPeakRefreshRateifTheDeviceisInLockscreen\n" >> $HORIZON_SYSTEM_DIR/etc/init/init.ishimiiiiiiiiiiiiiii.rc
#}
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
		apply_diff_patches "$HORIZON_SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[8]}"
		apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[13]}"
	fi
    # let's patch restart_radio_process for my own will. PLEASE LET THIS SLIDE OUTT!!!!
    if [[ "${BUILD_TARGET_SDK_VERSION}" -eq "29" || "${BUILD_TARGET_SDK_VERSION}" -le "33" ]]; then
        apply_diff_patches "$HORIZON_SYSTEM_DIR/etc/restart_radio_process.sh" "${DIFF_UNIFIED_PATCHES[0]}"
    fi
    if [[ "${BUILD_TARGET_SDK_VERSION}" -eq "29" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[1]}"
		apply_diff_patches "$HORIZON_SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[9]}"
    elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq "30" || "${BUILD_TARGET_SDK_VERSION}" -eq "31" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[2]}"
    elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq "32" || "${BUILD_TARGET_SDK_VERSION}" -eq "33" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/wifi.rc" "${DIFF_UNIFIED_PATCHES[3]}"
    fi
    if [[ "${BUILD_TARGET_SDK_VERSION}" -eq "30" ]]; then
        apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/uncrypt.rc" "${DIFF_UNIFIED_PATCHES[4]}"
		apply_diff_patches "$HORIZON_SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[10]}"
		apply_diff_patches "$HORIZON_SYSTEM_DIR/etc/init/vold.rc" "${DIFF_UNIFIED_PATCHES[12]}"
    elif [[ "${BUILD_TARGET_SDK_VERSION}" -eq "31" ]]; then
    	apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/dumpstate.rc" "${DIFF_UNIFIED_PATCHES[5]}"
    	apply_diff_patches "$HORIZON_VENDOR_DIR/etc/init/bootchecker.rc" "${DIFF_UNIFIED_PATCHES[6]}"
		apply_diff_patches "$HORIZON_SYSTEM_DIR/etc/init/atrace.rc" "${DIFF_UNIFIED_PATCHES[11]}"
    fi
    if [[ "${BUILD_TARGET_SDK_VERSION}" -le "31" ]]; then
        apply_diff_patches "$HORIZON_SYSTEM_DIR/etc/init/init_rilcommon.rc" "${DIFF_UNIFIED_PATCHES[7]}"
    fi
fi
if [[ "${BUILD_TARGET_SDK_VERSION}" -ge "28" || "${BUILD_TARGET_SDK_VERSION}" -le "30" ]]; then
	cat ./diff_patches/system/etc/init/freecess.rc > "$HORIZON_SYSTEM_DIR/etc/init/freecess.rc"
fi
if ask "Do you want to add a stub app for missing activities?"; then
	# build_and_sign <apktool decoded package path> <output path>
	mkdir -p $HORIZON_SYSTEM_DIR/app/HorizonStub/
	build_and_sign "./horizon/packages/HorizonStub" "$HORIZON_SYSTEM_DIR/app/HorizonStub/"
fi
console_print "Check the /build folder for the items you have built."
console_print "Please sign the built overlay or application packages manually with your own private keys;"
console_print "Do not use any public keys provided by any application building software. "
console_print "script errors are moved to the ./error_ring.log file, please consider checking it out! "
if boolReturn "${BATTLEMAGE_BUILD}"; then
	console_print "Please review the image for the changes, if the changes aren't applied you can always extract and mod them"
    umount $HASH_KEY_FOR_SUPER_BLOCK_PATH
    rmdir $HASH_KEY_FOR_SUPER_BLOCK_PATH
fi
[ "$(string_format -l $openSeperateConsoleForDebugging)" == "true" ] || { \
	echo "[$(date +%d-%m-%Y) - $(date +%H:%M%p)] / [:WARN:] - This console will get killed because this script didn't run properly, share the logs with the developer's handle." >> $thisConsoleTempLogFile;
	kill $pid &>/dev/null;
}
cp $thisConsoleTempLogFile ./$thisConsoleTempLogFile.log