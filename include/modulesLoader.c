#include "modulesLoader.h"
#include "horizonutils.h"
#include "horizonux.h"

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

// Executes scripts from the module directory
bool executeScriptsFromTheModuleDirectories() {
    struct dirent *dirptr;
    DIR *base_dir = opendir("/data/hux/mods");
    if(!base_dir) {
        error_print("executeScriptsFromTheModuleDirectories(): Failed to open base module directory.");
        return false;
    }
    while((dirptr = readdir(base_dir)) != NULL) {
        if(!dirptr) {
            error_print("executeScriptsFromTheModuleDirectories(): Failed to read directory entry.");
            continue;
        }
        if(strcmp(dirptr->d_name, ".") == 0 || strcmp(dirptr->d_name, "..") == 0) {
            error_print("Skipping directory shortcuts...");
            continue;
        }
        char scriptPath[500];
        snprintf(scriptPath, sizeof(scriptPath), "/data/hux/mods/%s/start.sh", dirptr->d_name);
        if(verifyScriptStatusUsingShell(scriptPath) == 0 && checkBlocklistedStringsNChar(scriptPath) == 0) {
            if(executeScripts(scriptPath, NULL, true) != 0) {
                error_print_extended("executeScriptsFromTheModuleDirectories(): Failed to run", scriptPath);
            }
        }
    }
    closedir(base_dir);
    return true;
}