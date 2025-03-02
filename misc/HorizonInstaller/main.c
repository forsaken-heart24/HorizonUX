#include "horizonux.h"
#include "horizonutils.h"
#include "HorizonInstaller.h"

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
const char *LOG4HORIZONFILE = "/sdcard/modulesLoader.log";
const char *INSTALLER_PATH = "/dev/tmp/install";
const char *ZIPFILE;
const char *OUTFD;

int main(int argc, const char *argv[]) {
    ZIPFILE = argv[4];
    snprintf(OUTFD, sizeof(OUTFD), "/proc/self/fd/%s", argv[3]);
}