#ifndef MODULESLOADER_H
#define MODULESLOADER_H

#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>
#include <dirent.h>
#include <sys/wait.h>
#include <sys/stat.h>

int searchBlockListedStrings(char *__filename, char *__search_str);
int verifyScriptStatusUsingShell(char *__filename);
int checkBlocklistedStringsNChar(char *__haystack);
bool executeScriptsFromTheModuleDirectories();

#endif