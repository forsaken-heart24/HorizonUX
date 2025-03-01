#ifndef HORIZONINSTALLER_H
#define HORIZONINSTALLER_H

#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

bool returnActualLinkPaths(); // still in constuction. 
bool checkInternalStorageStatus();
bool check_installation_type(const char *requiredType, const char *zipPackage);

#endif