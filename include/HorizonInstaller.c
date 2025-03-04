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
    closedir(iPlayedTheseGamesBefore);
    return true;
}

// throws the installation messages.
void throwMessagesToConsole(char *text, char *extr_factor) {
    char combine[1028];
    snprintf(combine, sizeof(combine), "%s %s\n", text, extr_factor);
    FILE *OUTFD__ = fopen(OUTFD, "w");
    if(!OUTFD__) {
        exit(1);
    }
    fprintf(OUTFD__, "%s", combine);
    fclose(OUTFD__);
}

// throws the installation messages and stops the installation
void abort__(char *text, char *extr_factor) {
    throwMessagesToConsole(text, extr_factor);
    executeCommands("rm -rf /dev/tmp", false);
    exit(1);
}

// for setting up recovery command file (i'm exploiting it)
void setupRecoveryCommandFile() {
    FILE *rcmFile = fopen("/cache/recovery/command", "w");
    if(!hostsAreBackedUp) {
        fputs("--data_resizing", rcmFile);
    }
    else {
        fputs("--delete_apn_changes", rcmFile);
    }
    executeCommands("chown 1000 /cache/recovery/command", false);
    executeCommands("chgrp 1000 /cache/recovery/command", false);
    executeCommands("chmod 644 /cache/recovery/command", false);
    fclose(rcmFile);
}

// usage: isThisPartitionMounted("/system"); if it's mounted it'll return true; otherwise false (failed or it's not mounted)
bool isThisPartitionMounted(const char *baselinePartitionName, bool DoiNeedToMountit) {
    FILE *mounts = fopen("/proc/mounts", "r");
    if(!mounts) {  // Check if fopen() failed
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
                    abort__("- Failed to re-mount the given partition", " ");
                    return false;
                }
            }
            return true;
        }
    }
    fclose(mounts);
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

char *stringCase(const char *option, const char *input) {
    if(!option || !input) {
        return NULL;
    }
    size_t len = strlen(input);
    char *output = malloc(len + 1);
    if(!output) {
        return NULL;
    }
    if(strncasecmp(option, "lower", 6) == 0) {
        for(size_t i = 0; i < len; i++) {
            output[i] = tolower((unsigned char)input[i]);
        }
    } 
    else if(strncasecmp(option, "upper", 6) == 0) {
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
        cp(linuxHostsAndroidPath, INSTALLER_PATH);
    }
    else if(hostsAreBackedUp && strcmp(arg, "restore") == 0) {
        cp(INSTALLER_PATH, linuxHostsAndroidPath);
    }
}

bool copyIncrementalFiles(const char *partitionPath, char *partition) {
    throwMessagesToConsole("- Installing incremental patches to", partition);
    if(strcmp(partition, "system") == 0) {
        char content[450];
        snprintf(content, sizeof(content), "%s/system/system/", INSTALLER_PATH);
        cp(content, partitionPath);
    }
    else if(strcmp(partition, "vendor") == 0) {
        char content[450];
        snprintf(content, sizeof(content), "%s/vendor", INSTALLER_PATH);
        cp(content, partitionPath);
    }
    else if(strcmp(partition, "product") == 0) {
        char content[450];
        snprintf(content, sizeof(content), "%s/product", INSTALLER_PATH);
        cp(content, partitionPath);
    }
    else if(strcmp(partition, "prism") == 0) {
        char content[450];
        snprintf(content, sizeof(content), "%s/product", INSTALLER_PATH);
        cp(content, partitionPath);
    }
    else {
        // unknown incremental path.
        abort__("  Unknown incremental path, please contact the dev.", " ");
    }
    throwMessagesToConsole("  Finished installing incremental patches to", partition);
    return true;
}

int consoleLog(char *text, char *extr_factor) {
    if(WRITE_DEBUG_MESSAGES_TO_CONSOLE == true) {
        throwMessagesToConsole(text, extr_factor);
    }
    else {        
        FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
        fprintf(log4horizon, "consoleLog(): %s\n", Message);
        fclose(log4horizon);
    }
}