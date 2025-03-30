![emergency_food_again](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food_again.png?raw=true)

# Build Configuration Variables

## TODO: Should be filled by the builder
- **SYSTEM_DIR**: Put your extracted system folder path there.
- **SYSTEM_EXT_DIR**: Put your extracted system_ext folder path there.
- **VENDOR_DIR**: Put your extracted vendor folder path there.
- **PRODUCT_DIR**: Put your extracted product folder path there.
- **PRISM_DIR**: Put your extracted product folder path there and set **BUILD_TARGET_USES_DYNAMIC_PARTITIONS** to true.
- **PRODUCT_CSC_NAME**: The csc code of your product image, don't put random string there.
- **TARGET_BUILD_PRODUCT_NAME**: Ensure ro.product.system.device (from /system/build.prop) matches in all caps. Fallback to genericTargetProperties.conf if device blobs are missing.

## Device Name & Setup
- **TARGET_INCLUDE_CUSTOM_SETUP_WELCOME_MESSAGES**: Enables custom welcome message during setup.
- **CUSTOM_SETUP_WELCOME_MESSAGE**: Fill-up your custom setup wizard welcome and goodbye texts, requires `TARGET_INCLUDE_CUSTOM_SETUP_WELCOME_MESSAGES` to be set to true

## Debugging & Performance
- **TARGET_BUILD_IS_FOR_DEBUGGING**: Enables verbose logging for debugging, which impacts performance.
- **TARGET_FLOATING_FEATURE_ENABLE_ENHANCED_PROCESSING**: Tries to boost performance at the cost of overheating and battery life.

## Security
- **TARGET_REMOVE_NONE_SECURITY_OPTION**: Disables the "None" option for lock screen security. Found in Android 11 and 12, but its compatibility with newer Android versions is uncertain.
- **TARGET_REMOVE_SWIPE_SECURITY_OPTION**: Disables the swipe-to-unlock option. Found in Android 11 and 12, but it may not work on newer Android versions.

## Bloatware & Features
- **TARGET_REMOVE_USELESS_VENDOR_STUFFS**: Removes bloat from the vendor partition.
- **TARGET_REMOVE_SAMSUNG_APPLICATIONS_STUFFS**: Removes unnecessary Samsung apps (note: Android 9 is not fully supported).
- **TARGET_ADD_EXTRA_ANIMATION_SCALES**: Adds extra animation scales for customization.
- **TARGET_FLOATING_FEATURE_DISABLE_BLUR_EFFECTS**: Disables blur effects for better performance and battery life.
- **TARGET_FLOATING_FEATURE_ENABLE_ULTRA_POWER_SAVING**: Ultra power saving, this thing is useless but yeah if you want it then take it.
- **TARGET_FLOATING_FEATURE_DISABLE_SMART_SWITCH**: Disables Smart Switch on setup.

## Special Features
- **TARGET_INCLUDE_UNLIMITED_BACKUP**: Enables unlimited pictures backup in a specific app.
- **TARGET_INCLUDE_SAMSUNG_THEMING_MODULES**: Installs patched Samsung Goodlock modules.
- **TARGET_FLOATING_FEATURE_INCLUDE_SPOTIFY_AS_ALARM**: Includes Spotify into the Alarm tones
- **TARGET_FLOATING_FEATURE_INCLUDE_EASY_MODE**: Easy mode, for huge icons and things, specifically made for people(s) who has difficulty in reading
- **TARGET_FLOATING_FEATURE_INCLUDE_CLOCK_LIVE_ICON**: Disable this, useless thing ever made.
- **TARGET_FLOATING_FEATURE_ENABLE_EXTRA_SCREEN_MODES**: This feature requires proper or bare minimum mdNIE support on the ROM and maybe the device to get it workin' properly

## Audio & Display
- **TARGET_INCLUDE_HORIZON_AUDIO_RESAMPLER**: Fixes LDAC audio distortion for lower-end Bluetooth audio devices.
- **DISABLE_DISPLAY_REFRESH_RATE_OVERRIDE**: Disables refresh rate override during media playback.
- **TARGET_FLOATING_FEATURE_SUPPORTS_DOLBY_IN_GAMES**: Toggles Dolby audio on games. (only if supported + if the hw is capable of doing this)
- **DISABLE_DYNAMIC_RANGE_COMPRESSION**: Dynamic range compression (DRC) is a process that reduces the difference between the loudest and quietest parts of an audio signal.

## Additional Customization
- **TARGET_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE**: Adjusts launcher animation for different performance tiers (LowEnd, LowestEnd, LowEndFast, Mass (mid-rangers, not available after 3.1), HighEnd, CHNHighEND & HighEnd_Tablet).
- **CUSTOM_WALLPAPER_RES_JSON_GENERATOR**: Adds multiple wallpapers with ease.
- **TARGET_BUILD_ADD_MOBILE_DATA_TOGGLE_IN_POWER_MENU**: Brings mobile data toggle on the power menu context.
- **TARGET_BUILD_FORCE_FIVE_BAR_NETICON**: Force the network icon to show 5 bars
- **TARGET_BUILD_ADD_CALL_RECORDING_IN_SAMSUNG_DIALER**: Force enables Call Recording in the Samsung Dialer App | Please note that i'm not responsible for legal actions against you
- **TARGET_BUILD_FORCE_SYSTEM_TO_NOT_CLOSE_CAMERA_WHILE_CALLING**: Forces the system to not close the camera app while calling
- **TARGET_BUILD_FORCE_SYSTEM_TO_PLAY_MUSIC_WHILE_RECORDING**: Forces the system to play song(s) / music(s) while recording a video
- **TARGET_BUILD_DISABLE_WIFI_CALLING**: Disables wifi calling if it set to true, otherwise (true), it enables it if disabled.
- **TARGET_BUILD_SKIP_SETUP_JUNKS**: Skips setup junks.
- **BLOCK_NOTIFICATION_SOUNDS_DURING_PLAYBACK** Disables annoying sounds while consuming video(s) or audio(s) file(s).
- **TARGET_BUILD_FORCE_SYSTEM_TO_PLAY_SMTH_WHILE_CALL**: Forces the Media Player to play a video(s) / song(s) during an call.
- **FORCE_ENABLE_POP_UP_PLAYER_ON_SVP**: Force enables Popup player on Samsung Video Player
- **TARGET_BUILD_FORCE_DISABLE_SETUP_WIZARD**: Disables Setup Wizard - for enterprise or trusted use case only, i'm not responsible for legal actions against you!
- **TARGET_FLOATING_FEATURE_INCLUDE_GAMELAUNCHER_IN_THE_HOMESCREEN**: Brings Game Launcher into the homescreen.
- **TARGET_FLOATING_FEATURE_BATTERY_SUPPORT_BSOH_SETTINGS**: The battery health level thing, like the one from iPhone. Thnx to UN1CA!
- **BRINGUP_CN_SMARTMANAGER_DEVICE**: Brings Chinese version of Smartmanager and Device Care, thnx @saadelasfur [Only works on OneUI 6.1, OneUI 6.1.1 & OneUI 7.*]

## Language & Locale
- **SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD**: Sets default language and region for the first boot, fill these variables to switch to your language **NEW_DEFAULT_LANGUAGE_ON_PRODUCT** **NEW_DEFAULT_LANGUAGE_COUNTRY_ON_PRODUCT**

## Miscellaneous 
- **DISABLE_SAMSUNG_ASKS_SIGNATURE_VERFICATION**: Disables Samsung's ASKS signature verifier, it doesn't have to do anything with the built-in signature verification, only used for samsung applications.
- **TARGET_ADD_ROUNDED_CORNERS_TO_THE_PIP_WINDOWS**: <a href="https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/rounded_corners_hux_ex.png">Adds rounded corners to the pip window, tap this text to see a example.</a>

## Advanced, enable or disable these with your own concern
- **TARGET_INCLUDE_HORIZON_OEMCRYPTO_DISABLER**: This feature removes a file which is necessary for drm / ott platforms, please do note that the widevine level will fallback to L3 which will disable HD playbacks. DRM-protected apps might work after appling this patch but im not sure.
- **TINKER_MAX_REFRESH_RATE**: Set this to true and fill the variables below to change your device's max refresh rate. Thanks @BrotherBoard
- **DTBO_IMAGE_PATH**: Put your dtbo image path there.
- **THIS_IS_MY_DEVICE_MAX_REFRESH_RATE**: Put the refresh rate you want to change to.

## Advanced
- **MY_KEYSTORE_ALIAS**: To be filled by the builder with their "Keystore Alias"
- **MY_KEYSTORE_PASSWORD**: To be filled by the builder with their "Keystore Alias Password"
- **MY_KEYSTORE_PATH**: To be filled by the builder with their "Keystore path"
- **TARGET_REMOVE_SMARTSWITCH_DAEMON**: Removes the smart switch listener port, be sure to remove it cuz' it's useless.
- **TARGET_BUILD_REMOVE_SYSTEM_LOGGING**: Removes unnecessary logging stuffs
- **TARGET_BUILD_ADD_NETWORK_SPEED_WIDGET**: Brings back network speed-o-meter in the systemUI qs 
- **TARGET_BUILD_BRING_NEWGEN_ASSISTANT**: For android <= 11, brings assistant 2.0
- **RECOVERY_IMAGE_PATH**: To be filled by the builder if they want to patch their device's recovery.
- **TARGET_INCLUDE_HORIZONUX_ELLEN**: Ellen, a script that spoofs and does some misc jobs when the device is booting. (kinda like a "tweaker" but it doesn't do anything to performance)

---

This script allows deep customization of your customized OneUI ROM, from performance tweaks to aesthetic changes. Make sure to enable only the features you need! Enjoy building your custom ROM! 😊

**Be sure to give the credits lah!**