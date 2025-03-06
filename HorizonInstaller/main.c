#include "horizonux.h"
#include "horizonutils.h"
#include "horizoninstaller.h"
#define FILES_TO_EXTRACT_COUNT  (sizeof(filesToExtractFromTheZip) / sizeof(filesToExtractFromTheZip[0]))
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
bool hostsAreBackedUp = false;
bool isHotFixAndShouldBeSkipped = false;
//const char *LOG4HORIZONFILE = "/mnt/c/Users/Luna/Desktop/teto___horizonROMInstaller.log";
const char *LOG4HORIZONFILE = "/sdcard/teto___horizonROMInstaller.log";
const char *thisPatchBuildID = "mylittledarkage";
char *whatisOTAType = "Incremental";
char *INSTALLER_PATH = "/dev/tmp/install";
char *maintainer = "Luna";
char *version = "v1.0";
char *codename = "Birds";
char *ZIPFILE = NULL;
char OUTFD[256] = {0};
char *partitionFlashables[] = {"becon", "nata"};
char *partitionBlockPaths[] = {"becon", "nata"};
char *filesToExtractFromTheZip[] = {"becon", "nata"};
char *supportedDevicesList[] = {"becon", "nata"};

int main(int argc, const char *argv[]) {
    if(argc < 5) {
        abort__("- Not enough arguments provided!", " ");
    }
    ZIPFILE = strdup(argv[4]);
    // forgor to extract the rom properties file
    extractThisFileFromMe("rom.prop", false);
    char *systemDir = "/system/system";
    char *systemBuildProp = "/system/system/build.prop";
    char *systemHostsFilePath = "/system/system/etc/hosts";
    snprintf(OUTFD, sizeof(OUTFD), "/proc/self/fd/%s", argv[3]);
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
        backupHostsFileFromCurrentSystem("backup", systemHostsFilePath);
    }
    throwMessagesToConsole("#########################################################", " ", false);
    throwMessagesToConsole("   _  _     _   _            _                _   ___  __", " ", false);
    throwMessagesToConsole(" _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \\/ /", " ", false);
    throwMessagesToConsole("|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / ", " ", false);
    throwMessagesToConsole("|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ ", " ", false);
    throwMessagesToConsole("  |_||_|   |_| |_|\\___/|_|  |_/___\\___/|_| |_|\\___//_/\\_\\", " ", false);
    throwMessagesToConsole("                                                         ", " ", false);
    throwMessagesToConsole("#########################################################", " ", false);
    throwMessagesToConsole("Developer :", maintainer, false);
    throwMessagesToConsole("Version   :", version, false);
    throwMessagesToConsole("Codename  :", codename, false);
    throwMessagesToConsole("Present ROM Build ID  :", getPreviousSystemBuildID(systemBuildProp), false);
    throwMessagesToConsole("This ROM Build ID  :", (char *)thisPatchBuildID, false);
    throwMessagesToConsole("###############################################", " ", false);
    throwMessagesToConsole(" - Installing packages...", " ", false);
    for(int i = 0; i < FILES_TO_EXTRACT_COUNT; i++) {
        extractThisFileFromMe(filesToExtractFromTheZip[i], false);
    }
    if(verifyInstallationType("Incremental", ZIPFILE) && strcmp(whatisOTAType, "Incremental") == 0 && isHotFixAndShouldBeSkipped || \
    strcmp((char *)thisPatchBuildID, getPreviousSystemBuildID(systemBuildProp)) == 0) {
        char *rrrrrrrrrrrr[] = {"system", "vendor", "product", "prism"};
        char *genericPartitionPaths[] = {"/system", "/system_root", "/vendor", "/product", "/prism"};
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
            else if(i < ARRAY_SIZE(genericPartitionPaths)) {
                copyIncrementalFiles(genericPartitionPaths[i], rrrrrrrrrrrr[i]);
            }
        }
    }
    else if(verifyInstallationType("Reinstall", ZIPFILE) && strcmp(whatisOTAType, "Reinstall") == 0 && isHotFixAndShouldBeSkipped || \
    strcmp((char *)thisPatchBuildID, getPreviousSystemBuildID(systemBuildProp)) == 0) {
        for(int i = 0; i < ARRAY_SIZE(partitionFlashables); i++) {
            installGivenDiskImageFile(INSTALLER_PATH, partitionBlockPaths[i], partitionFlashables[i]);
        }
    } 
    else {
        throwMessagesToConsole("- Can't determine whether to flash the whole ROM or just patch necessary things, skipping installation.", " ", false);
        exit(0);
    }
    backupHostsFileFromCurrentSystem("restore", systemHostsFilePath);
    free(ZIPFILE);
}