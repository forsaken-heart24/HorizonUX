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
ANDROID_NDK_ROOT =  /mnt/c/Luna/android_bin_toolchains/android-ndk-r27c
ANDROID_NDK_CLANG_PATH := $(ANDROID_NDK_ROOT)/toolchains/llvm/prebuilt/windows-x86_64/bin/aarch64-linux-android$(ANDROID_SDK_VERSION)-clang

# Output binaries
LOADER_OUTPUT = ./local_build/binaries/bashScriptLoader
SAVIOUR_OUTPUT = ./local_build/binaries/bootloopSaviour
AROMA_OUTPUT = ./local_build/binaries/aromaConfig

# Source files for each target
LOADER_SRCS = ./src/include/horizonux.c ./src/include/horizonutils.c
SAVIOUR_SRCS = $(LOADER_SRCS)

# Main source path
LOADER_MAIN = ./src/bashScriptLoader/main.c
SAVIOUR_MAIN = ./src/bootloopSaviour/main.c
AROMA_MAIN = ./src/aroma_installer/main.c

# Error logs path
ERR_LOG = ./local_build/logs/compilerErrors.log

# Default: Build both
all: loader bootloop_saviour aromaInstaller

# Check if the compiler exists
check_compiler:
	@if [ ! -f "$(ANDROID_NDK_CLANG_PATH)" ]; then \
		echo "Error: Android clang is not found. Please install it."; \
		exit 1; \
	fi

# Build bashScriptLoader
loader: check_compiler
	@rm -f $(ERR_LOG)
	@echo "Building bashScriptLoader..."
	@$(ANDROID_NDK_CLANG_PATH) -static -I./src/include $(LOADER_SRCS) $(LOADER_MAIN) -o $(LOADER_OUTPUT) >$(ERR_LOG) 2>&1 && \
	echo "✅ Build successful: $(LOADER_OUTPUT)" || echo "❌ Error: Compilation failed. Check $(ERR_LOG) for details.";

bootloop_saviour: check_compiler
	@rm -f $(ERR_LOG)
	@echo "Building bootloopSaviour..."
	@$(ANDROID_NDK_CLANG_PATH) -static -I./src/include $(SAVIOUR_SRCS) $(SAVIOUR_MAIN) -o $(SAVIOUR_OUTPUT) >$(ERR_LOG) 2>&1 && \
	echo "✅ Build successful: $(SAVIOUR_OUTPUT)" || echo "❌ Error: Compilation failed. Check $(ERR_LOG) for details.";

aromaInstaller: check_compiler
	@rm -f $(ERR_LOG)
	@echo "Building aromaInstaller..."
	@$(ANDROID_NDK_CLANG_PATH) -static -I./src/include $(AROMA_MAIN) -o $(AROMA_OUTPUT) >$(ERR_LOG) 2>&1 && \
	echo "✅ Build successful: $(AROMA_OUTPUT)" || echo "❌ Error: Compilation failed. Check $(ERR_LOG) for details.";

# Test mainModuleLoader
test_loader:
	@if [ -f "$(LOADER_OUTPUT)" ]; then \
		if "$(LOADER_OUTPUT)" --test >/dev/null 2>&1; then \
			echo "✅ Test passed: $(LOADER_OUTPUT) works as expected!"; \
		else \
			echo "❌ Test failed: $(LOADER_OUTPUT) may not be compatible with this system."; \
			echo "    Possible reasons:"; \
			echo "      - Running on a non-ARM machine"; \
			echo "      - Syntax Errors in the code (or) Build Failure"; \
		fi; \
	else \
		echo "❌ Error: $(LOADER_OUTPUT) not found. Building it..."; \
		$(MAKE) loader && $(MAKE) test_loader; \
	fi

# Test bootloopSaviour
test_bootloopsaviour:
	@if [ -f "$(AROMA_OUTPUT)" ]; then \
		if "$(AROMA_OUTPUT)" --test >/dev/null 2>&1; then \
			echo "✅ Test passed: $(AROMA_OUTPUT) works as expected!"; \
		else \
			echo "❌ Test failed: $(AROMA_OUTPUT) may not be compatible with this system."; \
			echo "    Possible reasons:"; \
			echo "      - Running on a non-ARM machine"; \
			echo "      - Syntax Errors in the code (or) Build Failure"; \
		fi; \
	else \
		echo "❌ Error: $(AROMA_OUTPUT) not found. Building it..."; \
		$(MAKE) bootloop_saviour && $(MAKE) test_bootloopsaviour; \
	fi

# Test aromaInstaller
test_aromaInstaller:
	@if [ -f "$(SAVIOUR_OUTPUT)" ]; then \
		if "$(SAVIOUR_OUTPUT)" --test >/dev/null 2>&1; then \
			echo "✅ Test passed: $(SAVIOUR_OUTPUT) works as expected!"; \
		else \
			echo "❌ Test failed: $(SAVIOUR_OUTPUT) may not be compatible with this system."; \
			echo "    Possible reasons:"; \
			echo "      - Running on a non-ARM machine"; \
			echo "      - Syntax Errors in the code (or) Build Failure"; \
		fi; \
	else \
		echo "❌ Error: $(SAVIOUR_OUTPUT) not found. Building it..."; \
		$(MAKE) aromaInstaller && $(MAKE) test_aromaInstaller; \
	fi

# help menu:
help:
	@echo "Usage: make ANDROID_SDK_VERSION=<sdk ver here> [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all                     Builds all components (loader, saviour, and aromaInstaller together)"
	@echo "  loader                  Builds bashScriptLoader"
	@echo "  bootloop_saviour        Builds bootloopSaviour"
	@echo "  aromaInstaller          Builds aromaInstaller"
	@echo "  test                    Tests all buildable programs"
	@echo "  test_loader             Tests bashScriptLoader"
	@echo "  test_bootloopsaviour    Tests bootloop saviour"
	@echo "  test_aromaInstaller     Tests aromaInstaller"
	@echo "  clean                   Cleans up build artifacts"
	@echo "  help                    Show this help message"

# Build and test everything
test: test_loader test_bootloopsaviour

# Clean up
clean:
	@rm -f $(LOADER_OUTPUT) $(SAVIOUR_OUTPUT) $(ERR_LOG)

.PHONY: all loader bootloop_saviour aromaInstaller test_bootloopsaviour test_loader test_aromaInstaller check_compiler test clean help