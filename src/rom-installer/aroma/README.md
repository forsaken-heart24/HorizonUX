# aromaInstallerScriptsGenerator:
- Generates a updater-script and aroma-config according to the nya-aroma-config.h from src/include

## To compile (Android NDK should be present):
- Change these following variables according to the toolchain path: ANDROID_NDK_CLANG_PATH
- Don't forget to change it, else the program won't get compiled or will have any random issues.
- Please edit src/include/nya-aroma-config.h before generating one.
```bash
cd HorizonUX
make ANDROID_SDK_VERSION=<sdk version here> aromaInstaller
```