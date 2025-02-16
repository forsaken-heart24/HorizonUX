#ifndef HORIZON_H
#define HORIZON_H

#include <string.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>

// FUCKING function FUCKING declarations.
bool is_boot_completed();
bool screen_state();
int getPeakRefreshRate();
int isPackageInstalled(const char *packageName);
int sendToastMessages(const char *service, const char *message);

#endif