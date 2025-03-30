//
// Copyright (C) 2025 Luna
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include <HorizonInstaller.h>

// returns bool acc. to the requested type.
bool verifyInstallationType(const char *requiredType, const char *zipPackage) {
    return (requiredType && zipPackage && strstr(requiredType, zipPackage) != NULL);
}

// returns true if the storage is not encrypted.
bool checkInternalStorageStatus() {
    DIR *iPlayedTheseGamesBefore = opendir("/data/media");
    if(!iPlayedTheseGamesBefore) {
        consoleLog("checkInternalStorageStatus(): Userdata is likely encrypted.", " ");
        return false;
    }
    closedir(iPlayedTheseGamesBefore);
    consoleLog("checkInternalStorageStatus(): yayyyyyy, the userdata is not encrypted!", " ");
    return true;
}

// throws the installation messages to OUTFD to display those messages.
void throwMessagesToConsole(char *text, char *extr_factor, bool putThisinLog) {
    if(!text) return;
    size_t purina = strlen(text) + strlen(extr_factor) + 2;
    char *kasane = malloc(purina);
    if(kasane == NULL) {
        printf("throwMessagesToConsole(): Failed to allocate memory to send messages to the recovery Console!\n");
        exit(1);
    }
    snprintf(kasane, purina, "%s %s\n", text, extr_factor);
    FILE *OUTFD__ = fopen(OUTFD, "a");
    if(OUTFD__ == NULL) {
        printf("throwMessagesToConsole(): Unable to open OUTFD, closing the console!\n");
        exit(1);
    }
    fprintf(OUTFD__, "%s", kasane);
    fclose(OUTFD__);
    free(kasane);
    if(putThisinLog) consoleLog(kasane, " ");
}

// throws installation messages and stops installation
void abort__(char *text, char *extr_factor) {
    throwMessagesToConsole(text, extr_factor, true);
    free(ZIPFILE);
    exit(1);
}

// checks if a partition is mounted
bool isThisPartitionMounted(const char *baselinePartitionName, bool DoiNeedToMountit) {
    if(!baselinePartitionName) return false;
    FILE *mounts = fopen("/proc/mounts", "r");
    if(!mounts) {
        abort__("Failed to open /proc/mounts", " ");
    }
    char content[1028];
    bool partitionIsMounted = false;
    while(fgets(content, sizeof(content), mounts)) {
        if(strstr(content, baselinePartitionName)) {
            partitionIsMounted = true;
            break;
        }
    }
    fclose(mounts);
    if(DoiNeedToMountit) {
        size_t tetoris = 21 + strlen(baselinePartitionName) + 2;
        char *teteteteteto = malloc(tetoris);
        if(!teteteteteto) {
            abort__("isThisPartitionMounted(): Failed to dynamically allocate memory for the requested operation!", " ");
        }
        snprintf(teteteteteto, tetoris, "mount -o rw,remount %s", baselinePartitionName);
        if(executeCommands(teteteteteto, false) != 0) {
            free(teteteteteto);
            abort__("- Failed to re-mount partition", " ");
        }
        free(teteteteteto);
        consoleLog("Anyways bro, this partition is mounted:", baselinePartitionName);
    }
    else {
        if(!partitionIsMounted) {
            consoleLog("Partition is not mounted:", baselinePartitionName);
            return false;
        }
        else {
            consoleLog("The requested partition: ", baselinePartitionName);
            consoleLog("was mounted without errors!", " ");
            return true;
        }
    }
}

// the name suggests it all
bool installGivenDiskImageFile(const char *imagePath, const char *blockPath, const char *imageName, const char *expected_image_hash___) {
    if(!imagePath || !blockPath || !imageName || !expected_image_hash___) {
        throwMessagesToConsole("- Insufficient Information.", "", true);
        abort__("  Error code: 0x7265616c5f626c6f636b206e6f7420736574", "");
    }
    if(!iDontWantChecksumChecks) {
        if(verifyMD5Hashes(imagePath, expected_image_hash___) == false) {
            abort__("- Checksum verification failed", " ");
        }
    }
    markInstallTypeAndBlock(imageName, blockPath);
    size_t teteteteteto = 500;
    char *defoq = malloc(teteteteteto);
    if(!defoq) {
        consoleLog("installGivenDiskImageFile(): Failed to allocate memory for the installation!", " ");
        abort__("installGivenDiskImageFile(): Failed to allocate memory for the installation, please try again!", false);
    }
    if(tarballHasPasswordProtection && strcmp(shippedAs, "tarProtected") == 0) {
        extractThisFileFromMe(imageName, true);
        snprintf(defoq, teteteteteto, "tar --password=\"%s\" -xf %s/%s -C %s", tarballPassword, INSTALLER_PATH, imagePath, blockPath);
    } 
    else if(strcmp(shippedAs, "tar") == 0) {
        extractThisFileFromMe(imageName, true);
        snprintf(defoq, teteteteteto, "tar -xf %s/%s -C %s", INSTALLER_PATH, imagePath, blockPath);
    } 
    else if(strcmp(shippedAs, "sparse") == 0) {
        extractThisFileFromMe(imageName, true);
        snprintf(defoq, teteteteteto, "simg2img %s/%s %s", INSTALLER_PATH, imageName, blockPath);
    } 
    else if(strcmp(shippedAs, "raw") == 0) {
        snprintf(defoq, teteteteteto, "unzip -o %s %s -d %s", ZIPFILE, imageName, blockPath);
    } 
    else {
        free(defoq);
        abort__("- Unsupported image format. Could not determine which format factor is shipped with, the specified factor is:", (char *)shippedAs);
    }
    if(executeCommands(defoq, false) != 0) {
        free(defoq);
        abort__("- Failed to install the image file", " ");
    }
    free(defoq);
    return true;
}

// changes string case
char *stringCase(const char *option, const char *input) {
    if(!option || !input) return NULL;
    size_t len = strlen(input) + 2;
    char *output = malloc(len);
    if(!output) {
        consoleLog("stringCase(): Memory allocation failed", " ");
        return NULL;
    }
    for(size_t i = 0; i < len; i++) {
        output[i] = (strcasecmp(option, "lower") == 0) ? tolower((unsigned char)input[i]) : toupper((unsigned char)input[i]);
    }
    output[len] = '\0';
    return output;
}

// works like cp command in terminal
int cp(const char *source, const char *destination) {
    if (!source || !destination) return 1;
    FILE *src = fopen(source, "rb");
    if (!src) return 1;
    FILE *dest = fopen(destination, "wb");
    if(!dest) {
        fclose(src);
        return 1;
    }
    char buffer[8192];
    size_t bytesRead;
    while((bytesRead = fread(buffer, 1, sizeof(buffer), src)) > 0) {
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

// extracts requested stuffs from the zip file.
void extractThisFileFromMe(const char *fileToExtract, bool skipErrors) {    
    if(!fileToExtract) return;
    size_t ykitsnotthesameasitwas = strlen(ZIPFILE) + strlen(fileToExtract) + strlen(INSTALLER_PATH) + 32;
    char *asitwas = malloc(ykitsnotthesameasitwas);
    if(!asitwas) {
        abort__("extractThisFileFromMe(): Failed to allocate enough memory for the operation, please try again!", " ");
    }
    snprintf(asitwas, ykitsnotthesameasitwas, "unzip -o \"%s\" \"%s\" -d \"%s\"", ZIPFILE, fileToExtract, INSTALLER_PATH);
    if(skipErrors == false && executeCommands(asitwas) != 0) {
        free(asitwas);
        abort__("- Failed to extract requested file from the zipfile, please try again...", " ");
    }
    free(asitwas);
}

// backs up previous rom's hosts file.
void backupHostsFileFromCurrentSystem(char *arg, const char *linuxHostsAndroidPath) {
    isThisPartitionMounted("/system", true) || isThisPartitionMounted("/system_root", true);
    if(hostsAreBackedUp || strcmp(arg, "backup") == 0) {
        consoleLog("backupHostsFileFromCurrentSystem(): Backing up the host file from", linuxHostsAndroidPath);
        if(cp(linuxHostsAndroidPath, INSTALLER_PATH) == 1) {
            throwMessagesToConsole("backupHostsFileFromCurrentSystem(): Failed to backup the host file, if you have any issues on connecting to the internet, please do a wipe data", " ", true);
        }
    }
    else if(hostsAreBackedUp && strcmp(arg, "restore") == 0) {
        consoleLog("backupHostsFileFromCurrentSystem(): Restoring the previously backed up host file to", linuxHostsAndroidPath);
        size_t magnetic = strlen("/hosts") + strlen(INSTALLER_PATH) + 2;
        char *hostsPath = malloc(magnetic);
        if(!hostsPath) {
            abort__("backupHostsFileFromCurrentSystem(): Failed to allocate memory for the operation, please try again!", " ");
        }
        snprintf(hostsPath, magnetic, "%s/hosts", INSTALLER_PATH);
        if(cp(hostsPath, linuxHostsAndroidPath) == 1) {
            throwMessagesToConsole("backupHostsFileFromCurrentSystem(): Failed to restore the host file, if you have any issues on connecting to the internet, please do a wipe data", " ", true);
        }
        free(hostsPath);
    }
}

// the name suggests it all
bool copyIncrementalFiles(const char *partitionPath, char *partition) {
    throwMessagesToConsole("- Installing incremental patches to", partition, false);
    size_t omg = 0;
    char *content = NULL;
    if(strcmp(partition, "system") == 0) {
        omg = strlen(systemDir) + strlen(INSTALLER_PATH) + 3;
        content = malloc(omg);
        if(!content) {
            abort__("copyIncrementalFiles(): Failed to allocate memory for the installation process..", " ");
        }
        snprintf(content, omg, "%s/%s", systemDir, INSTALLER_PATH);
    }
    else if(strcmp(partition, "vendor") == 0) {
        omg = strlen("/vendor") + strlen(INSTALLER_PATH) + 3;
        content = malloc(omg);
        if(!content) {
            abort__("copyIncrementalFiles(): Failed to allocate memory for the installation process..", " ");
        }
        snprintf(content, omg, "%s/vendor", INSTALLER_PATH);
    }
    else if(strcmp(partition, "product") == 0) {
        omg = strlen("/product") + strlen(INSTALLER_PATH) + 3;
        content = malloc(omg);
        if(!content) {
            abort__("copyIncrementalFiles(): Failed to allocate memory for the installation process..", " ");
        }
        snprintf(content, omg, "%s/product", INSTALLER_PATH);
    }
    else {
        free(content);
        abort__("Unknown incremental path, please contact the dev.", " ");
    }
    if(cp(content, partitionPath) == 1) {
        free(content);
        abort__("Failed to apply Incremental patches, please try again or report this to the maintainer of this device", " ");
    }
    free(content);
    throwMessagesToConsole("Finished installing incremental patches to", partition, false);
    return true;
}

// checks the hash against the file
bool verifyMD5Hashes(const char *file__, const char *expected_hash__) {
    char md5sum[80];
    size_t combineArgSize = strlen("md5sum ") + strlen(file__) + strlen("| awk '{print $1}'") + 2;
    char *combine = malloc(combineArgSize);
    if(!combine) {
        abort__("verifyMD5Hashes(): Failed to allocate enough memory for the operation...", " ");
    }
    snprintf(combine, combineArgSize, "md5sum \"%s\" | awk '{print $1}'", file__);
    FILE *commandOutputPointer = popen(combine, "r");
    if(!commandOutputPointer) {
        free(combine);
        abort__("verifyMD5Hashes(): Failed to get file md5 hash to verify the file in the zip...", " ");
    }
    if(fgets(md5sum, sizeof(md5sum), commandOutputPointer) != NULL) {
        // Remove newline
        md5sum[strcspn(md5sum, "\n")] = 0;
        if(strcmp(expected_hash__, md5sum) == 0) {
            free(combine);
            pclose(commandOutputPointer);
            return true;
        }
    }
    free(combine);
    pclose(commandOutputPointer);
    consoleLog("verifyMD5Hashes(): Affected file:", (char *)file__);
    abort__("  The hashes don't match the expected values from the installer. Please re-download the package or report this to the developer.", " ");
    return false;
}

// ts writes misc stuffs that are needed for manage-firmware.sh
void markInstallTypeAndBlock(const char *imageName, const char *blockPath) {
    FILE *ok_alip = fopen("/dev/tmp/install/daridaridaridari", "w");
    if(!ok_alip) {
        abort__("markInstallTypeAndBlock(): Failed to open \"/dev/tmp/install/daridaridaridari\" in write mode...", " ");
    }
    fprintf(ok_alip, "Currently Installing: %s To Requested Block: %s | shippedAs: %s | OUTFD Constucted Path: %s | Zip File Path: %s | WRITE_DEBUG_MESSAGES_TO_CONSOLE: %d | createSnapshot: %d", imageName, blockPath, shippedAs, OUTFD, ZIPFILE, WRITE_DEBUG_MESSAGES_TO_CONSOLE, createSnapshot);
    fclose(ok_alip);
}

// takes backup of the given image
int takeBackupOfTheGivenImage(const char *blockPath) {
    size_t paper_flower = strlen("cp") + strlen(blockPath) + strlen("/dev/tmp/install/") + 5;
    char *infinity = malloc(paper_flower);
    if(!infinity) {
        abort__("takeBackupOfTheGivenImage(): Failed to allocate memory for the backup operation...", " ");
    }
    snprintf(infinity, paper_flower, "cp %s /dev/tmp/install/low-level-backups/", blockPath);
    int exit_status__ = executeCommands(infinity, false);
    free(infinity);
    return exit_status__;
}

// installs low level images with addtional checks and stuffs.
bool installLowLevelImages(const char *imagePath, const char *blockPath, const char *imageName, const char *expected_image_hash___) {
    if(!imagePath || !blockPath || !imageName || !expected_image_hash___) {
        throwMessagesToConsole("- Insufficient Information. The zip might be corrupted", " ", true);
        abort__("installLowLevelImages():  Error code: 0x7265616c5f626c6f636b206e6f7420736574", " ");
    }
    markInstallTypeAndBlock(imageName, blockPath);
    executeScripts("/dev/tmp/install/manage-firmware.sh --backup", false);
    extractThisFileFromMe(imageName, true);
    size_t teteteteteto = 500;
    char *defoq = malloc(teteteteteto);
    if(tarballHasPasswordProtection && strcmp(shippedAs, "tarProtected") == 0) {
        snprintf(defoq, teteteteteto, "tar --password=\"%s\" -xf %s -C %s", tarballPassword, INSTALLER_PATH, imageName, blockPath);
    }
    else if(strcmp(shippedAs, "tar") == 0) {
        snprintf(defoq, teteteteteto, "tar -xf %s -C %s", INSTALLER_PATH, imageName, blockPath);
    } 
    else if(strcmp(shippedAs, "sparse") == 0) {
        snprintf(defoq, teteteteteto, "simg2img %s/%s %s", INSTALLER_PATH, imageName, blockPath);
    } 
    else if(strcmp(shippedAs, "raw") == 0) {
        snprintf(defoq, teteteteteto, "unzip -o %s %s -d %s", ZIPFILE, imageName, blockPath);
    } 
    else {
        free(defoq);
        abort__("- Unsupported image type detected:", (char *)shippedAs);
    }
    size_t ok_alip = strlen(imageName) + strlen(INSTALLER_PATH) + 3;
    char *thisTimeiWantYOU = malloc(ok_alip);
    if(!thisTimeiWantYOU) {
        free(defoq);
        abort__("installLowLevelImages(): Failed to allocation enough memory for the operation!!", " ");
    }
    snprintf(thisTimeiWantYOU, ok_alip, "%s/%s", INSTALLER_PATH, imageName);
    if(verifyMD5Hashes(thisTimeiWantYOU, expected_image_hash___) == false) {
        free(defoq);
        free(thisTimeiWantYOU);
        abort__("installLowLevelImages(): Failed to verify hashes, please download this package again or contact the support chat!", " ");
    }
    free(thisTimeiWantYOU);
    if(executeCommands(defoq, false) != 0) {
        free(defoq);
        throwMessagesToConsole("installLowLevelImages(): Failed to update low level images, using fallback scripts to restore previous firmware...", "", false);
        executeScripts("/dev/tmp/install/manage-firmware.sh --restore", false);
    }
}