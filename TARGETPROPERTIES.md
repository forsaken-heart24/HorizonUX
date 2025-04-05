![emergency_food_again](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food_again.png?raw=true)

# Device Specific Configuration Variables

- **BUILD_TARGET_INCLUDE_FASTBOOTD_PATCH_BY_RATCODED**: Adds fastbootd support to stock recovery.
- **BUILD_TARGET_SUPPORTS_WIRELESS_POWER_SHARING**: Enables wireless power sharing if supported by hardware.
- **BUILD_TARGET_DISABLE_KNOX_PROPERTIES**: For android <= 11, try this at own risk because it disables knox via properties which are untested.
- **BUILD_TARGET_FLOATING_FEATURE_PATH**: Put the exact Floating features dir for modifying the xml.
- **BUILD_TARGET_BOOT_ANIMATION_FPS**: Add any integer value lesser than or equal to 60 if you have a bootanimation that has video/gif like transistions
- **BUILD_TARGET_SHUTDOWN_ANIMATION_FPS**: Same applies to this variable
- **BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE**: Sets the default refresh rate (60Hz is recommended).
- **BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES**: Set this to true if you want to change default refresh rate.
- **BUILD_TARGET_USES_DYNAMIC_PARTITIONS**: Set this to true if you have a device with Dynamic Partition Scheme
- **BUILD_TARGET_REQUIRES_BLUETOOTH_LIBRARY_PATCHES**: Can be used to patch bluetooth libs for weird devices.

# Specifically for Galaxy A30:
- **BUILD_TARGET_ADD_PATCHED_C2API_LIBRARY_FILE**: Brings camera2api via a patched lib.
- **BUILD_TARGET_ADD_FRAMEWORK_OVERLAY_TO_FIX_CUTOUT**: Builds and adds the vendor overlay to fix the device cutout.
- **BUILD_TARGET_ADD_EXTRA_CAMERA_MODE**: Adds extra camera mode if not available.