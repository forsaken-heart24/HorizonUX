//
// Copyright (C) 2025 Luna
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#include "horizonux.h"
#include "horizonutils.h"
#define ellenExecPath "/system/bin/ellenJoe.sh"
#define bbTouchFixExecPath "/system/bin/brotherboard_touch_fix.sh"
bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
// char *LOG4HORIZONFILE = "/mnt/c/Users/Luna/Desktop/teto.log";
char *LOG4HORIZONFILE = "/sdcard/HorizonUX/moduleLoader.log";

int main(int argc, const char *argv[]) {
    if(argc >= 1) {
        if(strcmp(argv[1], "--ellen") == 0) {
            if(verifyScriptStatusUsingShell(ellenExecPath) == 0 && checkBlocklistedStringsNChar(ellenExecPath) == 0) {
                return executeScripts(ellenExecPath, "omagod", false);
            }
        }
        else if(strcmp(argv[1], "--brotherboard-touch-fix") == 0) {
            if(DoWhenPropisinTheSameForm("persist.horizonux.brotherboard.touch_fix", "available") == 0) {
                if(verifyScriptStatusUsingShell(bbTouchFixExecPath) == 0 && checkBlocklistedStringsNChar(bbTouchFixExecPath) == 0) {
                    return executeScripts(bbTouchFixExecPath, "omagod", false);
                }
            }
        }
        else if(strcmp(argv[1], "--clear-logs") == 0) {
            return executeCommands("logcat -c", false);
        }
        else if(strcmp(argv[1], "--test") == 0) {
            printf("main(): bashScriptLoader works!\n");
            return 0;
        }
    }
    return 1;
}