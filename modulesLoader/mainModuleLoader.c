#include "modulesLoader.h"
#include "horizonutils.h"

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
const char *LOG4HORIZONFILE = "/sdcard/modulesLoader.log";

int main() {
    if(executeScriptsFromTheModuleDirectories() == 0) {
        error_print("The Scripts were executed successfully!", true);
        return 0;
    }
    error_print("The scripts were failed to run, consider checking the logs", true);
    return 1;
}