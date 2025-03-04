#include "horizonux.h"
#include "horizonutils.h"
#include "HorizonInstaller.h"

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
bool hostsAreBackedUp = false;
const char *whatisOTAType = "Incremental";
const char *LOG4HORIZONFILE = "/sdcard/HorizonInstaller.log";
const char *INSTALLER_PATH = "/dev/tmp/install";
char *maintainer = "Luna";
char *version = "v1.0";
char *codename = "Birds";
char *ZIPFILE = NULL;
char OUTFD[256];

int main(int argc, const char *argv[]) {
    char *systemDir = "/system/system";
    char *systemBuildProp = "/system/system/build.prop";
    char *systemHostsFilePath = "/system/system/etc/hosts";
    ZIPFILE = (char *)argv[4];
    snprintf(OUTFD, sizeof(OUTFD), "/proc/self/fd/%s", argv[3]);
    if(isThisPartitionMounted("/system", true) || isThisPartitionMounted("/system_root", true)) {
        FILE *systemBuildProperty;
        systemBuildProperty = fopen("/system/system/build.prop", "r");
        if(!systemBuildProperty) {
            systemBuildProperty = fopen("/system_root/system/build.prop", "r");
            if(!systemBuildProperty) {
                abort__("- Failed to remount /system partition..", " ");
            }
            char *systemDir = "/system_root/system";
            char *systemBuildProp = "/system_root/system/build.prop";
        }
        fclose(systemBuildProperty);
        FILE *linuxHostsFileFromEtc;
        linuxHostsFileFromEtc = fopen("/system_root/system/etc/hosts", "r");
        char *systemHostsFilePath = "/system_root/system/etc/hosts";
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
    throwMessagesToConsole("   Please wait, it might take longer than usual...", " ");
    for(int i = 0; i < sizeof(filesToExtractFromTheZip) / sizeof(filesToExtractFromTheZip[0]); i++) {
        extractThisFileFromMe(filesToExtractFromTheZip[i], false);
    }

    // later bro 💔
    if(strcmp(whatisOTAType, "Incremental") == 0) {
        //verifyHorizonSystemIntegrity();
        char *rrrrrrrrrrrr[] = {"system", "vendor", "product", "prism"};
        char *genericPartitionPaths[] = {"/system", "/system_root", "/vendor", "/product", "/prism"};
        for(int i = 0; i < sizeof(genericPartitionPaths) / sizeof(genericPartitionPaths[0]); i++) {
            isThisPartitionMounted(genericPartitionPaths[i], true);
        }
        for(int i = 0; i < sizeof(rrrrrrrrrrrr) / sizeof(rrrrrrrrrrrr); i++) {
            extractThisFileFromMe(rrrrrrrrrrrr[i], true);
            extractThisFileFromMe(rrrrrrrrrrrr[i], true);
            if(i = 0) {
                copyIncrementalFiles(systemDir, rrrrrrrrrrrr[i]);
            }
            else if(i = 1) {
                copyIncrementalFiles("/vendor", rrrrrrrrrrrr[i]);
            }
            else {
                copyIncrementalFiles(genericPartitionPaths[i], rrrrrrrrrrrr[i]);
            }
        }
    }
    else if(strcmp(whatisOTAType, "Reinstall") == 0) {
        //verifyHorizonSystemIntegrity();
        for(int i = 0; i < sizeof(partitionFlashables) / sizeof(partitionFlashables[0]); i++) {
            installGivenDiskImageFile(INSTALLER_PATH, partitionBlockPaths[i], partitionFlashables[i]);
        }
    }
    else {
        throwMessagesToConsole("- Can't determine whether to flash the whole rom or just patch the necessary things, skipping the installation..", " ");
        exit(0);
    }
    // let's restore the hosts file
    backupHostsFileFromCurrentSystem("restore", systemHostsFilePath);
}