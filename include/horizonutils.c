#include "horizonutils.h"

void error_print(const char *Message) {
    if(WRITE_DEBUG_MESSAGES_TO_CONSOLE == true) {
        printf("\e[0;31m%s\e[0;37m\n", Message);
    }
    else {
        FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
        if(!log4horizon) {
            printf("\e[0;31merror_print(): Failed to open log file: %s\e[0;37m\n", LOG4HORIZONFILE);
            return;
        }
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
    if(!fileConstantAgain) {
        return false;
    }
    fclose(fileConstantAgain);
    return true;
}

int executeCommands(const char *command, bool requiresOutput) {
    if(strstr(command, ";") || strstr(command, "&&")) {
        error_print("executeCommands(): Nice try diddy!");
        exit(1);
    }
    FILE *fp = popen(command, "r");
    if(!fp) {
        error_print("executeCommands(): Failed to execute command.");
        return 1;
    }
    if(requiresOutput) {
        char buffer[1024];
        while(fgets(buffer, sizeof(buffer), fp) != NULL) {
            buffer[strcspn(buffer, "\n")] = '\0';  // Remove newline
            error_print_extended("executeCommands():", buffer);
        }
    }
    int __exit_status = pclose(fp);
    if(__exit_status == -1) {
        error_print("executeCommands(): Failed to close process.");
        return 1;
    }
    return (WIFEXITED(__exit_status)) ? WEXITSTATUS(__exit_status) : 1;
}

int executeScripts(char *__script__file, char *__args, bool requiresOutput) {
    if(__args && (strstr(__args, ";") || strstr(__args, "&&"))) {
        error_print("executeScripts(): Nice try diddy!");
        exit(1);
    }
    char fuckingFileFuckingPath[256];
    int written = snprintf(fuckingFileFuckingPath, sizeof(fuckingFileFuckingPath), "%s %s", __script__file, __args ? __args : "");
    if(written < 0 || written >= (int)sizeof(fuckingFileFuckingPath) - 1) {
        error_print("executeScripts(): Command truncation detected.");
        return 1;
    }
    FILE *scriptWithArguments = popen(fuckingFileFuckingPath, "r");
    if(!scriptWithArguments) {
        error_print("executeScripts(): Failed to execute script.");
        return 1;
    }
    if(requiresOutput) {
        char fuckingBufferFuckingShit[1024];
        while(fgets(fuckingBufferFuckingShit, sizeof(fuckingBufferFuckingShit), scriptWithArguments) != NULL) {
            fuckingBufferFuckingShit[strcspn(fuckingBufferFuckingShit, "\n")] = '\0';  // Remove newline
            error_print_extended("executeScripts():", fuckingBufferFuckingShit);
        }
    }
    int __exit_status = pclose(scriptWithArguments);
    if(__exit_status == -1) {
        error_print("executeScripts(): Failed to close process.");
        return 1;
    }
    return (WIFEXITED(__exit_status)) ? WEXITSTATUS(__exit_status) : 1;
}