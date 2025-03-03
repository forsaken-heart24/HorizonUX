#ifndef HORIZONINSTALLER_H
#define HORIZONINSTALLER_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>

// extern values.
extern bool WRITE_DEBUG_MESSAGES_TO_CONSOLE;
extern bool hostsAreBackedUp;
extern const char *LOG4HORIZONFILE;
extern const char *INSTALLER_PATH;
extern const char *maintainer;
extern const char *version;
extern const char *codename;
extern const char *whatisOTAType;
extern char *OUTFD;

// functions
bool verifyInstallationType(const char *requiredType, const char *zipPackage);
bool checkInternalStorageStatus();
void throwMessagesToConsole(char *text, char *extr_factor);
void abort(char *text, char *extr_factor);
void setupRecoveryCommandFile();
bool isThisPartitionMounted(const char *baselinePartitionName, bool DoiNeedToMountit);
bool getRomProperties(char *requiredProperty, char *requiredPropertyValue);
bool installGivenDiskImageFile(const char *imagePath, const char *blockPath, const char *ImageName);
char stringCase(const char *option, const char *input);
int cp(const char *source, const char *destination);
const char *getPreviousSystemBuildID(const char *filepath);
void extractThisFileFromMe(const char *fileToExtract, bool skipErrors);
bool backupHostsFileFromCurrentSystem(char *arg, const char *linuxHostsAndroidPath);
void verifyHorizonSystemIntegrity();
bool copyIncrementalFiles(const char *partitionPath, char *partition);

// dawn - To be filled by the maintainer before compiling.
const char *partitionFlashables[] = {
    "",
    "",
    ""
};

const char *filesToExtractFromTheZip[] = {
    "",
    "",
    ""
};

const char *supportedDevicesList[] = {
    "",
    ""
};

#endif