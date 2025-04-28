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

# Show help when no target is provided
ifeq ($(MAKECMDGOALS),)
	.DEFAULT_GOAL := help
endif

# Compiler and flags
ANDROID_NDK_CLANG_PATH := $(ANDROID_NDK_ROOT)/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android21-clang
STRIP_PATH := $(ANDROID_NDK_ROOT)/toolchains/llvm/prebuilt/linux-x86_64/bin/strip

# Output binaries
LOADER_OUTPUT = ./local_build/binaries/bashScriptLoader
SAVIOUR_OUTPUT = ./local_build/binaries/bootloopSaviour

# Source files for each target
LOADER_SRCS = ./src/include/horizonux.c ./src/include/horizonutils.c
SAVIOUR_SRCS = $(LOADER_SRCS)

# Main source path
LOADER_MAIN = ./src/bashScriptLoader/main.c
SAVIOUR_MAIN = ./src/bootloopSaviour/main.c

# Error logs path
ERR_LOG = ./local_build/logs/compiler__errors

# Default: Build both
all: loader bootloop_saviour

# Check if the compiler exists
check_compiler:
	@if [ ! -f "$(ANDROID_NDK_CLANG_PATH)" ]; then \
		echo "Error: Android clang is not found. Please install it."; \
		exit 1; \
	fi

# Build bashScriptLoader
loader: check_compiler
	@echo "Building bashScriptLoader..."
	@$(ANDROID_NDK_CLANG_PATH) -static -fPIE -pie -I./src/include $(LOADER_SRCS) $(LOADER_MAIN) -o $(LOADER_OUTPUT) 2> $(ERR_LOG) && \
	echo "✅ Build successful: $(LOADER_OUTPUT)" && \
	$(STRIP_PATH) $(LOADER_OUTPUT) || { \
		echo "❌ Error: Compilation failed. Check $(ERR_LOG) for details."; \
		exit 1; \
	}

# Build bootloopSaviour
bootloop_saviour: check_compiler
	@echo "Building bootloopSaviour..."
	@$(ANDROID_NDK_CLANG_PATH) -static -fPIE -pie -I./src/include $(SAVIOUR_SRCS) $(SAVIOUR_MAIN) -o $(SAVIOUR_OUTPUT) 2> $(ERR_LOG) && \
	echo "✅ Build successful: $(SAVIOUR_OUTPUT)" && \
	$(STRIP_PATH) $(SAVIOUR_OUTPUT) || { \
		echo "❌ Error: Compilation failed. Check $(ERR_LOG) for details."; \
		exit 1; \
	}

# Test mainModuleLoader
test_loader:
	@if [ -f "$(LOADER_OUTPUT)" ]; then \
		if "$(LOADER_OUTPUT)" --test >/dev/null 2>&1; then \
			echo "✅ Test passed: $(LOADER_OUTPUT) works as expected!"; \
		else \
			echo "❌ Test failed: $(LOADER_OUTPUT) may not be compatible with this system."; \
			echo "    Possible reasons:"; \
			echo "      - Running on a non-ARM machine"; \
			echo "      - Syntax Errors in the code"; \
		fi; \
	else \
		echo "❌ Error: $(LOADER_OUTPUT) not found. Building it..."; \
		$(MAKE) loader && $(MAKE) test_loader; \
	fi

# Test bootloopSaviour
test_bootloopsaviour:
	@if [ -f "$(SAVIOUR_OUTPUT)" ]; then \
		if "$(SAVIOUR_OUTPUT)" --test >/dev/null 2>&1; then \
			echo "✅ Test passed: $(SAVIOUR_OUTPUT) works as expected!"; \
		else \
			echo "❌ Test failed: $(SAVIOUR_OUTPUT) may not be compatible with this system."; \
			echo "    Possible reasons:"; \
			echo "      - Running on a non-ARM machine"; \
			echo "      - Syntax Errors in the code"; \
		fi; \
	else \
		echo "❌ Error: $(SAVIOUR_OUTPUT) not found. Building it..."; \
		$(MAKE) bootloop_saviour && $(MAKE) test_bootloopsaviour; \
	fi

# help menu:
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all                     Builds all components (loader and saviour together)"
	@echo "  loader                  Builds bashScriptLoader"
	@echo "  bootloop_saviour        Builds bootloopSaviour"
	@echo "  test                    Tests all buildable programs"
	@echo "  test_loader             Tests bashScriptLoader"
	@echo "  test_bootloopsaviour    Tests test_bootloopsaviour"
	@echo "  clean                   Cleans up build artifacts"
	@echo "  help                    Show this help message"

# Build and test everything
test: test_loader test_bootloopsaviour

# Clean up
clean:
	@rm -f $(LOADER_OUTPUT) $(SAVIOUR_OUTPUT) $(ERR_LOG)

.PHONY: all check_compiler loader test clean bootloop_saviour test_bootloopsaviour test_loader help