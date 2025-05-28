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

#ifndef HORIZON_H
#define HORIZON_H

#include <string.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <unistd.h>

// FUCKING function FUCKING declarations.
int isPackageInstalled(const char *packageName);
int getSystemProperty__(const char *filepath, const char *propertyVariableName);
int maybeSetProp(const char *property, const char *expectedPropertyValue, const char *typeShyt);
int DoWhenPropisinTheSameForm(const char *property, const char *expectedPropertyValue);
int setprop(const char *property, const char *propertyValue);
bool isBootAnimationExited();
bool isTheDeviceBootCompleted();
bool isTheDeviceisTurnedOn();
bool bootanimStillRunning();
char *getSystemProperty(const char *filepath, const char *propertyVariableName);
char grep_prop(const char *string, const char *propFile);
void sendToastMessages(const char *service, const char *message);
void sendNotification(const char *message);
void prepareStockRecoveryCommandList(char *action, char *actionArg, char *actionArgExt);
void prepareTWRPRecoveryCommandList(char *action, char *actionArg, char *actionArgExt);
void startDaemon(const char *daemonName);
void stopDaemon(const char *daemonName);

#endif