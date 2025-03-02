#ifndef HORIZONINSTALLER_H
#define HORIZONINSTALLER_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

extern bool WRITE_DEBUG_MESSAGES_TO_CONSOLE;
extern const char *LOG4HORIZONFILE;
extern const char *INSTALLER_PATH;
extern char *OUTFD;

bool verifyInstallationType(const char *requiredType, const char *zipPackage);
bool checkInternalStorageStatus();
void throwMessagesToConsole(char *text, char *extr_factor);
void abort(char *text, char *extr_factor);
void setupRecoveryCommandFile(bool hostsAreBackedUp);
bool isThisPartitionMounted(const char *baselinePartitionName);
bool getRomProperties(char *requiredProperty, char *requiredPropertyValue);
bool installGivenDiskImageFile(const char *imagePath, const char *blockPath, const char *ImageName);

#endif