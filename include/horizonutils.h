#ifndef HORIZONUTILS_H
#define HORIZONUTILS_H

#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

// FUCKING global FUCKING variables.
extern bool WRITE_DEBUG_MESSAGES_TO_CONSOLE;
extern char *LOG4HORIZONFILE;
 
// FUCKING function FUCKING declarations.
int error_print(const char *Message, bool addAnNewline);
bool erase_file_content(const char *__file);
int executeCommands(const char *command, bool requiresOutput);
int executeScripts(char *__script__file, char *__args, bool requiresOutput);

#endif