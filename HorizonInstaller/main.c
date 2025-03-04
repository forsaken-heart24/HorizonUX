#include "horizonux.h"
#include "horizonutils.h"
#include "horizoninstaller.h"
#define FILES_TO_EXTRACT_COUNT  (sizeof(filesToExtractFromTheZip) / sizeof(filesToExtractFromTheZip[0]))
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
bool hostsAreBackedUp = false;
const char *LOG4HORIZONFILE = "/sdcard/Installer__teto.log";
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
            throwMessagesToConsole("- Attempting to open hosts again...", " ");
            linuxHostsFileFromEtc = fopen("/system/system/etc/hosts", "r");
            if(!linuxHostsFileFromEtc) {
                abort__("- Failed to open hosts file, please try again", " ");
            }
        }
        backupHostsFileFromCurrentSystem("backup", systemHostsFilePath);
    }
    throwMessagesToConsole("#########################################################", " ");
    throwMessagesToConsole("   _  _     _   _            _                _   ___  __", " ");
    throwMessagesToConsole(" _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \\/ /", " ");
    throwMessagesToConsole("|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  / ", " ");
    throwMessagesToConsole("|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\ ", " ");
    throwMessagesToConsole("  |_||_|   |_| |_|\\___/|_|  |_/___\\___/|_| |_|\\___//_/\\_\\", " ");
    throwMessagesToConsole("                                                         ", " ");
    throwMessagesToConsole("#########################################################", " ");
    throwMessagesToConsole("Developer :", maintainer);
    throwMessagesToConsole("Version   :", version);
    throwMessagesToConsole("Codename  :", codename);
    throwMessagesToConsole("Present ROM Build ID  :", getPreviousSystemBuildID(systemBuildProp));
    throwMessagesToConsole("This ROM Build ID  :", getPreviousSystemBuildID(systemBuildProp));
    throwMessagesToConsole("###############################################", " ");
    throwMessagesToConsole(" - Installing packages...", " ");
    for(int i = 0; i < FILES_TO_EXTRACT_COUNT; i++) {
        extractThisFileFromMe(filesToExtractFromTheZip[i], false);
    }
    if(strcmp(whatisOTAType, "Incremental") == 0) {
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
    else if(strcmp(whatisOTAType, "Reinstall") == 0) {
        for(int i = 0; i < ARRAY_SIZE(partitionFlashables); i++) {
            installGivenDiskImageFile(INSTALLER_PATH, partitionBlockPaths[i], partitionFlashables[i]);
        }
    } 
    else {
        throwMessagesToConsole("- Can't determine whether to flash the whole ROM or just patch necessary things, skipping installation.", " ");
        exit(0);
    }
    backupHostsFileFromCurrentSystem("restore", systemHostsFilePath);
}