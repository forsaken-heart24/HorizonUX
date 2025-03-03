#include "horizonux.h"
#include "horizonutils.h"

bool isTheDeviceBootCompleted() {
    //FILE *getprop = popen("/mnt/c/Users/Luna/Desktop/dumpsys.sh", "r"); intended for debugging purposes.
    FILE *getprop = popen("getprop sys.boot_completed", "r");
    // allocate if only it's required
    char content[4];
    fgets(content, sizeof(content), getprop);
    pclose(getprop);
    content[strcspn(content, "\n")] = '\0';
    return strcmp(content, "1") == 0;
}

bool isTheDeviceisTurnedOn() {
    //FILE *fp = popen("/mnt/c/Users/Luna/Desktop/dumpsys.sh", "r"); intended for debugging purposes.
    FILE *fp = popen("dumpsys power | grep 'Display Power' | awk '{print $3}' | cut -c 7-10", "r"); 
    char buffer[4];
    fgets(buffer, sizeof(buffer), fp);
    pclose(fp);
    if(strstr(buffer, "OFF") == 0) {
        return true;
    }
    else {
        return false;
    }
}

int getPeakRefreshRate() {
    //FILE *fp = popen("/mnt/c/Users/Luna/Desktop/dumpsys.sh", "r"); intended for debugging purposes.
    FILE *fp = popen("dumpsys 2>/dev/null | grep --line-buffered refresh-rate | head -n 1 | awk '{print $3}' | cut -d'.' -f1", "r");
    char buffer[50];
    fgets(buffer, sizeof(buffer), fp);
    pclose(fp);
    int refreshRate = 1;
    refreshRate = strtof(buffer, NULL);
    return refreshRate;
}

int isPackageInstalled(const char *packageName) {
    // Prevents command injection attempts
    if(strchr(packageName, ';') || strstr(packageName, "&&")) {
        error_print("isPackageInstalled(): Nice try diddy!");
        exit(1);
    }
    char command[50];
    snprintf(command, sizeof(command), "pm list packages | grep -q '^package:%s$'", packageName);
    return executeCommands(command, false) == 0;
}

int sendToastMessages(const char *service, const char *message) {
    // Prevents command injection attempts
    if(strchr(message, ';') || strstr(message, "&&")) {
        error_print("sendToastMessages(): Nice try diddy!");
        exit(1);
    }
    if(isPackageInstalled("bellavita.toast") == 0) {
        char toastTextWithArguments[1028];
        snprintf(toastTextWithArguments, sizeof(toastTextWithArguments), "am start -a android.intent.action.MAIN -e toasttext \"%s: %s\" -n bellavita.toast/.MainActivity", service, message);
        executeCommands(toastTextWithArguments, false);
    }
}

int manageBlocks(const char *infile, const char *outfile, size_t block_size, size_t count) {
    FILE *in = fopen(infile, "rb");
    FILE *out = fopen(outfile, "wb");
    if(!in) {
        error_print("manageBlocks(): Failed to open input file");
        return 1;
    }
    if(!out) {
        error_print("manageBlocks(): Failed to open output file");
        fclose(in);
        return 1;
    }
    char *buffer = (char *)malloc(block_size);
    if (!buffer) {
        error_print("manageBlocks(): Memory allocation failed");
        fclose(in);
        fclose(out);
        return 1;
    }
    size_t blocks_read, blocks_written;
    size_t total_read = 0, total_written = 0;
    for (size_t i = 0; i < count; i++) {
        blocks_read = fread(buffer, 1, block_size, in);
        // Stop if the EOF (end of file) is reached
        if(blocks_read == 0 && feof(in)) break;
        if(blocks_read == 0 && ferror(in)) {
            error_print("manageBlocks(): Error reading input file");
            break;
        }
        total_read += blocks_read;
        blocks_written = fwrite(buffer, 1, blocks_read, out);
        if(blocks_written < blocks_read) {
            error_print("manageBlocks(): Error writing to output file");
            break;
        }
        total_written += blocks_written;
    }
    //error_print("manageBlocks(): Copied %zu bytes (%.2f KB)\n", total_written, total_written / 1024.0);
    printf("manageBlocks(): Copied %zu bytes (%.2f KB)", total_written, total_written / 1024.0);
    free(buffer);
    fclose(in);
    fclose(out);
    return 0;
}