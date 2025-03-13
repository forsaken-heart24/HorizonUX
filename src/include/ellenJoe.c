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
#define DEFAULT_PROP_FILE "/system/build.prop"

char *grep_prop(const char *variable_name, const char *prop_file) {
    if(!variable_name) return NULL;
    if(!prop_file) prop_file = DEFAULT_PROP_FILE;
    FILE *file = fopen(prop_file, "r");
    if (!file) return NULL;
    char line[256];
    char *value = NULL;
    while(fgets(line, sizeof(line), file)) {
        if(strncmp(line, variable_name, strlen(variable_name)) == 0 && line[strlen(variable_name)] == '=') {
            value = strdup(strchr(line, '=') + 1);
            if(value) {
                value[strcspn(value, "\r\n")] = 0;
            }
            break;
        }
    }
    fclose(file);
    return value;
}

int restartAudioServer() {
    // Wait for boot completion
    for(int i = 0; i < 5; i++) {
        if(isTheDeviceBootCompleted() && getSystemProperty("omg", "init.svc.audioserver")) {
            break;
        }
        usleep(1300000);  // 1.3 seconds
    }
    // Check if audioserver property exists
    char *audioServerState = getSystemProperty("omg", "init.svc.audioserver");
    if(audioServerState && strcmp(audioServerState, "") != 0) {
        executeCommands("setprop ctl.restart audioserver");
        usleep(200000);  // 0.2 seconds
        // Check if audioserver restarted
        if(strcmp(getSystemProperty("omg", "init.svc.audioserver"), "running") != 0) {
            char *audioserver_pid = getSystemProperty("omg", "init.svc_debug_pid.audioserver");
            if(audioserver_pid) {
                char killCommand[128];
                snprintf(killCommand, sizeof(killCommand), "kill -HUP %s", audioserver_pid);
                executeCommands(killCommand, false);
            }
            // Wait for audioserver to restart
            for(int i = 0; i < 10; i++) {
                usleep(200000);
                if(strcmp(getSystemProperty("omg", "init.svc.audioserver"), "running") == 0) {
                    break;
                }
                else if(i == 9) {
                    return 1;
                }
            }
        }
        return 0;
    }
    return 1;
}