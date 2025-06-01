![Emergency Food Again](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food_again.png?raw=true)

# AROMA Installer for Horizon

The following files and directories were created by me and should not be used without my permission:

- `scripts/*`
- `META-INF/com/google/android/aroma/a1.png`

Special thanks to [Amarullz](https://github.com/amarullz/) for their [AROMA Installer Project](https://github.com/amarullz/AROMA-Installer/).

## Directory Structure
```
├── aroma/META-INF/
│   └── com/
│       └── google/
│           └── android/
│               ├── aroma-config
│               ├── update-binary
│               ├── update-binary-installer
│               ├── updater-script
│               └── aroma/
│                   ├── a1.png
│                   ├── changelogs.txt
│                   ├── tc.txt
│                   ├── exec_demo/
│                   │   ├── displaycapture
│                   │   ├── exec_demo1.sh
│                   │   ├── exec_demo2.sh
│                   │   └── sleep
│                   ├── langs/
│                   │   └── en.lang
│                   ├── ttf/
│                   │   └── GoogleSansRegular.ttf
│                   └── themes/
│                       └── ics/
│                           ├── bg.png
│                           ├── button.9.png
│                           ├── button_focus.9.png
│                           ├── button_press.9.png
│                           ├── cb.png
│                           ├── cb_focus.png
│                           ├── cb_on.png
│                           ├── cb_on_focus.png
│                           ├── cb_on_press.png
│                           ├── cb_press.png
│                           ├── dialog.9.png
│                           ├── dialog_titlebar.9.png
│                           ├── font.roboto.big.png
│                           ├── font.roboto.small.png
│                           ├── icon.agreement.png
│                           ├── icon.alert.png
│                           ├── icon.apps.png
│                           ├── icon.back.png
│                           ├── icon.confirm.png
│                           ├── icon.customize.png
│                           ├── icon.default.png
│                           ├── icon.info.png
│                           ├── icon.install.png
│                           ├── icon.license.png
│                           ├── icon.menu.png
│                           ├── icon.next.png
│                           ├── icon.personalize.png
│                           ├── icon.update.png
│                           ├── icon.welcome.png
│                           ├── list.9.png
│                           ├── navbar.9.png
│                           ├── radio.png
│                           ├── radio_focus.png
│                           ├── radio_on.png
│                           ├── radio_on_focus.png
│                           ├── radio_on_press.png
│                           ├── radio_press.png
│                           ├── theme.prop
│                           └── titlebar.9.png
├
```

# aromaInstallerScriptsGenerator:
- Generates a updater-script and aroma-config according to the nya-aroma-config.h from src/include
```
Usage: aromaConfig [OPTION]
Options:\n"
        --installer: Generates a installer.sh in the current working directory.
        --aroma: Generates a aroma-config in the current working directory.
```

## To compile (Android NDK should be present):
- Change these following variables according to the toolchain path: ANDROID_NDK_CLANG_PATH
- Don't forget to change it, else the program won't get compiled or will have any random issues.
- Please edit src/include/nya-aroma-config.h before generating one.
```bash
cd HorizonUX
make ANDROID_SDK_VERSION=<sdk version here> aromaInstaller
```

## To maintainers:
- Use src/rom-installer/aroma/ if you are going to ship a full package (with system images and etc)
- Use src/rom-installer/incremental/ if you are going to ship a package that contains stuff like hotfixes and etc.