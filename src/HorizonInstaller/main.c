#include "horizonux.h"
#include "horizonutils.h"
#include "horizoninstaller.h"
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

char *LOG4HORIZONFILE = "/mnt/c/Users/Luna/Desktop/teto___horizonROMInstaller.log";
const char *thisPatchBuildID = "mylittledarkage";

// wanana BANG!
char *whatisOTAType = "Incremental"; // This string can be: "Incremental" or "Reinstall". The name suggests it all.
char *INSTALLER_PATH = "/dev/tmp/install"; // WARNING! you might have to edit some lines in header file if you change the path, because 1-2 stuffs are hardcoded.

// no need to explain bro
char *maintainer = "Luna";
char *version = "v1.0";
char *codename = "Birds";
char *ZIPFILE = NULL;

// stdio for recovery - WARNING! IF YOU CHANGE THIS, THE TEXTS WON'T DISPLAY
char OUTFD[256] = {0};

// low level partition flashing, ex boot, recovery xbl_config and etc
char *lowLevelPartitionFlashables[] = {"mizuki", "hideo"};
char *lowLevelPartitionBlockPaths[] = {"mizuki", "hideo"};
char *lowLevelPartitionFlashablesMD5SUM[] = {"64e282071257bec90215eccf413dfc8e", "64e7bbe8e51a6c2698c1e542e5c4b9e1"};

// high level partition flashing, ex system / super...
char *partitionFlashables[] = {"mizuki", "hideo"};
char *partitionBlockPaths[] = {"mizuki", "hideo"};
char *partitionFlashablesMD5SUM[] = {"64e282071257bec90215eccf413dfc8e", "64e7bbe8e51a6c2698c1e542e5c4b9e1"};

// device codename here, ex: ellen (first device) | joe (second device)
char supportedDevicesList[] = "beyond0 | beyond0lte";

// mountables, ig
char *rrrrrrrrrrrr[] = {"system", "vendor", "product", "prism"};

// generic partition mount paths
char *genericPartitionPaths[] = {"/system", "/system_root", "/vendor", "/product", "/prism"};

// rom (files) path identifier, don't change anything!
char *systemDir = "/system/system";
char *systemBuildProp = "/system/system/build.prop";
char *systemHostsFilePath = "/system/system/etc/hosts";

// anti-kang stuffs, enter your tar file password in this variable
const char *tarballPassword = "";

int main(int argc, const char *argv[]) {
    // for testing this bin
    if(strcmp((char *)argv[1], "--test") == 0) {
        printf("main(): HorizonInstaller works!\n");
        return 0;
    }
    // for closing terminal after testing stdin aka OUTFD
    throwMessagesToConsole(NULL, NULL, false);
    if(argc < 5) {
        abort__("- Not enough arguments provided!", " ");
    }
    // forgor to extract rom.prop from the archive.
    extractThisFileFromMe("rom.prop", false);
    ZIPFILE = strdup(argv[4]);
    snprintf(OUTFD, sizeof(OUTFD), "/proc/self/fd/%s", argv[3]);
    // mkdir syntax: mkdir("/some/directory", 0700);
    if(checkInternalStorageStatus) {
        mkdir("/sdcard/HorizonInstaller/logs", 0777);
        LOG4HORIZONFILE = "/sdcard/HorizonInstaller/logs/teto___horizonROMInstaller.log";
    }
    else {
        mkdir("/dev/tmp/HorizonInstaller/logs", 0777);
        LOG4HORIZONFILE = "/dev/tmp/HorizonInstaller/logs/teto___horizonROMInstaller.log";
    }
    if(isThisPartitionMounted("/system", true) || isThisPartitionMounted("/system_root", true)) {
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
    throwMessagesToConsole("This ROM Build ID  :", (char *)thisPatchBuildID, false);
    throwMessagesToConsole("###############################################", " ", false);
    backupHostsFileFromCurrentSystem("backup", systemHostsFilePath);
    throwMessagesToConsole("- Installing packages...", " ", false);
    throwMessagesToConsole("  please wait, it might take longer than usual..", " ", false);
    if(strcmp(whatisOTAType, "Incremental") == 0 && isHotFixAndShouldBeSkipped || strcmp((char *)thisPatchBuildID, getPreviousSystemBuildID(systemBuildProp)) == 0) {
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
                int index = i % ARRAY_SIZE(genericPartitionPaths);
                copyIncrementalFiles(genericPartitionPaths[index], rrrrrrrrrrrr[i]);
            }
        }        
    }
    else if(strcmp(whatisOTAType, "Reinstall") == 0 && isHotFixAndShouldBeSkipped || strcmp((char *)thisPatchBuildID, getPreviousSystemBuildID(systemBuildProp)) == 0) {
        for(int i = 0; i < ARRAY_SIZE(partitionFlashables); i++) {
            installGivenDiskImageFile(INSTALLER_PATH, partitionBlockPaths[i], partitionFlashables[i], partitionFlashablesMD5SUM[i]);
        }
    }
    else {
        throwMessagesToConsole("- Can't determine whether to flash the whole ROM or just patch necessary things, skipping installation.", " ", false);
        exit(0);
    }
    if(installationHasLowLevelDiskImages) {
        for(int i = 0; i < ARRAY_SIZE(lowLevelPartitionFlashables); i++) {
            installGivenDiskImageFile(INSTALLER_PATH, lowLevelPartitionBlockPaths[i], lowLevelPartitionFlashables[i], lowLevelPartitionFlashablesMD5SUM[i]);
        }
    }
    backupHostsFileFromCurrentSystem("restore", systemHostsFilePath);
    free(ZIPFILE);
    throwMessagesToConsole("- Successfully installed Horizon on your device, reboot to use the device now!", " ", true);
}