![emergency_food](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food.jpeg?raw=true)

# To compile:
```
gcc -I../include ../include/HorizonInstaller.c ../include/horizonux.c ../include/horizonutils.c main.c -o updater-script
```

## Variables to edit before compiling this source (HorizonInstaller/main.c):
- **LOG4HORIZONFILE**: This is a string value, which can be used for logging purposes in the feature but please fill it up with something.
- **WRITE_DEBUG_MESSAGES_TO_CONSOLE**: This is a boolean and can be ignored.
- **whatisOTAType**: This string can be: "Incremental", "Reinstall". The name suggests it all.
- **INSTALLER_PATH**: WARNING! you might have to edit the whole header file if you change the path, because somethings are hardcoded.
- **maintainer**: your name, or the maintainer's name.
- **version**: Version of the rom, please ask me before changing this.
- **codename**: same as the version.
- **OUTFD**: WARNING! IF YOU CHANGE THIS, THE TEXTS WON'T FUCKING PRINT.
- **ZIPFILE**: Don't change this, this is the path string of the installation package.

## Please do note that you shouldn't change any variables that are not mentioned here unless yk anything about it.