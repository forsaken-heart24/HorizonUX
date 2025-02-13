#include "horizonutils.h"
#include "horizonux.h"

bool DEBUG_MESSAGES_ARE_ENABLED = false;
bool WRITE_LOGS_INTO_A_FILE = false;
char *LOG4HORIZONFILE = "/sdcard/Horizon/changeToPeakRefreshRateifTheDeviceisInLockscreen.log";

int main() {
    int MaxRefreshRate = getPeakRefreshRate();
    if(screen_state()) {
        if(MaxRefreshRate > 60 && MaxRefreshRate <= 90) {
            executeCommands("settings put system peak_refresh_rate 90");
            executeCommands("settings put system min_refresh_rate 90");
        } 
        else if(MaxRefreshRate > 90 && MaxRefreshRate <= 120) {
            executeCommands("settings put system peak_refresh_rate 120");
            executeCommands("settings put system min_refresh_rate 120");
        } 
        else {
            printdbg("Weird device refresh rate, please send the log file (located in /sdcard/Horizon/changeToPeakRefreshRateifTheDeviceisInLockscreen.log) to @luna_project_bugreporter_bot in Telegram.");
        }
    }
}
