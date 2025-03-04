#include "HorizonInstaller.h"

// returns bool acc. to the requested type.
bool verifyInstallationType(const char *requiredType, const char *zipPackage) {
    return (strstr(requiredType, zipPackage) != NULL);
}

// returns true if the storage is not encrypted.
bool checkInternalStorageStatus() {
    DIR *iPlayedTheseGamesBefore = opendir("/data/media");
    if(!iPlayedTheseGamesBefore) {
        consoleLog("checkInternalStorageStatus(): Unable to open /data/media/, userdata is likely encrypted.", " ");
        return false;
    }
    closedir(iPlayedTheseGamesBefore);
    consoleLog("checkInternalStorageStatus(): yayyyyyy, the userdata is not encrypted!", " ");
    return true;
}

// throws the installation messages.
void throwMessagesToConsole(char *text, char *extr_factor) {
    char combine[1028];
    snprintf(combine, sizeof(combine), "%s %s\n", text, extr_factor);
    
    FILE *OUTFD__ = fopen(OUTFD, "w");
    if(!OUTFD__) {
        consoleLog("throwMessagesToConsole(): Unable to open OUTFD, closing the console!", " ");
        exit(1);
    }
    fprintf(OUTFD__, "%s", combine);
    fclose(OUTFD__);
}

// throws installation messages and stops installation
void abort__(char *text, char *extr_factor) {
    throwMessagesToConsole(text, extr_factor);
    executeCommands("rm -rf /dev/tmp", false);
    exit(1);
}

// sets up recovery command file
void setupRecoveryCommandFile() {
    FILE *rcmFile = fopen("/cache/recovery/command", "w");
    if(!rcmFile) {
        error_print("setupRecoveryCommandFile(): Failed to open recovery command file.");
        return;
    }
    fputs(hostsAreBackedUp ? "--delete_apn_changes" : "--data_resizing", rcmFile);
    fclose(rcmFile);
}

// checks if partition is mounted
bool isThisPartitionMounted(const char *baselinePartitionName, bool DoiNeedToMountit) {
    FILE *mounts = fopen("/proc/mounts", "r");
    if(!mounts) {
        abort__("Failed to open /proc/mounts", " ");
        return false;
    }
    char content[1028];
    while(fgets(content, sizeof(content), mounts) != NULL) {
        if(strstr(content, baselinePartitionName) != NULL) {
            fclose(mounts);
            if(DoiNeedToMountit) {
                char dupContent[128];
                snprintf(dupContent, sizeof(dupContent), "mount -o rw,remount %s", baselinePartitionName);
                if(executeCommands(dupContent) != 0) {
                    abort__("- Failed to re-mount partition", " ");
                    return false;
                }
            }
            return true;
        }
    }
    fclose(mounts);
    return false;
}

// checks ROM properties
bool getRomProperties(char *requiredProperty, char *requiredPropertyValue) {
    char content[200];
    char combinedBullshit[200];
    FILE *romPropertyFile = fopen("/dev/tmp/install/rom.prop", "r");
    if(!romPropertyFile) {
        consoleLog("getRomProperties(): Failed to open ROM config file", "(/dev/tmp/install/rom.prop)");
        return false;
    }
    snprintf(combinedBullshit, sizeof(combinedBullshit), "%s=%s", requiredProperty, requiredPropertyValue);
    while(fgets(content, sizeof(content), romPropertyFile) != NULL) {
        content[strcspn(content, "\n")] = '\0';
        if(strcmp(combinedBullshit, content) == 0) {
            fclose(romPropertyFile);
            return true;
        }
    }
    fclose(romPropertyFile);
    return false;
}

// bruhh
bool installGivenDiskImageFile(const char *imagePath, const char *blockPath, const char *imageName) {
    FILE *imagePath__ = fopen(imagePath, "r");
    FILE *blockPath__ = fopen(blockPath, "r");
    char *shippedAs;
    if(!imagePath__ || !blockPath__) {
        throwMessagesToConsole("- Insufficient Information. The zip might be corrupted", "");
        abort__("  Error code: 0x7265616c5f626c6f636b206e6f7420736574", "");
    }
    char *extensionList[] = {"tar", "sparse", "raw"};
    for(int i = 0; i < 3; i++) {
        if(getRomProperties("SHIPPED_AS_WHAT", extensionList[i])) {
            shippedAs = extensionList[i];
        }
    }
    if(strcmp(shippedAs, "tar") == 0) {
        char defoq[200];
        snprintf(defoq, sizeof(defoq), "tar -xf %s -C %s", imagePath, blockPath);
        extractThisFileFromMe(imageName, false);
        if(executeCommands(defoq, false) != 0) {
            abort__("- Failed to extract tarball image file", " ");
        }
    }
    else if(strcmp(shippedAs, "sparse") == 0) {
        char defoq[200];
        extractThisFileFromMe(imageName, true);
        snprintf(defoq, sizeof(defoq), "simg2img %s/%s %s", INSTALLER_PATH, imageName, blockPath);
        if(executeCommands(defoq, false) != 0) {
            abort__("- Failed to install sparse image file", " ");
        }
    }
    else if(strcmp(shippedAs, "raw") == 0) {
        char defoq[200];
        snprintf(defoq, sizeof(defoq), "unzip -o %s %s -d %s", ZIPFILE, imageName, blockPath);
        if(executeCommands(defoq, false) != 0) {
            abort__("- Failed to install raw image factor into your device", " ");
        }
    }
    else {
        abort__("- unsupported image, the image specifier is:", shippedAs);
    }
    return true;
}

// changes string case
char *stringCase(const char *option, const char *input) {
    if(!option || !input) {
        consoleLog("stringCase(): Missing argument", " ");
        return NULL;
    }
    size_t len = strlen(input);
    char *output = malloc(len + 1);
    if(!output) {
        consoleLog("stringCase(): Memory allocation failed", " ");
        return NULL;
    }
    if(strcasecmp(option, "lower") == 0) {
        for(size_t i = 0; i < len; i++) {
            output[i] = tolower((unsigned char)input[i]);
        }
    }
    else if(strcasecmp(option, "upper") == 0) {
        for(size_t i = 0; i < len; i++) {
            output[i] = toupper((unsigned char)input[i]);
        }
    }
    else {
        strncpy(output, input, len);
    }
    output[len] = '\0';
    return output;
}

// works like cp command in terminal
int cp(const char *source, const char *destination) {
    FILE *src = fopen(source, "rb");
    if(!src) {
        consoleLog("cp(): Error opening source file", " ");
        return 1;
    }
    FILE *dest = fopen(destination, "wb");
    if(!dest) {
        consoleLog("cp(): Error opening destination file", " ");
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
char *getPreviousSystemBuildID(const char *filepath) {
    static char build_id[256];
    FILE *file = fopen(filepath, "r");
    if(!file) {
        return "KILL.796f7572.73656c660a";
    }
    char line[256];
    while(fgets(line, sizeof(line), file)) {
        if(strncmp(line, "ro.build.id=", 11) == 0) {
            strncpy(build_id, line + 11, sizeof(build_id) - 1);
            build_id[sizeof(build_id) - 1] = '\0';
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
    char ykitsnotthesameasitwas[250];
    snprintf(ykitsnotthesameasitwas, sizeof(ykitsnotthesameasitwas), "unzip -o \"%s\" \"%s\" -d \"%s\" ", ZIPFILE, fileToExtract, INSTALLER_PATH);
    if(skipErrors || executeCommands(ykitsnotthesameasitwas) != 0) {
        abort__("- Failed to extract requested file from the zipfile, please try again...", " ");
    }
}

// backs up previous rom's hosts file.
void backupHostsFileFromCurrentSystem(char *arg, const char *linuxHostsAndroidPath) {
    isThisPartitionMounted("/system", true) || isThisPartitionMounted("/system_root", true);
    if(hostsAreBackedUp || strcmp(arg, "backup") == 0) {
        consoleLog("backupHostsFileFromCurrentSystem(): Backing up the host file from", (char *)linuxHostsAndroidPath);
        if(cp(linuxHostsAndroidPath, INSTALLER_PATH) == 1) {
            throwMessagesToConsole("backupHostsFileFromCurrentSystem(): Failed to backup the host file, if you have any issues on connecting to the internet, please do a wipe data", " ");
        }

    }
    else if(hostsAreBackedUp && strcmp(arg, "restore") == 0) {
        consoleLog("backupHostsFileFromCurrentSystem(): Restoring the previously backed up host file to", (char *)linuxHostsAndroidPath);
        char hostsPath[256];
        snprintf(hostsPath, sizeof(hostsPath), "%s/hosts", INSTALLER_PATH);
        if(cp(hostsPath, linuxHostsAndroidPath) == 1) {
            throwMessagesToConsole("backupHostsFileFromCurrentSystem(): Failed to restore the host file, if you have any issues on connecting to the internet, please do a wipe data", " ");
        }
    }
}

bool copyIncrementalFiles(const char *partitionPath, char *partition) {
    throwMessagesToConsole("- Installing incremental patches to", partition);
    char content[450];
    if(strcmp(partition, "system") == 0) {
        snprintf(content, sizeof(content), "%s/system/system/", INSTALLER_PATH);
    }
    else if(strcmp(partition, "vendor") == 0) {
        snprintf(content, sizeof(content), "%s/vendor", INSTALLER_PATH);
    }
    else if(strcmp(partition, "product") == 0) {
        snprintf(content, sizeof(content), "%s/product", INSTALLER_PATH);
    }
    else if(strcmp(partition, "prism") == 0) {
        snprintf(content, sizeof(content), "%s/product", INSTALLER_PATH);
    }
    else {
        // unknown incremental path.
        abort__("  Unknown incremental path, please contact the dev.", " ");
    }
    if(cp(content, partitionPath) == 1) {
        abort__("Failed to apply Incremental patches, please try again or report this to the maintainer of this device", " ");
    }
    throwMessagesToConsole("  Finished installing incremental patches to", partition);
    return true;
}

// logs to console
int consoleLog(char *text, char *extr_factor) {
    FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
    if(!log4horizon) return 1;
    fprintf(log4horizon, "%s %s\n", text, extr_factor);
    fclose(log4horizon);
    return 0;
}