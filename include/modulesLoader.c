#include "modulesLoader.h"
#include "horizonutils.h"
#include "horizonux.h"

// prevents bastards from running any malicious commands
// this searches some sensitive strings to ensure that the script is safe
// please verify your scripts before running it PLEASE 🙏
int searchBlockListedStrings(char *__filename, char *__search_str) {
    char haystack[1028];
    FILE *file = fopen(__filename, "r");
    if(file != NULL) {
        while(fgets(haystack, sizeof(haystack), file)) {
            if(strstr(haystack, __search_str)) {
                fclose(file);
                error_print("searchBlockListedStrings(): Malicious code execution was detected in the script file");
                return 1;
            }
        }
        fclose(file);
        return 0;
    }
    return 1;
}

// yet another thing to protect good peoples from getting fucked
// this ensures that the chosen is a bash script and if it's not one
// it'll return 1 to make the program to stop executing that bastard
int verifyScriptStatusUsingShell(char *__filename) {
    char explainNowBitch[1028];
    snprintf(explainNowBitch, sizeof(explainNowBitch), "file %s | grep -q 'ASCII text executable'", __filename);
    int returnState = system(explainNowBitch);
    return returnState;
}

int checkBlocklistedStringsNChar(char *__haystack) {
    // Thnx Pranav 🩷
    char *blocklistedStrings[] = {
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
    int blocklistedStringArraySize = sizeof(blocklistedStrings) / sizeof(blocklistedStrings[0]);
    int return_status;
    for(int i = 0; i < blocklistedStringArraySize; i++) {
        return_status = searchBlockListedStrings(__haystack, blocklistedStrings[i]);
    }
    return return_status;
}

int mainModuleLoader(char *__haystack) {
    checkBlocklistedStringsNChar(__haystack);
    if(verifyScriptStatusUsingShell(__haystack) == 1) {
        error_print("mainModuleLoader(): This file is not a ascii executable, please try again with a ascii executable.");
        exit(1);
    }
    // blud is highkey good asf
    int __status = executeScripts(__haystack, "--mango", true);
    return __status;
}

// still not tested
void executeScriptsFromTheModuleDirectories() {
    struct dirent *dirptr;
    DIR *base_dir = opendir("/data/horizon/modules/");
    if(!base_dir) {
        perror("ERROR: Error opening base module directory.");
        exit(1);
    }
    while((dirptr = readdir(base_dir)) != NULL) {
        if(strcmp(dirptr->d_name, ".") == 0 || strcmp(dirptr->d_name, "..") == 0) {
            fprintf(stderr, "Skipping directory shortcuts...\n");
            continue;
        }
        char dirPath[1028];
        snprintf(dirPath, sizeof(dirPath), "/data/horizon/modules/%s", dirptr->d_name);
        struct stat path_stat;
        if(stat(dirPath, &path_stat) != 0 || !S_ISDIR(path_stat.st_mode)) {
            fprintf(stderr, "Skipping non-directory entry: %s\n", dirptr->d_name);
            continue;
        }
        char scriptPath[1028];
        snprintf(scriptPath, sizeof(scriptPath), "%s/start.sh", dirPath);
        if(access(scriptPath, F_OK) != 0 || access(scriptPath, X_OK) != 0) {
            fprintf(stderr, "Skipping non-existent or non-executable script: %s\n", scriptPath);
            continue;
        }
        if(executeScripts(scriptPath, NULL, false) != 0) {
            fprintf(stderr, "Failed to run %s\n", scriptPath);
            continue;
        }
    }
    closedir(base_dir);
}