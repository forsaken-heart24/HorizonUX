#include "horizonux.h"
#include "horizonutils.h"
#include "HorizonInstaller.h"

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
bool hostsAreBackedUp = false;
const char *whatisOTAType = "Incremental";
const char *LOG4HORIZONFILE = "/sdcard/modulesLoader.log";
const char *INSTALLER_PATH = "/dev/tmp/install";
const char *maintainer = "Luna";
const char *version = "v1.0";
const char *codename = "Birds";
char *OUTFD = NULL;
char *ZIPFILE = NULL;

int main(int argc, const char *argv[]) {
    ZIPFILE = argv[4];
    snprintf(OUTFD, sizeof(OUTFD), "/proc/self/fd/%s", argv[3]);
    if(isThisPartitionMounted("/system", true) || isThisPartitionMounted("/system_root", true)) {
        FILE *systemBuildProperty;
        systemBuildProperty = fopen("/system/system/build.prop", "r");
        char *systemDir = "/system/system";
        char *systemBuildProp = "/system/system/build.prop";
        if(!systemBuildProperty) {
            systemBuildProperty = fopen("/system_root/system/build.prop", "r");
            if(!systemBuildProperty) {
                abort("- Failed to remount /system partition..", " ");
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
                abort("- Failed to open hosts file, please try again", " ");
            }
            char *systemHostsFilePath = "/system/system/etc/hosts";
        }
        cp(systemHostsFilePath, "/dev/tmp/install/bkp_hosts");
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
    throwMessagesToConsole("###############################################", " ");
    throwMessagesToConsole(" - Installing packages...", " ");
    throwMessagesToConsole("   Please wait, it might take longer than usual...", " ");
    for(int i = 0; i < sizeof(filesToExtractFromTheZip) / sizeof(filesToExtractFromTheZip[0]); i++) {
        extractThisFileFromMe(filesToExtractFromTheZip[i], false);
    }

    // later bro 💔
    if(strcmp(whatisOTAType, "Incremental") == 0) {
        verifyHorizonSystemIntegrity();
        char *rrrrrrrrrrrr[] = {"system", "vendor", "product", "prism"};
        char *genericPartitionPaths[] = {"/vendor", "/product", "/prism"};
        for(int i = 0; i < sizeof(rrrrrrrrrrrr) / sizeof(rrrrrrrrrrrr); i++) {
            extractThisFileFromMe(rrrrrrrrrrrr[i], true);
            extractThisFileFromMe(rrrrrrrrrrrr[i], true);
            // bool copyIncrementalFiles(const char *partitionPath, char *partition)
            if(i = 0) {
                copyIncrementalFiles(systemDir, rrrrrrrrrrrr[i]);
            }
            else {
                copyIncrementalFiles(genericPartitionPaths[i], rrrrrrrrrrrr[i]);
            }
        }
    }
    else if(strcmp(whatisOTAType, "Reinstall") == 0) {
        verifyHorizonSystemIntegrity();
        for(int i = 0; i < sizeof(partitionFlashables) / sizeof(partitionFlashables[0]); i++) {
            isThisPartitionMounted(partitionFlashables[i], true) || abort("Failed to mount:", partitionFlashables[i]);
        }
    }
    else {
        throwMessagesToConsole("- Can't determine whether to flash the whole rom or just patch the necessary things, skipping the installation..", " ");
        exit(0);
    }

    if(hostsAreBackedUp) {
        isThisPartitionMounted("/system", true) || isThisPartitionMounted("/system_root", true);
        cp("/dev/tmp/install/bkp_hosts", systemHostsFilePath);
    }
}

// bool installGivenDiskImageFile(const char *imagePath, const char *blockPath, const char *ImageName)