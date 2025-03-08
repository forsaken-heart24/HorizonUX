#ifndef MODULESLOADER_H
#define MODULESLOADER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <stdbool.h>

int searchBlockListedStrings(const char *__filename, const char *__search_str);
int verifyScriptStatusUsingShell(const char *__filename);
int checkBlocklistedStringsNChar(const char *__haystack);
bool executeScriptsFromTheModuleDirectories();

#endif