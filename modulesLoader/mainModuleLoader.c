#include "modulesLoader.h"
#include "horizonutils.h"

bool DEBUG_MESSAGES_ARE_ENABLED = false;
bool WRITE_LOGS_INTO_A_FILE = false;
char *LOG4HORIZONFILE = "/sdcard/horizon/modulesLoader.log";

int main() {
    if(mainModuleLoader("/horizon/haystack/modules/start.sh") => 1) {
        error_print("mainModuleLoader(): Seems like there's an problem with the script, it returned a exit state");
        error_print("mainModuleLoader(): please check the logs.");
        return 1;
    }
    return 0;
}