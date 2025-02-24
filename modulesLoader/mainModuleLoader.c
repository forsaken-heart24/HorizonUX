#include "modulesLoader.h"
#include "horizonutils.h"

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
char *LOG4HORIZONFILE = "/sdcard/horizon/modulesLoader.log";

int main() {
    if(mainModuleLoader("/horizon/haystack/modules/start.sh") == 1) {
        error_print("mainModuleLoader(): Seems like there's an problem with the script, it returned a exit state");
        error_print("mainModuleLoader(): please check the logs.");
        return 1;
    }
    return 0;
}