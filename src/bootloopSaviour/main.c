#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <dirent.h>
#include <horizonux.h>
#include <horizonutils.h>

// ok
bool WRITE_DEBUG_MESSAGES_TO_CONSOLE = false;
char *LOG4HORIZONFILE = "/sdcard/Horizon/logs/horizon_bootloopSaviour.log";

void disableMagiskModules() {
    DIR *dirptr = opendir("/tmp/data/adb/modules/");
    if(!dirptr) {
        error_print("disableMagiskModules(): Failed to open directory!");
        exit(1);
    }
    struct dirent *entry;
    while((entry = readdir(dirptr)) != NULL) {
        if(entry->d_type == DT_DIR) {
            if(strcmp(entry->d_name, "..") == 0 || strcmp(entry->d_name, ".") == 0) {
                continue;
            }
            size_t trulimero_trulichina = strlen("/tmp/data/adb/modules/") + strlen(entry->d_name) + strlen("/disable") + 2;
            char *boneka_ambalabu = malloc(trulimero_trulichina);
            if(!boneka_ambalabu) {
                error_print("disableMagiskModules(): Failed to allocate memory, skipping...");
                continue;
            }
            if(snprintf(boneka_ambalabu, trulimero_trulichina, "/tmp/data/adb/modules/%s/disable", entry->d_name) >= trulimero_trulichina) {
                error_print("disableMagiskModules(): Truncated path, skipping...");
                free(boneka_ambalabu);
                continue;
            }
            FILE *file = fopen(boneka_ambalabu, "w");
            if(!file) {
                error_print("disableMagiskModules(): Failed to create disable file!");
            }
            else {
                fclose(file);
            }            
            free(boneka_ambalabu);
        }
    }
    closedir(dirptr);
    executeCommands("rm -rf /cache/.system_booting /data/unencrypted/.system_booting /metadata/.system_booting /persist/.system_booting /mnt/vendor/persist/.system_booting", false);
    executeCommands("reboot", false);
}

// ew i hate this
int main(int argc, char *argv[]) {
    if(argc > 1 && strcmp(argv[1], "--test") == 0) {
        printf("Hola! This is a test message from HorizonUX Bootloop Saviour.\n");
        return 0;
    }
    int zygote_pid = getSystemProperty__("hi", "init.svc_debug_pid.zygote");
    consoleLog("Sleeping for 5s to get the new or old zygote pid....", " ");
    sleep(5);
    int zygote_pid2 = getSystemProperty__("hi", "init.svc_debug_pid.zygote");
    consoleLog("Sleeping for 5s to get the new or old zygote pid....", " ");
    sleep(5);
    int zygote_pid3 = getSystemProperty__("hi", "init.svc_debug_pid.zygote");
    if(zygote_pid <= 1) {
        disableMagiskModules();
    }
    if(zygote_pid != zygote_pid2 || zygote_pid2 != zygote_pid3) {
        sleep(15);
        int zygote_pid4 = getSystemProperty__("hi", "init.svc_debug_pid.zygote");
        if(zygote_pid3 != zygote_pid4) {
            disableMagiskModules();
        }
    }
    return 0;
}