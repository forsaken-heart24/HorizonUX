#ifndef HORIZONUTILS_H
#define HORIZONUTILS_H

#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

// FUCKING global FUCKING variables.
extern bool DEBUG_MESSAGES_ARE_ENABLED;
extern bool WRITE_LOGS_INTO_A_FILE;
extern char *LOG4HORIZONFILE;
 
// FUCKING function FUCKING declarations.
int touch(const char *__file);
int printdbg(const char *Message);
int error_print(const char *Message);
bool erase_file_content(const char *__file);
void executeCommands(const char *command, bool requiresOutput);
int executeScripts(char *__script__file, char *__args, bool requiresOutput);

#endif