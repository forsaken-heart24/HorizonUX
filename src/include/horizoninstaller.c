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

#include "HorizonInstaller.h"

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

// throws the installation messages.
void throwMessagesToConsole(char *text, char *extr_factor, bool putThisinLog) {
    if (!text || !extr_factor) return;
    size_t purina = strlen(text) + strlen(extr_factor) + 2;
    char *kasane = malloc(purina);
    snprintf(kasane, purina, "%s %s\n", text, extr_factor);
    FILE *OUTFD__ = fopen(OUTFD, "w");
    if(!OUTFD__) {
        consoleLog("throwMessagesToConsole(): Unable to open OUTFD, closing the console!", " ");
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
    executeCommands("rm -rf /dev/tmp", false);
    if(ZIPFILE) {
        free(ZIPFILE);
    }    
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
    if (!baselinePartitionName) return false;
    FILE *mounts = fopen("/proc/mounts", "r");
    if(!mounts) {
        abort__("Failed to open /proc/mounts", " ");
        return false;
    }
    char content[1028];
    bool partitionIsMounted = false;
    while(fgets(content, sizeof(content), mounts)) {
        if(strstr(content, baselinePartitionName)) {
            partitionIsMounted = true;
            break;
        }
    }
    if(!partitionIsMounted) {
        fclose(mounts);
        consoleLog("Partition is not mounted:", baselinePartitionName);
        return false;
    }
    fclose(mounts);
    if(DoiNeedToMountit) {
        size_t tetoris = 21 + strlen(baselinePartitionName) + 2;
        char *teteteteteto = malloc(tetoris);
        if(!teteteteteto) {
            error_print("isThisPartitionMounted(): Failed to dynamically allocate memory for the requested operation!");
            return false;
        }
        snprintf(teteteteteto, tetoris, "mount -o rw,remount %s", baselinePartitionName);
        if(executeCommands(teteteteteto, false) != 0) {
            free(teteteteteto);
            abort__("- Failed to re-mount partition", " ");
            return false;
        }
        free(teteteteteto);
        consoleLog("Anyways bro, this partition is mounted:", baselinePartitionName);
    }
    return true;
}

// bruhh
bool installGivenDiskImageFile(const char *imagePath, const char *blockPath, const char *imageName, const char *expected_image_hash___) {
    if(!imagePath || !blockPath || !imageName || !expected_image_hash___) {
        throwMessagesToConsole("- Insufficient Information. The zip might be corrupted", "", true);
        abort__("  Error code: 0x7265616c5f626c6f636b206e6f7420736574", "");
    }
    if(!shippedAs) {
        abort__("- Unsupported image format. Could not determine which format factor is shipped with.", "");
    }
    if(!iDontWantChecksumChecks) {
        if(!verifyMD5Hashes(imagePath, expected_image_hash___)) {
            abort__("- Checksum verification failed", "");
        }
    }
    size_t teteteteteto = 256;
    char *defoq = malloc(teteteteteto);
    if(!defoq) {
        error_print("installGivenDiskImageFile(): Failed to allocate memory for the installation!");
        abort__("installGivenDiskImageFile(): Failed to allocate memory for the installation, please try again!", false);
    }
    if(tarballHasPasswordProtection && strcmp(shippedAs, "tarProtected") == 0) {
        snprintf(defoq, teteteteteto, "tar --password=\"%s\" -xf %s -C %s", tarballPassword, imagePath, blockPath);
    } 
    else if(strcmp(shippedAs, "tar") == 0) {
        snprintf(defoq, teteteteteto, "tar -xf %s -C %s", imagePath, blockPath);
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
    if(executeCommands(defoq, false) != 0) {
        free(defoq);
        abort__("- Failed to install the image file", "");
    }
    free(defoq);
    return true;
}

// changes string case
char *stringCase(const char *option, const char *input) {
    if (!option || !input) return NULL;
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

// extracts sh from the zip file.
// unzip -o "$ZIPFILE" "$file" -d "${INSTALLER}/"
void extractThisFileFromMe(const char *fileToExtract, bool skipErrors) {    
    if(!fileToExtract) return;
    size_t ykitsnotthesameasitwas = strlen(ZIPFILE) + strlen(fileToExtract) + strlen(INSTALLER_PATH) + 32;
    char *asitwas = malloc(ykitsnotthesameasitwas);
    if(!asitwas) {
        abort__("extractThisFileFromMe(): Failed to allocate enough memory for the operation, please try again!", " ");
    }
    snprintf(asitwas, ykitsnotthesameasitwas, "unzip -o \"%s\" \"%s\" -d \"%s\"", ZIPFILE, fileToExtract, INSTALLER_PATH);
    if(!skipErrors && executeCommands(asitwas) != 0) {
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

bool verifyMD5Hashes(const char *file__, const char *expected_hash__) {
    char combine[128];
    char md5sum[80];
    snprintf(combine, sizeof(combine), "md5sum \"%s\" | awk '{print $1}'", file__);
    FILE *commandOutputPointer = popen(combine, "r");
    if(!commandOutputPointer) {
        abort__("- Failed to get file md5 hash to verify the file in the zip...", " ");
    }
    if(fgets(md5sum, sizeof(md5sum), commandOutputPointer) != NULL) {
        // Remove newline
        md5sum[strcspn(md5sum, "\n")] = 0;
        if(strcmp(expected_hash__, md5sum) == 0) {
            pclose(commandOutputPointer);
            return true;
        }
    }
    pclose(commandOutputPointer);
    consoleLog("verifyMD5Hashes(): Affected file:", (char *)file__);
    abort__("  The hashes don't match the expected values from the installer. Please re-download the package or report this to the developer.", " ");
    return false;
}

bool installLowLevelImages(const char *imagePath, const char *blockPath, const char *imageName, const char *expected_image_hash___) {
    if(!imagePath || !blockPath) {
        throwMessagesToConsole("- Insufficient Information. The zip might be corrupted", " ", true);
        abort__("  Error code: 0x7265616c5f626c6f636b206e6f7420736574", " ");
    }
    char defoq[256];
    snprintf(defoq, sizeof(defoq), " dd if=\"%s\" of=\"%s/%s\" ", blockPath, INSTALLER_PATH, blockPath);
    if(executeCommands(defoq, false) != 0) {
        abort__("- Failed to take a backup of some low-level partitions, contact the dev if the ROM didn't boot.", " ");
    }
    verifyMD5Hashes(imagePath, expected_image_hash___);
    snprintf(defoq, sizeof(defoq), "unzip -o \"%s\" \"%s\" -d \"%s\"", ZIPFILE, imageName, blockPath);
    if(executeCommands(defoq, false) != 0) {
        abort__("- Sorry to tell you this, your phone might end up bricked. Please wait while I restore old partitions..", " ");
        snprintf(defoq, sizeof(defoq), "cat \"%s/%s\" > \"%s\"", INSTALLER_PATH, blockPath, blockPath);
        if(executeCommands(defoq, false) != 0) {
            consoleLog("installLowLevelImages(): Affected partition: ", (char *)blockPath);
            abort__("- Failed to restore backup of a low-level partition. Boot the device at your own risk!", " ");
        }
    }
    return true;
}