#include "horizonux.h"

bool is_boot_completed() {
    char content[4];
    FILE *getprop = popen("getprop sys.boot_completed", "r");
    if(!getprop) {
        return false;
    }
    if(fgets(content, sizeof(content), getprop) == NULL) {
        pclose(getprop);
        return false;
    }
    pclose(getprop);
    content[strcspn(content, "\n")] = '\0';
    return strcmp(content, "1") == 0;
}

bool screen_state() {
    FILE *fp = popen("dumpsys power | grep -q 'state=OFF' && echo 1", "r");
    if(!fp) return false;
    char buffer[2];
    bool screen_off = (fgets(buffer, sizeof(buffer), fp) != NULL && buffer[0] == '1');
    pclose(fp);
    return screen_off;
}

int getPeakRefreshRate() {
    char buffer[50];
    FILE *fp = popen("getprop persist.horizonux.device_max_refresh_rate", "r");
    if(!fp) {
        fp = popen("settings get global horizon_device_max_refresh_rate", "r");
        if(!fp)
            return 1;
    }
    if(fgets(buffer, sizeof(buffer), fp) == NULL) {
        pclose(fp);
        return -1;
    }
    pclose(fp);
    float refreshRate = strtof(buffer, NULL);
    return (int)refreshRate;
}