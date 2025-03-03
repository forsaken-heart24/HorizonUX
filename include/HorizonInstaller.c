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
    executeCommands("rm -rf /dev/tmp", false);
    exit(1);
}

// for setting up recovery command file (i'm exploiting it)
void setupRecoveryCommandFile() {
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
bool isThisPartitionMounted(const char *baselinePartitionName, bool DoiNeedToMountit) {
    FILE mounts = fopen("/proc/mounts", "r");
    char *content[1028];
    while(fgets(content, sizeof(content), mounts) != NULL) {
        if(strstr(content, baselinePartitionName) == 0) {
            if(DoiNeedToMountit) {
                char dupContent[100];
                snprintf(dupContent, sizeof(dupContent), "mount -o rw,remount %s", baselinePartitionName);
                if(executeCommands(dupContent) != 0) {
                    abort("- Failed to re-mount this partition:", baselinePartitionName);
                }
            }
            return true;
        }
    }
    return false;
}

// you get it
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

// bruhh
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
            snprintf(defoq, sizeof(defoq), "tar -xf %s -C %s", imagePath, blockPath);
            extractThisFileFromMe(imageName, false);
            if(executeCommands(defoq, false) != 0) {
                abort("- Failed to extract tarball image file", " ");
            }
        break;
        case sparse:
            char *defoq[200];
            extractThisFileFromMe(ImageName, true);
            snprintf(defoq, sizeof(defoq), "simg2img %s/%s %s", INSTALLER_PATH, ImageName, blockPath);
            if(executeCommands(defoq, false) != 0) {
                abort("- Failed to install sparse image file", " ");
            }
        break;
        case raw:
            char *defoq[200];
            snprintf(defoq, sizeof(defoq), "unzip -o %s %s -d %s", ZIPFILE, ImageName, blockPath);
            if(executeCommands(defoq, false) != 0) {
                abort("- Failed to install raw image factor into your device's", imageName);
            }
        break;
        default:
            abort("- unsupported image, the image specifier is:", shippedAs);
    }
    return true;
}

char stringCase(const char *option, const char *input) {
    if(!option || !input) {
        return 1;
    }
    if(strncasecmp(option, "lower", 7) == 0) {
        while(*input) {
            putchar(tolower((unsigned char)*input));
            input++;
        }
        return input;
    }
    else if(strncasecmp(option, "upper", 7) == 0) {
        while(*input) {
            putchar(toupper((unsigned char)*input));
            input++;
        }
        return input;
    }
    else {
        return input;
    }
}

// works like cp command in terminal
int cp(const char *source, const char *destination) {
    FILE *src = fopen(source, "rb");
    if(!src) {
        perror("Error opening source file");
        return 1;
    }
    FILE *dest = fopen(destination, "wb");
    if(!dest) {
        perror("Error opening destination file");
        fclose(src);
        return 1;
    }
    char buffer[8192];
    size_t bytesRead;
    while((bytesRead = fread(buffer, 1, 8192, src)) > 0) {
        fwrite(buffer, 1, bytesRead, dest);
    }
    fclose(src);
    fclose(dest);
    return 0;
}

// used to get previous system build id.
const char *getPreviousSystemBuildID(const char *filepath) {
    FILE *file = fopen(filepath, "r");
    if(!file) {
        return "KILL.796f7572.73656c660a";
    }
    char build_id[256];
    char line[256];
    while(fgets(line, sizeof(line), file)) {
        if(strncmp(line, "ro.build.id=", 11) == 0) {
            strcpy(build_id, line + 11);
            build_id[strcspn(build_id, "\r\n")] = 0;
            fclose(file);
            return build_id;
        }
    }
    fclose(file);
    return "KILL.796f7572.73656c660a";
}

// extracts sh from the zip file.
// unzip -o "$ZIPFILE" "$file" -d "${INSTALLER}/"
void extractThisFileFromMe(const char *fileToExtract, bool skipErrors) {    
    char *ykitsnotthesameasitwas[250];
    snprintf(ykitsnotthesameasitwas, sizeof(ykitsnotthesameasitwas), "unzip -o \"%s\" \"%s\" -d \"%s\" ", ZIPFILE, fileToExtract, INSTALLER_PATH);
    if(skipErrors || executeCommands(ykitsnotthesameasitwas) != 0) {
        abort("- Failed to extract requested file from the zipfile, please try again...", " ");
    }
}

// backs up previous rom's hosts file.
void backupHostsFileFromCurrentSystem(char *arg, const char *linuxHostsAndroidPath) {
    isThisPartitionMounted("/system", true) || isThisPartitionMounted("/system_root", true);
    if(hostsAreBackedUp || strcmp(arg, "backup") == 0) {
        cp(linuxHostsAndroidPath, INSTALLER_PATH);
    }
    else if(hostsAreBackedUp && strcmp(arg, "restore") == 0) {
        cp(INSTALLER_PATH, linuxHostsAndroidPath);
    }
}

void verifyHorizonSystemIntegrity() {
    return;
}

bool copyIncrementalFiles(const char *partitionPath, char *partition) {
    throwMessagesToConsole("- Installing incremental patches to", partition);
    if(strcmp(partition, stringCase("lower", "system")) == 0) {
        char *content[450];
        snprinf(content, sizeof(content), "%s/system/system/", INSTALLER_PATH);
        cp(content, partitionPath);
    }
    else if(strcmp(partition, stringCase("lower", "vendor")) == 0) {
        char *content[450];
        snprinf(content, sizeof(content), "%s/vendor", INSTALLER_PATH);
        cp(content, partitionPath);
    }
    else if(strcmp(partition, stringCase("lower", "product")) == 0) {
        char *content[450];
        snprinf(content, sizeof(content), "%s/product", INSTALLER_PATH);
        cp(content, partitionPath);
    }
    else if(strcmp(partition, stringCase("lower", "prism")) == 0) {
        char *content[450];
        snprinf(content, sizeof(content), "%s/product", INSTALLER_PATH);
        cp(content, partitionPath);
    }
    else {
        // unknown incremental path.
        abort("  Unknown incremental path, please contact the dev.", " ");
    }
    throwMessagesToConsole("  Finished installing incremental patches to", partition);
    return true;
}