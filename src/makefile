#
# Copyright (C) 2025 Luna
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Compiler and flags
# COMPILER ?= gcc
COMPILER ?= aarch64-linux-gnu-gcc
EXTRA_FLAGS = -march=armv8-a

# Adjust flags if using GCC
ifeq ($(COMPILER),gcc)
    EXTRA_FLAGS =
endif

# Output binaries
UPDATER_OUTPUT = ../local_build/binaries/updater-script
LOADER_OUTPUT = ../local_build/binaries/bashScriptLoader

# Source files for each target
UPDATER_SRCS = ./include/horizonutils.c ./include/horizonux.c ./include/horizoninstaller.c 
LOADER_SRCS = ./include/horizonux.c ./include/horizonutils.c

# Main source path
UPDATER_MAIN = ./HorizonInstaller/main.c
LOADER_MAIN = ./bashScriptLoader/main.c

# Error logs path
ERR_LOG = ../local_build/logs/compiler__errors

# Default: Build both
all: test-updater test-loader

# Check if the compiler exists
check_compiler:
	@if ! command -v $(COMPILER) >/dev/null 2>&1; then \
	    echo "Error: '$(COMPILER)' not found. Please install '$(COMPILER)'"; \
	    exit 1; \
	fi

# Build updater-script
updater: check_compiler
	@echo "Building HorizonInstaller..."
	@if $(COMPILER) -I./include $(UPDATER_SRCS) $(UPDATER_MAIN) -o $(UPDATER_OUTPUT) $(EXTRA_FLAGS) > $(ERR_LOG) 2>&1; then \
	    echo "Build successful: $(UPDATER_OUTPUT)"; \
	else \
	    echo "Error: Compilation failed. Check $(ERR_LOG) for details."; \
	    exit 1; \
	fi

# Build mainModuleLoader
loader: check_compiler
	@echo "Building moduleLoader..."
	@if $(COMPILER) -I./include $(LOADER_SRCS) $(LOADER_MAIN) -o $(LOADER_OUTPUT) $(EXTRA_FLAGS) > $(ERR_LOG) 2>&1; then \
	    echo "Build successful: $(LOADER_OUTPUT)"; \
	else \
	    echo "Error: Compilation failed. Check $(ERR_LOG) for details."; \
	    exit 1; \
	fi

# Test updater-script
test_updater:
	@if [ ! -f "$(UPDATER_OUTPUT)" ]; then \
	    echo "Rebuilding $(UPDATER_OUTPUT)..."; \
	    $(MAKE) updater; \
	fi
	@echo "Testing updater-script..."
	@if $(UPDATER_OUTPUT) --test >/dev/null 2>&1; then \
	    echo "✅ Test passed: $(UPDATER_OUTPUT) works as expected!"; \
	else \
	    echo "❌ Test failed: $(UPDATER_OUTPUT) may not be compatible with this system."; \
	    echo "    Possible reasons:"; \
	    echo "                     - Running on a non-ARM machine"; \
	    echo "                     - Syntax Errors in the code"; \
	fi
	@rm -rf $(UPDATER_OUTPUT)

# Test mainModuleLoader
test_loader:
	@if [ ! -f "$(LOADER_OUTPUT)" ]; then \
	    echo "Rebuilding $(LOADER_OUTPUT)..."; \
	    $(MAKE) loader; \
	fi
	@echo "Testing bashScriptLoader..."
	@if $(LOADER_OUTPUT) --test >/dev/null 2>&1; then \
	    echo "✅ Test passed: $(LOADER_OUTPUT) works as expected!"; \
	else \
	    echo "❌ Test failed: $(LOADER_OUTPUT) may not be compatible with this system."; \
	    echo "    Possible reasons:"; \
	    echo "                     - Running on a non-ARM machine"; \
	    echo "                     - Syntax Errors in the code"; \
	fi
	@rm -rf $(LOADER_OUTPUT)

# Build and test everything
test: test_updater test_loader

# Clean up
clean:
	@rm -f $(UPDATER_OUTPUT) $(LOADER_OUTPUT) $(ERR_LOG)

.PHONY: all check_compiler updater loader test_updater test_loader test clean