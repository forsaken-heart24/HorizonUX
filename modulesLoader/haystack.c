#include "modulesLoader.h"
#include "horizonutils.h"

bool DEBUG_MESSAGES_ARE_ENABLED = false;
bool WRITE_LOGS_INTO_A_FILE = false;
char *LOG4HORIZONFILE = "/sdcard/modulesLoader.log";

int main() {
    mainModuleLoader("/horizon/haystack/modules/start.sh");
}