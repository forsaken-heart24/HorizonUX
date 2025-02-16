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
    FILE *fp = popen("dumpsys power | grep 'Display Power: state=OFF' && echo 'W'", "r");
    if(!fp) return false;
    char buffer[2];
    if(fgets(buffer, sizeof(buffer), fp) == NULL) {
        pclose(fp);
        return false;
    }
    pclose(fp);
    return (strcmp(buffer, "W\n") == 0);
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
        return 1;
    }
    pclose(fp);
    float refreshRate = -1;
    refreshRate = strtof(buffer, NULL);
    return (int)refreshRate;
}

int isPackageInstalled(const char *packageName) {
    // Prevents command injection attempts
    if(strchr(packageName, ';') || strchr(packageName, '|') || strchr(packageName, '&')) {
        return 0;
    }
    char command[256];
    snprintf(command, sizeof(command), "pm list packages | grep -q '^package:%s$'", packageName);
    return system(command) == 0;
}

int sendToastMessages(const char *service, const char *message) {
    // Prevents command injection attempts
    if(strchr(message, ';') || strchr(message, '|') || strchr(message, '&')) {
        return 0;
    }
    char toastTextWithArguments[1028];
    if(isPackageInstalled("bellavita.toast") == 0) {
        snprintf(toastTextWithArguments, sizeof(toastTextWithArguments), "am start -a android.intent.action.MAIN -e toasttext \"%s: %s\" -n bellavita.toast/.MainActivity", service, message);
        executeCommands(toastTextWithArguments);
    }
}