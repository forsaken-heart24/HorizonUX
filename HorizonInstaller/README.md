![emergency_food](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food.png?raw=true)

# To compile:
```
cd HorizonUX/HorizonInstaller
gcc -I../include ../include/horizonutils.c ../include/horizonux.c ../include/HorizonInstaller.c ./main.c -o updater-script
```

## Variables to edit before compiling this source (misc/HorizonInstaller/main.c):
- **LOG4HORIZONFILE**: This is a string value, which can be used for logging purposes.
- **WRITE_DEBUG_MESSAGES_TO_CONSOLE**: This is a boolean and can be ignored if you don't want to debug the code.
- **whatisOTAType**: This string can be: "Incremental", "Reinstall". The name suggests it all.
- **INSTALLER_PATH**: WARNING! you might have to edit the whole header file if you change the path, because 1-2 stuffs are hardcoded.
- **maintainer**: your name, or the maintainer's name.
- **version**: Version of the rom, please ask me before changing this.
- **codename**: same as the version.
- **OUTFD**: WARNING! IF YOU CHANGE THIS, THE TEXTS WON'T DISPLAY
- **ZIPFILE**: Don't change this, this is the path string to the installation package.
- **partitionFlashables**: This is a string value, which is used to tell the program on what to flash.
- **partitionBlockPaths**: This is also a string value and it should be in a order from **partitionFlashables**
- **filesToExtractFromTheZip**: Again, string value and all it does is just extract necessary things
- **supportedDevicesList**: String again, for detecting your device model.

## Please do note that you shouldn't change any variables that are not mentioned here unless yk anything about it.