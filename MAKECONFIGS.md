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
- **BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES**: Toggles high refresh rate modes based on the default rate.

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
- **TARGET_INCLUDE_UNLIMITED_BACKUP**: Enables unlimited pictures backup to a specific app.
- **TARGET_INCLUDE_SAMSUNG_THEMING_MODULES**: Installs patched Samsung Goodlock modules.

## Audio & Display
- **TARGET_INCLUDE_HORIZON_AUDIO_RESAMPLER**: Fixes LDAC audio distortion for lower-end Bluetooth audio devices.
- **DISABLE_DISPLAY_REFRESH_RATE_OVERRIDE**: Disables refresh rate override during media playback.
- **TARGET_FLOATING_FEATURE_SUPPORTS_DOLBY_IN_GAMES**: Toggles Dolby audio on games. (only if supported + if the hw is capable of doing this)

## Additional Customization
- **TARGET_FLOATING_FEATURE_LAUNCHER_CONFIG_ANIMATION_TYPE**: Adjusts launcher animation for different performance tiers (LowEnd, HighEnd, etc.).
- **CUSTOM_WALLPAPER_RES_JSON_GENERATOR**: Adds multiple wallpapers with ease.
- **TARGET_FLOATING_FEATURE_SUPPORTS_WIRELESS_POWER_SHARING**: Enables wireless power sharing if supported by hardware.

## Language & Locale
- **SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD**: Sets default language and region for the first boot, fill these variables to switch to your language **NEW_DEFAULT_LANGUAGE_ON_PRODUCT** **NEW_DEFAULT_LANGUAGE_COUNTRY_ON_PRODUCT**

## Miscellaneous 
- **DISABLE_SAMSUNG_ASKS_SIGNATURE_VERFICATION**: Disables Samsung's ASKS signature verifier, it doesn't have to do anything with the built-in signature verification, only used for samsung applications.

## Advanced
- **MY_KEYSTORE_ALIAS**: To be filled by the builder with their "Keystore Alias"
- **MY_KEYSTORE_PASSWORD**: To be filled by the builder with their "Keystore Alias Password"
- **MY_KEYSTORE_PATH**: To be filled by the builder with their "Keystore path"
- **TARGET_REMOVE_SMARTSWITCH_DAEMON**: removes the smart switch listener port.
---

This script allows deep customization of your customized OneUI ROM, from performance tweaks to aesthetic changes. Make sure to enable only the features you need! Enjoy building your custom ROM! 😊

**Be sure to give the credits lah!**