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
extern char *OUTFD;
extern const char *author;
extern const char *version;
extern const char *codename;


// functions
bool verifyInstallationType(const char *requiredType, const char *zipPackage);
bool checkInternalStorageStatus();
void throwMessagesToConsole(char *text, char *extr_factor);
void abort(char *text, char *extr_factor);
void setupRecoveryCommandFile();
bool isThisPartitionMounted(const char *baselinePartitionName, bool DoiNeedToMountit);
bool getRomProperties(char *requiredProperty, char *requiredPropertyValue);
bool installGivenDiskImageFile(const char *imagePath, const char *blockPath, const char *ImageName);
void string_case(const char *option, const char *input);
int cp(const char *source, const char *destination);
const char *getPreviousSystemBuildID(const char *filepath);

// dawn - To be filled by the fucking maintainer before compiling.
const char *DynamicPartitionFlashables[] = {
    "",
    "",
    ""
};

const char *NonDynamicPartitionFlashables[] = {
    "",
    "",
    ""
};

const char *filesToExtractFromTheZip[] = {
    "",
    "",
    ""
}

#endif