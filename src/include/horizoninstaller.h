#ifndef HORIZONINSTALLER_H
#define HORIZONINSTALLER_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
// #include <openssl/md5.h> - still learning md5

// extern values - To be filled by the maintainer before compiling.
extern bool WRITE_DEBUG_MESSAGES_TO_CONSOLE;
extern bool hostsAreBackedUp;
extern bool isHotFixAndShouldBeSkipped;
extern bool iDontWantChecksumChecks;
extern bool installationHasLowLevelDiskImages;
extern bool tarballHasPasswordProtection; // anti kang shits
extern const char *tarballPassword; // anti kang shits
extern const char *shippedAs; // for determining the file format
extern char *LOG4HORIZONFILE;
extern char *INSTALLER_PATH;
extern char *whatisOTAType;
extern char OUTFD[256];
extern char *ZIPFILE;

// functions
bool verifyInstallationType(const char *requiredType, const char *zipPackage);
bool checkInternalStorageStatus();
void throwMessagesToConsole(char *text, char *extr_factor, bool putThisinLog);
void abort__(char *text, char *extr_factor);
void setupRecoveryCommandFile();
bool isThisPartitionMounted(const char *baselinePartitionName, bool DoiNeedToMountit);
bool getRomProperties(char *requiredProperty, char *requiredPropertyValue);
bool installGivenDiskImageFile(const char *imagePath, const char *blockPath, const char *imageName, const char *expected_image_hash___);
char *stringCase(const char *option, const char *input);
int cp(const char *source, const char *destination);
char *getPreviousSystemBuildID(const char *filepath);
void extractThisFileFromMe(const char *fileToExtract, bool skipErrors);
void backupHostsFileFromCurrentSystem(char *arg, const char *linuxHostsAndroidPath);
bool copyIncrementalFiles(const char *partitionPath, char *partition);
int consoleLog(char *text, char *extr_factor);
bool verifyMD5Hashes(const char *file__, const char *expected_hash__);
bool installLowLevelImages(const char *imagePath, const char *blockPath, const char *imageName, const char *expected_image_hash___);
char *getSystemProperty(const char *filepath, const char *propertyVariableName);

#endif