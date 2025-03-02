#include "HorizonInstaller.h"

// returns bool acc. to the requested type.
bool verifyInstallationType(const char *requiredType, const char *zipPackage) {
    if(strstr(requiredType, zipPackage) == 0) {
        return true;
    }
    return false;
}

// returns true if thr shit is not encrypted/
bool checkInternalStorageStatus() {
    DIR *iPlayedTheseGamesBefore = opendir("/data/media");
    if(!iPlayedTheseGamesBefore) {
        return false;
    }
    return true;
}

// throws the installation messages.
void throwMessagesToConsole(char *text, char *extr_factor) {
    char *combine[1028];
    snprintf(combine, sizeof(combine), "%s %s\n", text, extr_factor);
    FILE *OUTFD__ = fopen(procPath, "w");
    if(!OUTFD__) {
        exit(1);
    }
    fprintf(OUTFD__, combine);
    fclose(OUTFD__);
}


// throws the installation messages and stops the installation
void abort(char *text, char *extr_factor) {
    throwMessagesToConsole(text, extr_factor);
    executeCommands("/dev/tmp", false);
    exit(1);
}

// for setting up recovery command file (i'm exploiting it)
void setupRecoveryCommandFile(bool hostsAreBackedUp) {
    FILE *rcmFile = fopen("/cache/recovery/command", "w");
    if(!hostsAreBackedUp) {
        fputs(rcmFile, "--data_resizing");
    }
    else {
        fputs(rcmFile, "--delete_apn_changes");
    }
    executeCommands("chown 1000 /cache/recovery/command", false);
    executeCommands("chgrp 1000 /cache/recovery/command", false);
    executeCommands("chmod 644 /cache/recovery/command", false);
    fclose(rcmFile);
}

// usage: isThisPartitionMounted("/system"); if it's mounted it'll return true; otherwise false (failed or it's not mounted)
bool isThisPartitionMounted(const char *baselinePartitionName) {
    FILE mounts = fopen("/proc/mounts", "r");
    char *content[1028];
    while(fgets(content, sizeof(content), mounts) != NULL) {
        if(strstr(content, baselinePartitionName) == 0) {
            return true;
        }
    }
    return false;
}