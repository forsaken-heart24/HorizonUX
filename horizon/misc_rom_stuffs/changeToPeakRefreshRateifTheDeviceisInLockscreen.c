#include "horizonutils.h"
#include "horizonux.h"

bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
char *LOG4HORIZONFILE = "/sdcard/Horizon/changeToPeakRefreshRateifTheDeviceisInLockscreen.log";

int main() {
    // let's clear the logs first.
    executeCommands("logcat -c");
    int MaxRefreshRate = getPeakRefreshRate();
    if(isTheDeviceisTurnedOn()) {
        if(MaxRefreshRate == 90) {
            executeCommands("settings put system peak_refresh_rate 90");
            executeCommands("settings put system min_refresh_rate 90");
        }
        else if(MaxRefreshRate == 120) {
            executeCommands("settings put system peak_refresh_rate 120");
            executeCommands("settings put system min_refresh_rate 120");
        }
        else {
            error_print("Couldn't retrieve the device's peak refresh rate.");
            return 1;
        }
    }
}