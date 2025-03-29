//
// Copyright (C) 2025 Luna
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include <horizonux.h>
#include <horizonutils.h>
#include <horizoninstaller.h>
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))

// debugging shits ig
bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;

// don't change this please - managed by backupHostsFileFromCurrentSystem()
bool hostsAreBackedUp = false;

// skips the checks if it's a hotfix on the same build id. (false = checks the build id)
bool isHotFixAndShouldBeSkipped = false;

// Skips checking file checksum, please proceed with caution!
bool iDontWantChecksumChecks = false;

// Set to true if you want to install low level partitions.
bool installationHasLowLevelDiskImages = false;

// set it to true if you have password in your tar file.
// scroll down to put password in a variable.
bool tarballHasPasswordProtection = false;

//char *LOG4HORIZONFILE = "/mnt/c/Users/Luna/Desktop/teto___horizonROMInstaller.log";
char *LOG4HORIZONFILE = "/sdcard/Horizon/logs/teto___horizonROMInstaller.log";
char *thisPatchBuildID = "";

// wanana BANG!
char *whatisOTAType = "Incremental"; // This string can be: "Incremental" or "Reinstall". The name suggests it all.
char *INSTALLER_PATH = "/dev/tmp/install"; // WARNING! you might have to edit some lines in the source files if you change the path, because some stuffs are hardcoded.

// no need to explain bro
char *maintainer = "Luna";
char *version = "v1.0";
char *codename = "Birds";
char *ZIPFILE = NULL;

// stdio for recovery - WARNING! IF YOU CHANGE THIS, THE TEXTS WON'T DISPLAY
char OUTFD[256] = {0};

// low level partition flashing, ex boot, recovery xbl_config and etc
char *lowLevelPartitionFlashables[] = {"mizuki", "hideo"};
char *lowLevelPartitionBlockPaths[] = {"/dev/block/by-name/mizuki", "/dev/block/by-name/hideo"};
char *lowLevelPartitionFlashablesMD5SUM[] = {"64e282071257bec90215eccf413dfc8e", "64e7bbe8e51a6c2698c1e542e5c4b9e1"};

// high level partition flashing, ex system / super...
char *partitionFlashables[] = {"mizuki", "hideo"};
char *partitionBlockPaths[] = {"/dev/block/by-name/mizuki", "/dev/block/by-name/hideo"};
char *partitionFlashablesMD5SUM[] = {"64e282071257bec90215eccf413dfc8e", "64e7bbe8e51a6c2698c1e542e5c4b9e1"};

// device codename here, ex: ellen (first device) | joe (second device)
char supportedDevicesList[] = "beyond0 | beyond0lte";

// mountables, ig
char *rrrrrrrrrrrr[] = {"system", "vendor", "product"};

// generic partition mount paths
char *genericPartitionPaths[] = {"/system", "/system_root", "/vendor", "/product"};

// rom (files) path identifier, don't change anything!
char *systemDir = "/system/system";
char *systemBuildProp = "/system/system/build.prop";
char *systemHostsFilePath = "/system/system/etc/hosts";

// anti-kang stuffs, enter your tar file password in this variable
const char *tarballPassword = "";

// this variable can be: tarProtected (password protected tar), sparse and raw (which is the raw image factor)
const char *shippedAs = "";

// What it does is, it creates a snapshot of the current system before installing the ROM.
// and after the installation, the user can restore the snapshot if anything goes wrong by adding snapshot in 
// the installer file name.
bool createSnapshot = false;

int main(int argc, const char *argv[]) {
    // for testing this bin
    if(strcmp(argv[1], "--test") == 0) {
        printf("main(): HorizonInstaller works!\n");
        return 0;
    }
    if(argc < 5) {
        abort__("- Not enough arguments provided!", " ");
    }
    ZIPFILE = strdup(argv[4]);
    snprintf(OUTFD, sizeof(OUTFD), "/proc/self/fd/%s", argv[3]);
    // for closing terminal after testing stdin aka OUTFD
    throwMessagesToConsole(" ", " ", false);
    // extract ts from the archive:
    extractThisFileFromMe("manage-firmware.sh", true);
    // mkdir syntax: mkdir("/some/directory", 0700);
    if(checkInternalStorageStatus()) {
        mkdir("/sdcard/Horizon", 0777);
        mkdir("/sdcard/Horizon/logs", 0777);
        LOG4HORIZONFILE = "/sdcard/Horizon/logs/teto___horizonROMInstaller.log";
    }
    else {
        mkdir("/dev/tmp/", 0777);
        mkdir("/dev/tmp/Horizon", 0777);
        mkdir("/dev/tmp/Horizon/logs", 0777);
        mkdir("/dev/tmp/install/low-level-backups", 0777);
        LOG4HORIZONFILE = "/dev/tmp/Horizon/logs/teto___horizonROMInstaller.log";
    }
    bool systemMounted = isThisPartitionMounted("/system", true) || isThisPartitionMounted("/system_root", true);
    if(systemMounted) {
        FILE *systemBuildProperty = fopen("/system/system/build.prop", "r");
        if(!systemBuildProperty) {
            systemBuildProperty = fopen("/system_root/system/build.prop", "r");
            if(!systemBuildProperty) {
                abort__("- Failed to remount /system partition..", " ");
            }
            systemDir = "/system_root/system";
            systemBuildProp = "/system_root/system/build.prop";
            systemHostsFilePath = "/system_root/system/etc/hosts";
        }
        fclose(systemBuildProperty);
        FILE *linuxHostsFileFromEtc = fopen("/system_root/system/etc/hosts", "r");
        if(!linuxHostsFileFromEtc) {
            throwMessagesToConsole("- Attempting to open hosts again...", " ", false);
            linuxHostsFileFromEtc = fopen("/system/system/etc/hosts", "r");
            if(!linuxHostsFileFromEtc) {
                abort__("- Failed to open hosts file, please try again", " ");
            }
        }
    }
    throwMessagesToConsole("#########################################################", " ", false);
    throwMessagesToConsole("   _  _     _   _            _                _   ___  __", " ", false);
    throwMessagesToConsole(" _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \\/ /", " ", false);
    throwMessagesToConsole("|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / ", " ", false);
    throwMessagesToConsole("|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ ", " ", false);
    throwMessagesToConsole("  |_||_|   |_| |_|\\___/|_|  |_/___\\___/|_| |_|\\___//_/\\_\\", " ", false);
    throwMessagesToConsole("                                                         ", " ", false);
    throwMessagesToConsole("#########################################################", " ", false);
    // check device codename and proceed
    if(strstr(getSystemProperty(systemBuildProp, "ro.product.model"), supportedDevicesList) != 0) {
        consoleLog("This aint", supportedDevicesList);
        abort__("- This device's codename doesn't match up with the one from the installer allowlist, please install this rom in the appropriate device!", " ");
    }
    throwMessagesToConsole("Developer :", maintainer, false);
    throwMessagesToConsole("Version   :", version, false);
    throwMessagesToConsole("Codename  :", codename, false);
    throwMessagesToConsole("Present ROM Build ID  :", getPreviousSystemBuildID(systemBuildProp), false);
    throwMessagesToConsole("This ROM Build ID  :", thisPatchBuildID, false);
    throwMessagesToConsole("###############################################", " ", false);
    if(verifyInstallationType("restore-snap", ZIPFILE) == true) {
        throwMessagesToConsole("Restoring snapshots from the backup....", " ", true);
        executeScripts("/dev/tmp/install/manage-firmware.sh", "--snapshot_restore", false);
    }
    if(createSnapshot == true) {
        throwMessagesToConsole("Taking a snapshot of the current system partitions...", " ", true);
        for(int i = 0; i < ARRAY_SIZE(partitionFlashables); i++) {
            markInstallTypeAndBlock(partitionFlashables, partitionBlockPaths);
            executeScripts("/dev/tmp/install/manage-firmware.sh", "--snapshot", false);
        }
        if(installationHasLowLevelDiskImages == true) {
            for(int i = 0; i < ARRAY_SIZE(lowLevelPartitionFlashables); i++) {
                markInstallTypeAndBlock(lowLevelPartitionFlashables, (char *)lowLevelPartitionBlockPaths);
                executeScripts("/dev/tmp/install/manage-firmware.sh", "--snapshot", false);
            }
        }
    }
    backupHostsFileFromCurrentSystem("backup", systemHostsFilePath);
    throwMessagesToConsole("- Installing packages...", " ", false);
    throwMessagesToConsole("  please wait, it might take longer than usual..", " ", false);
    if((strcmp(whatisOTAType, "Incremental") == 0 && isHotFixAndShouldBeSkipped) || (strcmp(thisPatchBuildID, getPreviousSystemBuildID(systemBuildProp)) == 0)) {
        for(int i = 0; i < ARRAY_SIZE(genericPartitionPaths); i++) {
            isThisPartitionMounted(genericPartitionPaths[i], true);
        }
        for(int i = 0; i < ARRAY_SIZE(rrrrrrrrrrrr); i++) {
            extractThisFileFromMe(rrrrrrrrrrrr[i], true);
            if(i == 0) {
                copyIncrementalFiles(systemDir, rrrrrrrrrrrr[i]);
            }
            else if(i == 1) {
                copyIncrementalFiles("/vendor", rrrrrrrrrrrr[i]);
            }
            else {
                int index = (i < ARRAY_SIZE(genericPartitionPaths)) ? i : (i % ARRAY_SIZE(genericPartitionPaths));
                copyIncrementalFiles(genericPartitionPaths[index], rrrrrrrrrrrr[i]);
            }
        }
    }
    else if(strcmp(whatisOTAType, "Reinstall") == 0 && isHotFixAndShouldBeSkipped || strcmp(thisPatchBuildID, getPreviousSystemBuildID(systemBuildProp)) == 0) {
        for(int i = 0; i < ARRAY_SIZE(partitionFlashables); i++) {
            installGivenDiskImageFile(INSTALLER_PATH, partitionBlockPaths[i], partitionFlashables[i], partitionFlashablesMD5SUM[i]);
        }
    }
    else {
        throwMessagesToConsole("- Can't determine whether to flash the whole ROM or just patch necessary things, skipping installation...", " ", false);
        exit(0);
    }
    if(installationHasLowLevelDiskImages) {
        for(int i = 0; i < ARRAY_SIZE(lowLevelPartitionFlashables); i++) {
            installLowLevelImages(INSTALLER_PATH, lowLevelPartitionBlockPaths[i], lowLevelPartitionFlashables[i], lowLevelPartitionFlashablesMD5SUM[i]);
        }
    }
    backupHostsFileFromCurrentSystem("restore", systemHostsFilePath);
    if(ZIPFILE) {
        free(ZIPFILE);
        ZIPFILE = NULL;
    }    
    throwMessagesToConsole("- Successfully installed Horizon on your device, reboot to use the device now!", " ", true);
}