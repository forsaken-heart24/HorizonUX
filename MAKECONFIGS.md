![emergency_food_again](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food_again.png?raw=true)

# Build Configuration Variables

## TODO: To be filled by the builder
- Don't fill these if you have a super raw image file laying around your storage medium, just enter the path to it if the script
- Asks it.
**SYSTEM_DIR**: Put your extracted system folder path there.
**SYSTEM_EXT_DIR**: Put your extracted system_ext folder path there.
**VENDOR_DIR**: Put your extracted vendor folder path there.
**PRODUCT_DIR**: Put your extracted product folder path there.
**PRISM_DIR**: Put your extracted prism folder path there.

## Device Name & Setup
- **CUSTOM_SETUP_WELCOME_MESSAGE**: Customizes the device name in the "About" section without affecting the real brand. Requires `TARGET_INCLUDE_CUSTOM_SETUP_WELCOME_MESSAGES` set to true.
- **TARGET_INCLUDE_CUSTOM_SETUP_WELCOME_MESSAGES**: Enables custom welcome message during setup.

## Screen & Refresh Rate
- **BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE**: Sets the default refresh rate (recommend 60Hz).
- **BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES**: Set this to true if you want to change default refresh rate.

## Debugging & Performance
- **TARGET_BUILD_IS_FOR_DEBUGGING**: Enables verbose logging for debugging, which impacts performance.
- **TARGET_FLOATING_FEATURE_ENABLE_ENHANCED_PROCESSING**: Tries to boost performance at the cost of overheating and battery life.

## Security
- **TARGET_REMOVE_NONE_SECURITY_OPTION**: Disables the "none" option for lock screen security.
- **TARGET_REMOVE_SWIPE_SECURITY_OPTION**: Disables the swipe-to-unlock option.

## Bloatware & Features
- **TARGET_REMOVE_USELESS_VENDOR_STUFFS**: Removes bloat from the vendor partition.
- **TARGET_REMOVE_SAMSUNG_APPLICATIONS_STUFFS**: Removes unnecessary Samsung apps (note: Android 9 is not fully supported).
- **TARGET_ADD_EXTRA_ANIMATION_SCALES**: Adds extra animation scales for customization.
- **TARGET_FLOATING_FEATURE_DISABLE_BLUR_EFFECTS**: Disables blur effects for better performance and battery life.

## Special Features
- **TARGET_INCLUDE_FASTBOOTD_PATCH_BY_RATCODED**: Adds fastbootd support to stock recovery.
- **TARGET_INCLUDE_UNLIMITED_BACKUP**: Enables unlimited pictures backup in a specific app.
- **TARGET_INCLUDE_SAMSUNG_THEMING_MODULES**: Installs patched Samsung Goodlock modules.
- **TARGET_FLOATING_FEATURE_INCLUDE_SPOTIFY_AS_ALARM**: Includes Spotify into the Alarm tones
- **TARGET_FLOATING_FEATURE_INCLUDE_EASY_MODE**: Easy mode, for huge icons and things, specifically made for people(s) who has difficulty in reading
- **TARGET_FLOATING_FEATURE_INCLUDE_CLOCK_LIVE_ICON**: Disable this, useless thing ever made.

## Audio & Display
- **TARGET_INCLUDE_HORIZON_AUDIO_RESAMPLER**: Fixes LDAC audio distortion for lower-end Bluetooth audio devices.
- **DISABLE_DISPLAY_REFRESH_RATE_OVERRIDE**: Disables refresh rate override during media playback.
- **TARGET_FLOATING_FEATURE_SUPPORTS_DOLBY_IN_GAMES**: Toggles Dolby audio on games. (only if supported + if the hw is capable of doing this)
- **DISABLE_DYNAMIC_RANGE_COMPRESSION**: Dynamic range compression (DRC) is a process that reduces the difference between the loudest and quietest parts of an audio signal.

## Additional Customization
- **TARGET_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE**: Adjusts launcher animation for different performance tiers (LowEnd, HighEnd, etc.).
- **CUSTOM_WALLPAPER_RES_JSON_GENERATOR**: Adds multiple wallpapers with ease.
- **TARGET_FLOATING_FEATURE_SUPPORTS_WIRELESS_POWER_SHARING**: Enables wireless power sharing if supported by hardware.
- **BUILD_TARGET_ADD_MOBILE_DATA_TOGGLE_IN_POWER_MENU**: Brings mobile data toggle on the power menu context.
- **BUILD_TARGET_FORCE_FIVE_BAR_NETICON**: Force the network icon to show 5 bars
- **BUILD_TARGET_ADD_CALL_RECORDING_IN_SAMSUNG_DIALER**: Force enables Call Recording in the Samsung Dialer App | Please note that i'm not responsible for legal actions against you
- **BUILD_TARGET_FORCE_SYSTEM_TO_NOT_CLOSE_CAMERA_WHILE_CALLING**: Forces the system to not close the camera app while calling
- **BUILD_TARGET_FORCE_SYSTEM_TO_PLAY_MUSIC_WHILE_RECORDING**: Forces the system to play song(s) / music(s) while recording a video
- **BUILD_TARGET_DISABLE_WIFI_CALLING**: Disables wifi calling if it set to true, otherwise (true), it enables it if disabled.
- **BUILD_TARGET_SKIP_SETUP_JUNKS**: Skips setup junks.
- **BLOCK_NOTIFICATION_SOUNDS_DURING_PLAYBACK** Disables annoying sounds while consuming video(s) or audio(s) file(s).
- **BUILD_TARGET_FORCE_SYSTEM_TO_PLAY_SMTH_WHILE_CALL**: Forces the Media Player to play a video(s) / song(s) during an call.
- **FORCE_ENABLE_POP_UP_PLAYER_ON_SVP**: Force enables Popup player on Samsung Video Player
- **BUILD_TARGET_FORCE_DISABLE_SETUP_WIZARD**: Force enables Popup player on Samsung Video Player
- **BUILD_TARGET_FORCE_DISABLE_SETUP_WIZARD**: Disables Setup Wizard - for enterprise or trusted use case only, i'm not responsible for legal actions against you!

## Language & Locale
- **SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD**: Sets default language and region for the first boot, fill these variables to switch to your language **NEW_DEFAULT_LANGUAGE_ON_PRODUCT** **NEW_DEFAULT_LANGUAGE_COUNTRY_ON_PRODUCT**

## Miscellaneous 
- **DISABLE_SAMSUNG_ASKS_SIGNATURE_VERFICATION**: Disables Samsung's ASKS signature verifier, it doesn't have to do anything with the built-in signature verification, only used for samsung applications.
- **TARGET_REQUIRES_BLUETOOTH_LIBRARY_PATCHES**: Can be used to patch bluetooth libs for weird devices.
- **TARGET_ADD_ROUNDED_CORNERS_TO_THE_PIP_WINDOWS**: Adds rounded corners to the pip window.

## Advanced, enable or disable these with your own concern
- **TARGET_INCLUDE_HORIZON_OEMCRYPTO_DISABLER**: This feature removes a file which is necessary for drm / ott platforms, please do note that the widevine level will fallback to L3 which will disable HD playbacks. DRM-protected apps might work after appling this patch but im not sure.

## Advanced
- **MY_KEYSTORE_ALIAS**: To be filled by the builder with their "Keystore Alias"
- **MY_KEYSTORE_PASSWORD**: To be filled by the builder with their "Keystore Alias Password"
- **MY_KEYSTORE_PATH**: To be filled by the builder with their "Keystore path"
- **TARGET_REMOVE_SMARTSWITCH_DAEMON**: Removes the smart switch listener port.
- **BUILD_TARGET_REMOVE_SYSTEM_LOGGING**: Removes unnecessary logging stuffs
- **BUILD_TARGET_ADD_NETWORK_SPEED_WIDGET**: Brings back network speed-o-meter in the systemUI qs 
- **BUILD_TARGET_BRING_NEWGEN_ASSISTANT**: For android <= 11, brings assistant 2.0
- **BUILD_TARGET_DISABLE_KNOX_PROPERTIES**: For android <= 11, try this at own risk because it disables knox via properties which are untested.
- **BUILD_TARGET_BOOT_ANIMATION_FPS**: Add any integer value lesser than or equal to 60 if you have a bootanimation that has video/gif like transistions
- **BUILD_TARGET_SHUTDOWN_ANIMATION_FPS**: Same applies for this variable

## Fill these to prevent build errors.
- **PRODUCT_CSC_NAME**: The csc code of your product image, don't put random string there.

---

This script allows deep customization of your customized OneUI ROM, from performance tweaks to aesthetic changes. Make sure to enable only the features you need! Enjoy building your custom ROM! 😊

**Be sure to give the credits lah!**