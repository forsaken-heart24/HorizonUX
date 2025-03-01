#include "horizonutils.h"

void error_print(const char *Message) {
    if(WRITE_DEBUG_MESSAGES_TO_CONSOLE == true) {
        printf("\e[0;31m%s\e[0;37m\n", Message);
    }
    else {
        FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
        fprintf(log4horizon, "%s\n", Message);
        fclose(log4horizon);
    }
}

void error_print_extended(const char *message, const char *additional_args) {
    char premigga[200];
    snprintf(premigga, sizeof(premigga), "%s %s", message, additional_args);
    error_print(premigga);
}

bool erase_file_content(const char *__file) {
    FILE *fileConstantAgain = fopen(__file, "w");
    if(fclose(fileConstant) == 0) {
        return true;
    }
    return false;
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
            error_print_extended("executeCommands():", buffer);
        }
    }
    int __exit_status = pclose(fp);
    return (WIFEXITED(__exit_status)) ? WEXITSTATUS(__exit_status) : 1;
}

int executeScripts(char *__script__file, char *__args, bool requiresOutput) {
    if(strstr(__args, ";") || strstr(__args, "&&")) {
        error_print("executeScripts(): Nice try diddy!", true);
        exit(1);
    }
    char fuckingFileFuckingPath[256];
    snprintf(fuckingFileFuckingPath, sizeof(fuckingFileFuckingPath), "%s %s", __script__file, __args);
    FILE *scriptWithArguments = popen(fuckingFileFuckingPath, "r");
    if(requiresOutput) {
        char fuckingBufferFuckingShit[1024];
        while(fgets(fuckingBufferFuckingShit, sizeof(fuckingBufferFuckingShit), scriptWithArguments) != NULL) {
            error_print("executeScripts():", fuckingBufferFuckingShit);
        }
    }
    int __exit_status = pclose(scriptWithArguments);
    return (WIFEXITED(__exit_status)) ? WEXITSTATUS(__exit_status) : 1;
}