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
        printdbg("erase_file_content(): Error opening file to wipe its content.");
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

void executeCommands(const char *command) {
    char buffer[128];
    FILE *fp = popen(command, "r");
    if(fp == NULL) {
        printdbg("Failed to run the given command, please contact the developer with the errors below.");
        return;
    }
    while(fgets(buffer, sizeof(buffer), fp) != NULL) {
        buffer[strcspn(buffer, "\n")] = '\0';
        printdbg(buffer);
    }    
    pclose(fp);
}

int error_print(const char *Message) {
    char actual_message[1028];
    snprintf(actual_message, sizeof(actual_message), "Error: %s", Message);
    FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
    if(!log4horizon) {
        LOG4HORIZONFILE = "/data/local/tmp/logs.log";
        log4horizon = fopen(LOG4HORIZONFILE, "a");
    }
    if(log4horizon) {
        erase_file_content(LOG4HORIZONFILE);
        fprintf(log4horizon, "%s\n", actual_message);
        fclose(log4horizon);
    }
}