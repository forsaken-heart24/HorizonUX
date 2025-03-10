#include "modulesLoader.h"
#include "horizonutils.h"

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
// char *LOG4HORIZONFILE = "/mnt/c/Users/Luna/Desktop/teto.log";
char *LOG4HORIZONFILE = "/sdcard/HorizonUX/moduleLoader.log";

int main(int argc, const char *argv[]) {
    // for testing this bin
    if(strcmp((char *)argv[1], "--test") == 0) {
        printf("main(): Module Loader works!\n");
        return 0;
    }
    if(executeScriptsFromTheModuleDirectories()) {
        error_print("main(): The scripts were executed successfully!");
        return 0;
    }
    error_print("main(): The scripts failed to run, consider checking the logs.");
    return 1;
}