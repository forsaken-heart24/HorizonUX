![emergency_food_again](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food_again.png?raw=true)

# Device Specific Configuration Variables

- **BUILD_TARGET_INCLUDE_FASTBOOTD_PATCH**: Adds fastbootd support to stock recovery. Ensure the "RECOVERY_IMAGE_PATH" variable in `makeconfigs.prop` is set to the correct image path.
- **BUILD_TARGET_SUPPORTS_WIRELESS_POWER_SHARING**: Enables wireless power sharing if supported by the hardware.
- **BUILD_TARGET_DISABLE_KNOX_PROPERTIES**: For Android <= 11, use at your own risk as it disables Knox via untested properties.
- **BUILD_TARGET_BOOT_ANIMATION_FPS**: Specify an integer value ≤ 60 for bootanimations with video/GIF-like transitions.
- **BUILD_TARGET_SHUTDOWN_ANIMATION_FPS**: Same as above, but for shutdown animations.
- **BUILD_TARGET_DEFAULT_SCREEN_REFRESH_RATE**: Sets the default refresh rate (60Hz recommended).
- **BUILD_TARGET_HAS_HIGH_REFRESH_RATE_MODES**: Set to `true` to enable changing the default refresh rate.
- **BUILD_TARGET_USES_DYNAMIC_PARTITIONS**: Set to `true` for devices with a Dynamic Partition Scheme.
- **BUILD_TARGET_REQUIRES_BLUETOOTH_LIBRARY_PATCHES**: Use to patch Bluetooth libraries for certain devices.

## Specifically for Galaxy A30:

- **BUILD_TARGET_ADD_PATCHED_C2API_LIBRARY_FILE**: Enables Camera2 API via a patched library. Thanks to @TBM13.
- **BUILD_TARGET_ADD_FRAMEWORK_OVERLAY_TO_FIX_CUTOUT**: Builds and adds a vendor overlay to fix the device cutout.
- **BUILD_TARGET_ADD_EXTRA_CAMERA_MODE**: Adds an extra camera mode if unavailable. Avoid using this on newer or ported ROMs.

### For Supported Devices:

- **BUILD_TARGET_REPLACE_REQUIRED_PROPERTIES**: Replaces specific required properties, useful in certain scenarios.

### Vulkan Version Support

The table below lists Vulkan versions supported for enabling Vulkan-based UI rendering on Android devices. Note that Vulkan 1.1 and 1.1.1 are not optimal for UI tasks.

| Vulkan Version     | Hex Value    |
| ------------------ | ------------ |
| **Vulkan 1.1**     | `0x00401000` |
| **Vulkan 1.1.1**   | `0x00401001` |
| **Vulkan 1.2**     | `0x00402000` |
| **Vulkan 1.2.0**   | `0x00402000` |
| **Vulkan 1.2.162** | `0x004020A2` |
| **Vulkan 1.3**     | `0x00403000` |
| **Vulkan 1.3.0**   | `0x00403000` |

#### Advanced:

- **BUILD_TARGET_ENABLE_VULKAN_UI_RENDERING**: Enables Vulkan-based SystemUI rendering if conditions are met and this variable is enabled (set this to `true` to enable).
- **BUILD_TARGET_GPU_VULKAN_VERSION**: Replace this with your device's Vulkan version to enable Vulkan UI rendering. Remember, this is experimental and may have both positive and negative effects. Ensure `BUILD_TARGET_ENABLE_VULKAN_UI_RENDERING` is set to `true` beforehand.