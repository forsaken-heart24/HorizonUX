#include "modulesLoader.h"
#include "horizonutils.h"
#include "horizonux.h"

// prevents bastards from running any malicious commands
// this searches some sensitive strings to ensure that the script is safe
// please verify your scripts before running it PLEASE 🙏
int searchBlockListedStrings(char *__filename, char *__search_str) {
    char haystack[1028];
    FILE *file = fopen(__filename, "r");
    while(fgets(haystack, sizeof(haystack), file)) {
        if(strstr(haystack, __search_str)) {
            fclose(file);
            error_print("Malicious code execution was detected in the script file");
            return 1;
        }
    }
    fclose(file);
    return 0;
}

// yet another thing to protect good peoples from getting fucked
// this ensures that the chosen is a bash script and if it's not one
// it'll return 1 to make the program to stop executing that bastard
int verifyScriptStatusUsingShell(char *__filename) {
    char explainNowBitch[1028];
    snprintf(explainNowBitch, sizeof(explainNowBitch), "file %s | grep -q 'ASCII text executable'", __filename);
    int returnState = system(explainNowBitch);
    return (returnState == 0) ? 0 : 1;
}

int mainModuleLoader(char *__haystack) {
    // int searchBlockListedStrings(const char *__fileName, const char *__search_str)
    int blocklistedStringArray = 16;
    char *blocklistedStrings[] = {
        "xbl_config",
        "fsc",
        "fsg",
        "modem",
        "modemst1",
        "modemst2",
        "abl",
        "abl_a",
        "abl_b",
        "/dev/block/bootdevice/by-name/",
        "/dev/block/by-name/",
        "/dev/block/",
        "blockdev",
        "--setrw",
        "/system/bin/dd",
        "/vendor/bin/dd",
        "dd"
    };
    if(verifyScriptStatusUsingShell(__haystack) == 1) {
        error_print("This file is not a ascii executable, please try again later with a ascii executable.");
        exit(1);
    }
    for(int i = 0; i < blocklistedStringArray; i++) {
        if(searchBlockListedStrings(__haystack, blocklistedStrings[i]) == 1) {
            return 1;
        }
    }
    // blud is highkey good asf
    // int executeScripts(char *__script__file, char *__args)
    return (executeScripts(__haystack, "--mango") == 0) ? 0 : 1;
}