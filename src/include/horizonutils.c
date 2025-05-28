//
// Copyright (C) 2025 Luna <luna.realm.io.bennett24@outlook.com>
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

#include <horizonutils.h>

int executeCommands(const char *command, const char *args[], bool requiresOutput) {
    for(int i = 0; args[i] != NULL; i++) {
        if(strstr(args[i], ";") || strstr(args[i], "&&") || strstr(args[i], "|") || strstr(args[i], "$(")) {
            fprintf(stderr, "executeCommands(): Malicious command detected: %s\n", args[i]);
            exit(1);
        }
    }
    if(command && (strstr(command, ";") || strstr(command, "&&") || strstr(command, "|") || strstr(command, "`") || strstr(command, "$(") || strstr(command, "dd"))) {
        fprintf(stderr, "executeCommands(): Malicious command detected %s\n", command);
        exit(1);
    }
    pid_t ProcessID = fork();
    switch(ProcessID) {
        case -1:
            fprintf(stderr, "executeCommands(): Failed to fork process.");
            return 1;
        break;
        case 0:
            if(!requiresOutput) {
                int devNull = open("/dev/null", O_WRONLY);
                if(devNull == -1) exit(EXIT_FAILURE);
                dup2(devNull, STDOUT_FILENO);
                dup2(devNull, STDERR_FILENO);
                close(devNull);
            }
            execvp(command, (char *const *)args);
            fprintf(stderr, "executeCommands(): Failed to execute command: %s\n", command);
            exit(EXIT_FAILURE);
        break;
        default:
            int status;
            wait(&status);
            return (WIFEXITED(status)) ? WEXITSTATUS(status) : 1;
    }
}

int executeScripts(const char *__script__file, const char *args[], bool requiresOutput) {
    for(int i = 0; args[i] != NULL; i++) {
        if(strstr(args[i], ";") || strstr(args[i], "&&") || strstr(args[i], "|") || strstr(args[i], "$(")) {
            fprintf(stderr, "executeScripts(): Malicious command detected: %s\n", args[i]);
            exit(1);
        }
    }
    pid_t ProcessID = fork();
    switch(ProcessID) {
        case -1:
            fprintf(stderr, "executeScripts(): Failed to fork process.");
            return 1;
        break;
        case 0:
            if(!requiresOutput) {
                int devNull = open("/dev/null", O_WRONLY);
                if(devNull == -1) exit(EXIT_FAILURE);
                dup2(devNull, STDOUT_FILENO);
                dup2(devNull, STDERR_FILENO);
                close(devNull);
            }
            execv(__script__file, (char *const *)args);
            fprintf(stderr, "executeScripts(): Failed to execute %s", __script__file);
            exit(EXIT_FAILURE);
        break;
        default:
            int status;
            wait(&status);
            return (WIFEXITED(status)) ? WEXITSTATUS(status) : 1;
    }
}

// prevents bastards from running any malicious commands
// this searches some sensitive strings to ensure that the script is safe
// please verify your scripts before running it PLEASE 🙏
int searchBlockListedStrings(const char *__filename, const char *__search_str) {
    size_t sizeOfTheseCraps = strlen(__filename) + strlen(__search_str) + 3;
    char *command = malloc(sizeOfTheseCraps);
    if(!command) {
        error_print("searchBlockListedStrings(): Failed to allocate memory.");
        exit(1);
    }
    snprintf(command, sizeOfTheseCraps, "grep -q '%s' '%s'", __search_str, __filename);
    FILE *file = popen(command, "r");
    free(command);
    if(!file) {
        error_print("searchBlockListedStrings(): Failed to open file.");
        return 1;
    }
    char haystack[1028];
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
// it'll return 1 to make the program to stop from executing that bastard
int verifyScriptStatusUsingShell(const char *__filename) {
    // use the size_t to avoid uncertain integer valyues:
    size_t commandLength = strlen(__filename) + strlen("file \"\" | grep -q 'ASCII text executable'") + 1;
    char *command = malloc(commandLength);
    if(!command) {
        fprintf(stderr, "verifyScriptStatusUsingShell(): Memory allocation failed.\n");
        return 1;
    }
    int written = snprintf(command, commandLength, "file \"%s\" | grep -q 'ASCII text executable'", __filename);
    if(written < 0 || (size_t)written >= commandLength) {
        fprintf(stderr, "verifyScriptStatusUsingShell(): Command truncation detected.\n");
        free(command);
        return 1;
    }
    // Prepare: prepare args for /bin/sh -c "command"
    const char *args[] = { "sh", "-c", command, NULL };
    // Update: executeCommands expects path + args[]
    free(command);
    return executeCommands("/bin/sh", args, false);
}

// Checks if a given string contains blacklisted substrings
int checkBlocklistedStringsNChar(const char *__haystack) {
    // Thnx Pranav 🩷
    static const char *blocklistedStrings[] = {
        "/xbl_config",
        "/fsc",
        "/fsg",
        "/modem",
        "/modemst1",
        "/modemst2",
        "/abl",
        "/keymaster",
        "/sda",
        "/sdb",
        "/sdc",
        "/sdd",
        "/sde",
        "/sdf",
        "/splash",
        "/dtbo",
        "/bluetooth",
        "/cust",
        "/xbl",
        "/persist",
        "/dev/block/bootdevice/by-name/",
        "/dev/block/by-name/",
        "/dev/block/",
        "blockdev",
        "--setrw",
        "/system/bin/dd",
        "/vendor/bin/dd",
        "/dd",
        "/boot",
        "/recovery",
        "/dev/block/mmcblk",
        "/dev/mmcblk"
    };
    size_t blocklistedStringArraySize = sizeof(blocklistedStrings) / sizeof(blocklistedStrings[0]);
    for(int i = 0; i < blocklistedStringArraySize; i++) {
        switch(searchBlockListedStrings(__haystack, blocklistedStrings[i])) {
            case 1:
                error_print_extended("checkBlocklistedStringsNChar(): Found Blocklisted string:", blocklistedStrings[i]);
                error_print("checkBlocklistedStringsNChar(): Stopping execution process...");
                return 1;
            default:
                continue;
        }
    }
    return 0;
}

bool erase_file_content(const char *__file) {
    FILE *fileConstantAgain = fopen(__file, "w");
    if(!fileConstantAgain) {
        return false;
    }
    fclose(fileConstantAgain);
    return true;
}

char *combineShyt(const char *command, const char *value) {
    size_t nom_nom = strlen(command) + strlen(value) + 2;
    char *buffer = (char *)malloc(nom_nom);
    if (!buffer) {
        error_print("combineShyt(): Failed to allocate memory.");
        exit(1);
    }
    snprintf(buffer, nom_nom, "%s %s", command, value);
    return buffer;
}

// idk what to do man :crying :flower :broken_heart
char *cStringToLower(char *str) {
    int i = 0;
    while(str[i]) {
        str[i] = tolower((unsigned char)str[i]);
        i++;
    }
    return str;
}

// idk what to do man :crying :flower :broken_heart
char *cStringToUpper(char *str) {
    int i = 0;
    while(str[i]) {
        str[i] = toupper((unsigned char)str[i]);
        i++;
    }
    return str;
}

// logs to console
void consoleLog(char *text, char *extr_factor) {
    FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
    if(!log4horizon) return;
    fprintf(log4horizon, "%s %s\n", text, extr_factor);
    fclose(log4horizon);
}

// throws messages and stops the instance.
void abort_instance(const char *text, const char *extr_factor) {
    error_print_extended(text, extr_factor);
    exit(1);
}

void error_print(const char *Message) {
    FILE *log4horizon = fopen(LOG4HORIZONFILE, "a");
    if(!log4horizon) {
        printf("\e[0;31merror_print(): Failed to open log file: %s\e[0;37m\n", LOG4HORIZONFILE);
        return;
    }
    fprintf(log4horizon, "%s\n", Message);
    fclose(log4horizon);
    fprintf(stderr, "\e[0;31m%s\e[0;37m\n", Message);
}

void error_print_extended(const char *message, const char *additional_args) {
    if(!message) {
        error_print("error_print_extended(): Message cannot be NULL!");
        return;
    }
    const char *safe_args = additional_args ? additional_args : "";
    size_t kimikimi_ = strlen(message) + strlen(safe_args) + 2;
    char *kimikimi = malloc(kimikimi_);
    if(!kimikimi) {
        error_print("error_print_extended(): Failed to allocate memory.");
        exit(1);
    }
    snprintf(kimikimi, kimikimi_, "%s %s", message, safe_args);
    error_print(kimikimi);
    free(kimikimi);
}