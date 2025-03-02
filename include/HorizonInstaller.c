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

bool getRomProperties(char *requiredProperty, char *requiredPropertyValue) {
    char content[200];
    char combinedBullshit[200];
    FILE *romPropertyFile = fopen("/dev/tmp/install/rom.prop", "r");
    if(!romPropertyFile) {
        exit(1);
    }
    snprintf(combinedBullshit, sizeof(content), "%s=%s", requiredProperty, requiredPropertyValue);
    while(fgets(content, sizeof(content), romPropertyFile) != NULL) {
        if(strcmp(combinedBullshit, content) == 0) {
            return true;
        }
    }
    return false;
}

bool installGivenDiskImageFile(const char *imagePath, const char *blockPath, const char *ImageName) {
    FILE *imagePath__ = fopen(imagePath, "r");
    FILE *blockPath__ = fopen(blockPath, "r");
    if(!imagePath__ || !blockPath__) {
        throwMessagesToConsole("- Insufficient Information. The zip might be corrupted", "");
        abort("  Error code: 0x7265616c5f626c6f636b206e6f7420736574", "");
    }
    char *extensionList[] = {"tar", "sparse", "raw"};
    for(int i = 0; i < 3; i++) {
        if(getRomProperties("SHIPPED_AS_WHAT", extensionList[i])) {
            const char *shippedAs = extensionList[i];
        }
    }
    switch(shippedAs) {
        case tar:
            char *defoq[200];
            snprintf(defoq, sizeof(defoq), "tar -xf %s -C /dev/tmp/install/%s.img", ImageName);
            if(executeCommands(defoq, false) != 0) {
                abort("- Failed to extract tarball image file", " ");
            }
            break;
        case sparse:
            char *defoq[200];
            snprintf(defoq, sizeof(defoq), "simg2img /dev/tmp/install/%s.img %s", ImageName, imagePath);
            if(executeCommands(defoq, false) != 0) {
                abort("- Failed to install sparse image file", " ");
            }
            break;
        case raw:
            char *defoq[200];
            snprintf(defoq, sizeof(defoq), "cp /dev/tmp/install/%s.img %s", ImageName, imagePath);
            if(executeCommands(defoq, false) != 0) {
                abort("- Failed to install raw image factor into your device's", imageName);
            }
            break;
        default:
            abort("- unsupported image, the image specifier is:", shippedAs);
    }
    return true;
}