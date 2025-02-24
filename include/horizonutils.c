#include "horizonutils.h"

int error_print(const char *Message) {
    FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
    if(log4horizon != NULL) {
        if(WRITE_DEBUG_MESSAGES_TO_CONSOLE == true) {
            printf("\e[0;31m%s\e[0;37m", Message);
        }
        else {
            char actual_message[1028];
            snprintf(actual_message, sizeof(actual_message), "Error: %s", Message);
            fprintf(log4horizon, "%s\n", actual_message);
            return 0;
        }
    }
    return 1;
}

bool erase_file_content(const char *__file) {
    FILE *fileConstant = fopen(__file, "r");
    if(!fileConstant) {
        error_print("erase_file_content(): Error opening file to wipe its content.");
        // just for safety.
        fclose(fileConstant);
        return false;
    }
    // close it and open it again in "w" mode.
    fclose(fileConstant);
    FILE *fileConstantAgain = fopen(__file, "w");
    fclose(fileConstant);
    return true;
}

int executeCommands(const char *command, bool requiresOutput) {
    if(strstr(command, ";") || strstr(command, "&&")) {
        error_print("executeCommands(): Nice try diddy!");
        exit(1);
    }
    FILE *fp = popen(command, "r");
    if(requiresOutput) {
        char buffer[1024];
        while(fgets(buffer, sizeof(buffer), fp) != NULL) {
            error_print(buffer);
        }
    }
    int __exit_status = pclose(fp);
    return (WIFEXITED(__exit_status)) ? WEXITSTATUS(__exit_status) : 1;
}

int executeScripts(char *__script__file, char *__args, bool requiresOutput) {
    if(strstr(__args, ";") || strstr(__args, "&&")) {
        error_print("executeScripts(): Nice try diddy!");
        exit(1);
    }
    char fuckingFileFuckingPath[256];
    snprintf(fuckingFileFuckingPath, sizeof(fuckingFileFuckingPath), "%s %s", __script__file, __args);
    FILE *scriptWithArguments = popen(fuckingFileFuckingPath, "r");
    if(requiresOutput) {
        char fuckingBufferFuckingShit[1024];
        while(fgets(fuckingBufferFuckingShit, sizeof(fuckingBufferFuckingShit), scriptWithArguments) != NULL) {
            error_print(fuckingBufferFuckingShit);
        }
    }
    int __exit_status = pclose(scriptWithArguments);
    return (WIFEXITED(__exit_status)) ? WEXITSTATUS(__exit_status) : 1;
}