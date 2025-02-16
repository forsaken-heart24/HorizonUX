#include "horizonutils.h"
#include "horizonux.h"

bool DEBUG_MESSAGES_ARE_ENABLED = false;
bool WRITE_LOGS_INTO_A_FILE = false;
//char *LOG4HORIZONFILE = "/mnt/c/Users/Luna/Desktop/tst_log_changeToPeakRefreshRateifTheDeviceisInLockscreen.log";
char *LOG4HORIZONFILE = "/sdcard/Horizon/changeToPeakRefreshRateifTheDeviceisInLockscreen.log";

int main() {
    // let's clear the logs first.
    executeCommands("logcat -c");
    int MaxRefreshRate = getPeakRefreshRate();
    if(screen_state()) {
        if(MaxRefreshRate == 90) {
            executeCommands("settings put system peak_refresh_rate 90");
            executeCommands("settings put system min_refresh_rate 90");
        }
        else if(MaxRefreshRate == 120) {
            executeCommands("settings put system peak_refresh_rate 120");
            executeCommands("settings put system min_refresh_rate 120");
        }
        else if(MaxRefreshRate == -1) {
            error_print("Couldn't retrieve the device's peak refresh rate.");
            return 1;
        }
    }
    error_print("Unable to switch or detect the screen refresh rate of your device, please try again and be sure to report this issue.");
    return 1;
}