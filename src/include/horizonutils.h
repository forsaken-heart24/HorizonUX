#ifndef HORIZONUTILS_H
#define HORIZONUTILS_H

#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

// FUCKING global FUCKING variables.
extern bool WRITE_DEBUG_MESSAGES_TO_CONSOLE;
extern char *LOG4HORIZONFILE;
 
// FUCKING function FUCKING declarations.
void error_print(const char *Message);
void error_print_extended(const char *message, const char *additional_args);
bool erase_file_content(const char *__file);
int executeCommands(const char *command, bool requiresOutput);
int executeScripts(const char *__script__file, const char *__args, bool requiresOutput);

#endif