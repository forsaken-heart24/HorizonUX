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
bool isTheDeviceBootCompleted();
bool isTheDeviceisTurnedOn();
int isPackageInstalled(const char *packageName);
int sendToastMessages(const char *service, const char *message);
int manageBlocks(const char *infile, const char *outfile, size_t block_size, size_t count);
void sendNotification(const char *message);

#endif