#include "horizonutils.h"

int touch(const char *__file) {
    FILE *file = fopen(__file, "a");
    if(!file) {
        return 1;
    }
    fclose(file);
    return 0;
}

int printdbg(const char *Message) {
    char actual_message[1028];
    snprintf(actual_message, sizeof(actual_message), "DEBUG_MESSAGE: %s", Message);
    if(DEBUG_MESSAGES_ARE_ENABLED) {
        if(WRITE_LOGS_INTO_A_FILE) {
            FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
            if(!log4horizon) { 
                LOG4HORIZONFILE = "/data/local/tmp/logs.log";
                log4horizon = fopen(LOG4HORIZONFILE, "a");
            }
            if(log4horizon) {
                fprintf(log4horizon, "%s\n", actual_message);
                fclose(log4horizon);
            }
        }
        else {
            printf("\033[0;31m%s\n", actual_message);
        }
    }
}

bool erase_file_content(const char *__file) {
    FILE *file = fopen(__file, "w");
    if(!file) {
        error_print("erase_file_content(): Error opening file to wipe its content.");
        return false;
    }
    fclose(file);
    return true;
}

bool check_device_status(const char *requiredState) {
    FILE *fp = NULL;
    if(strcmp(requiredState, "recovery") == 0 || strcmp(requiredState, "rcm") == 0) {
        fp = fopen("/sbin/recovery", "r");
    }
    if(fp != NULL) {
        fclose(fp);
        return true;
    }
    return false;
}

void executeCommands(const char *command, bool requiresOutput) {
    char buffer[1024];
    if(strstr(command, ";") || strstr(command, "&&")) {
        error_print("executeCommands(): Nice try diddy!");
        return;
    }
    FILE *fp = popen(command, "r");
    if(fp == NULL) {
        error_print("executeCommands(): Failed to run the given command, please contact the developer with the errors below.");
        return;
    }
    if(requiresOutput) {
        while(fgets(buffer, sizeof(buffer), fp) != NULL) {
            error_print(buffer);
        }
    }
    int __exit_status = pclose(fp);
    return (WIFEXITED(__exit_status)) ? WEXITSTATUS(__exit_status) : 1;
}

int executeScripts(char *__script__file, char *__args, bool requiresOutput) {
    char fuckingFileFuckingPath[256];
    char fuckingBufferFuckingShit[1024];
    if(strstr(__args, ";") || strstr(__args, "&&")) {
        error_print("executeScripts(): Nice try diddy!");
        return 0;
    }
    snprintf(fuckingFileFuckingPath, sizeof(fuckingFileFuckingPath), "%s %s", __script__file, __args);
    FILE *fp = popen(fuckingFileFuckingPath, "r");
    if(fp == NULL) {
        error_print("executeScripts(): Failed to run the given script\n");
        return 1;
    }
    if(requiresOutput) {
        while(fgets(fuckingBufferFuckingShit, sizeof(fuckingBufferFuckingShit), fp) != NULL) {
            error_print(fuckingBufferFuckingShit);
        }
    }
    int __exit_status = pclose(fp);
    return (WIFEXITED(__exit_status)) ? WEXITSTATUS(__exit_status) : 1;
}

int error_print(const char *Message) {
    FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
    if(!log4horizon) {
        LOG4HORIZONFILE = "/data/local/tmp/logs.log";
        log4horizon = fopen(LOG4HORIZONFILE, "a");
    }
    if(log4horizon) {
        erase_file_content(LOG4HORIZONFILE);
        if(DEBUG_MESSAGES_ARE_ENABLED == true) {
            printf("\e[0;31mError: %s\e[0;37m", Message);
        }
        else {
            char actual_message[1028];
            snprintf(actual_message, sizeof(actual_message), "Error: %s", Message);
            fprintf(log4horizon, "%s\n", actual_message);
            fclose(log4horizon);
        }
    }
}