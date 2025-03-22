//
// Copyright (C) 2025 Luna
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

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
    if(command && (strstr(command, ";") || strstr(command, "&&") || strstr(command, "|") || strstr(command, "`") || strstr(command, "$("))) {
        error_print("executeScripts(): Nice try diddy!");
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

int executeScripts(const char *__script__file, const char *__args, bool requiresOutput) {
    if(__args && (strstr(__args, ";") || strstr(__args, "&&") || strstr(__args, "|") || strstr(__args, "`") || strstr(__args, "$("))) {
        error_print("executeScripts(): Nice try diddy.");
        exit(1);
    }
    char command[512];
    snprintf(command, sizeof(command), "'%s' %s", __script__file, __args ? __args : "");
    FILE *scriptWithArguments  = popen(command, "r");
    if(!scriptWithArguments) {
        error_print("executeScripts(): Failed to execute script.");
        return 1;
    }
    if(requiresOutput) {
        char fuckingBufferFuckingShit[2048];
        while(fgets(fuckingBufferFuckingShit, sizeof(fuckingBufferFuckingShit), scriptWithArguments) != NULL) {
            fuckingBufferFuckingShit[strcspn(fuckingBufferFuckingShit, "\n")] = '\0';
            error_print_extended("executeScripts():", fuckingBufferFuckingShit);
        }
    }
    int __exit_status = pclose(scriptWithArguments);
    if(__exit_status == -1) {
        error_print_extended("executeScripts(): Failed to close process. Error:", strerror(errno));
        return 1;
    }
    return (WIFEXITED(__exit_status)) ? WEXITSTATUS(__exit_status) : 1;
}

// prevents bastards from running any malicious commands
// this searches some sensitive strings to ensure that the script is safe
// please verify your scripts before running it PLEASE 🙏
int searchBlockListedStrings(const char *__filename, const char *__search_str) {
    char haystack[1028];
    FILE *file = fopen(__filename, "r");
    if(!file) {
        error_print("searchBlockListedStrings(): Failed to open file.");
        return 1;
    }
    while(fgets(haystack, sizeof(haystack), file) != NULL) {
        haystack[strcspn(haystack, "\n")] = '\0';
        if(strstr(haystack, __search_str) != NULL) {
            fclose(file);
            error_print("searchBlockListedStrings(): Malicious code execution detected in the script file.");
            return 1;
        }
    }
    fclose(file);
    return 0;
}

// yet another thing to protect good peoples from getting fucked
// this ensures that the chosen is a bash script and if it's not one
// it'll return 1 to make the program to stop executing that bastard
int verifyScriptStatusUsingShell(const char *__filename) {
    char command[150];
    int written = snprintf(command, sizeof(command), "file \"%s\" | grep -q 'ASCII text executable'", __filename);
    if(written < 0 || written >= sizeof(command)) {
        error_print("verifyScriptStatusUsingShell(): Command truncation detected.");
        return 1;
    }
    return executeCommands(command, false);
}

// Checks if a given string contains blacklisted substrings
int checkBlocklistedStringsNChar(const char *__haystack) {
    // Thnx Pranav 🩷
    static const char *blocklistedStrings[] = {
        "xbl_config",
        "xbl_config_a",
        "xbl_config_b",
        "fsc",
        "fsg",
        "modem",
        "modemst1",
        "modemst2",
        "abl",
        "abl_a",
        "abl_b",
        "keymaster",
        "keymaster_a",
        "keymaster_b",
        "sda",
        "sdb",
        "sdc",
        "sdd",
        "sde",
        "sdf",
        "splash",
        "dtbo",
        "dtbo_a",
        "dtbo_b",
        "bluetooth",
        "bluetooth_a",
        "bluetooth_b",
        "cust",
        "xbl_a",
        "xbl_b",
        "persist",
        "/dev/block/bootdevice/by-name/",
        "/dev/block/by-name/",
        "/dev/block/",
        "blockdev",
        "--setrw",
        "/system/bin/dd",
        "/vendor/bin/dd",
        "dd"
    };
    size_t blocklistedStringArraySize = sizeof(blocklistedStrings) / sizeof(blocklistedStrings[0]);
    for(size_t i = 0; i < blocklistedStringArraySize; i++) {
        if(searchBlockListedStrings(__haystack, blocklistedStrings[i]) == 1) {
            return 1;
        }
    }
    return 0;
}

char *combineShyt(const char *command, const char *value) {
    char *buffer = malloc(128);
    if (!buffer) return NULL;  // Handle memory allocation failure
    snprintf(buffer, 128, "%s %s", command, value);
    return buffer;
}

// logs to console
int consoleLog(char *text, char *extr_factor) {
    FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
    if(!log4horizon) return 1;
    fprintf(log4horizon, "%s %s\n", text, extr_factor);
    fclose(log4horizon);
    return 0;
}