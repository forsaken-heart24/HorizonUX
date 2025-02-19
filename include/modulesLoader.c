#include "horizonutils.h"
#include "horizonux.h"

// prevents bastards from running any malicious commands
// this searches some sensitive strings to ensure that the script is safe
// please verify your scripts before running it PLEASE 🙏
int searchBlockListedStrings(const char *__fileName, const char *search_str) {
    FILE *file = fopen(__fileName, "r");
    if (!file) {
        perror("Error opening file");
        return 1;
    }
    char buffer[1024];
    while(fgets(buffer, sizeof(buffer), file)) {
        if(strstr(buffer, search_str)) {
            fclose(file);
            exit(0);
        }
    }
    fclose(file);
    return 0;
}


// this checks if the script has the +x module permission or not
// otherwise we skip the given script.
int verifyScriptExecutableStatusIntegrity(const char *__fileName) {
    struct stat st;
    return (stat(__fileName, &st) == 0) && (st.st_mode & S_IXUSR);
}

// yet another thing to protect good peoples from getting fucked
// this ensures that the chosen is a bash script and if it's not one
// it'll return 1 to make the program to stop executing that bastard
int verifyScriptStatusUsingShell(const char *__fileName) {
    FILE *__input = fopen(__fileName, "r");
    if(!__input) {
        fclose(__input);
        error_print("Failed to open the shell script file.");
        return 1;
    }
    char explainNowBitch[1028];
    snprintf(explainNowBitch, sizeof(explainNowBitch), "file %s | grep -q 'Bourne-Again shell script, ASCII text executable'", __fileName);
    int returnState = system(explainNowBitch);
    fclose(__input);
    return (returnState == 0) ? 0 : 1;
}