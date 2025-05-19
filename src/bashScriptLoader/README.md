![emergency_food](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food.png?raw=true)

# To compile (Android NDK should be present):
- Change these following variables according to the toolchain path: ANDROID_NDK_CLANG_PATH
- Don't forget to change it, else the program won't get compiled or will have any random issues.
```bash
cd HorizonUX
make ANDROID_SDK_VERSION=<sdk version here> loader
```

## What Does This Do?
- This binary acts as a shell script loader.
- Since we can’t directly run shell scripts, I made this as a workaround! >3