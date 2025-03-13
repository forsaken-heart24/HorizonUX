![emergency_food](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food.png?raw=true)

# To compile (works on every arch but compiles for arm64):
```
cd HorizonUX/src
make updater
```

## Variables to edit before compiling this source (misc/HorizonInstaller/main.c):
- **LOG4HORIZONFILE**: Used for logging purposes.
- **WRITE_DEBUG_MESSAGES_TO_CONSOLE**: Should be ignored if you don't want to debug the code.
- **whatisOTAType**: This string can be: "Incremental" or "Reinstall". The name suggests it all.
- **INSTALLER_PATH**: WARNING! you might have to edit some lines in header file if you change the path, because 1-2 stuffs are hardcoded.
- **maintainer**: Your name, or to be specific, The Maintainer's name.
- **version**: Version of the rom, please ask me before changing this.
- **codename**: Ask me (luna) before changing this please
- **OUTFD**: WARNING! IF YOU CHANGE THIS, THE TEXTS WON'T DISPLAY
- **ZIPFILE**: Don't change this, this is the path string to the installation package.
- **partitionFlashables**: Used to tell the program what to flash.
- **partitionBlockPaths**: Should be in a order from **partitionFlashables**
- **supportedDevicesList**: For detecting your device model. Syntax example can be seen in the main.c
- **thisPatchBuildID**: Used for determing the new build id.
- **isHotFixAndShouldBeSkipped**: boolean value, skips the checks if it's a hotfix on the same build id. (false = checks the build id)
- **partitionFlashablesMD5SUM**: The hashes should be in a order from **partitionFlashables**, otherwise the installer will stop the installation
- **iDontWantChecksumChecks**: Skips checking file checksum, please proceed with caution!
- **installationHasLowLevelDiskImages**: Set to true if you want to install low level partitions.
- **lowLevelPartitionFlashables**: Just like **partitionFlashables**
- **lowLevelPartitionBlockPaths**: Should be in a order from **lowLevelPartitionFlashables**
- **lowLevelPartitionFlashablesMD5SUM**: The hashes should be in a order from **lowLevelPartitionFlashables**, otherwise the installer will stop the installation
- **tarballHasPasswordProtection**: Set this to true if you want to protect your ROM from kanging
- **tarballPassword**: Tar file password, the installation will be suspended if the password is not shipped or it's wrong.
- **shippedAs**: This variable can be: tarProtected (password protected tar), tar, sparse, and raw (which is the raw image factor)

## Please do note that you shouldn't change any variables that are not mentioned here unless yk anything about it.