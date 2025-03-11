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