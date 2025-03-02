#include "horizonux.h"
#include "horizonutils.h"
#include "HorizonInstaller.h"

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
const char *LOG4HORIZONFILE = "/sdcard/modulesLoader.log";
const char *INSTALLER_PATH = "/dev/tmp/install";
char *ZIPFILE = NULL;
char *OUTFD = NULL;
bool hostsAreBackedUp = false;
const char *author = "Luna";
const char *version = "1.0";
const char *codename = "Birds";

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
    throwMessagesToConsole("Developer : ", author);
    throwMessagesToConsole("Version   : v", version);
    throwMessagesToConsole("Codename  : ", codename);
    throwMessagesToConsole("###############################################", " ");
    throwMessagesToConsole(" - Installing packages...", " ");
    throwMessagesToConsole("   Please wait, it might take longer than usual...", " ");
    for(int i = 0; i < sizeof(filesToExtractFromTheZip) / sizeof(filesToExtractFromTheZip[0]); i++) {
        extractThisFileFromMe(filesToExtractFromTheZip[i]);
    }

    // later bro 💔

    if(hostsAreBackedUp) {
        isThisPartitionMounted("/system", true) || isThisPartitionMounted("/system_root", true);
        cp("/dev/tmp/install/bkp_hosts", systemHostsFilePath);
    }
}