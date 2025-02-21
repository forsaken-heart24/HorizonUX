#ifndef MODULESLOADER_H
#define MODULESLOADER_H

#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>

int searchBlockListedStrings(char *__filename, char *__search_str);
int verifyScriptStatusUsingShell(char *__filename);
int mainModuleLoader(char *__haystack);

#endif