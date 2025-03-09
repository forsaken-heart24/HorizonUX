# Compiler and flags
# COMPILER ?= gcc
COMPILER ?= aarch64-linux-gnu-gcc
EXTRA_FLAGS = -march=armv8-a

# Adjust flags if using GCC
ifeq ($(COMPILER),gcc)
    EXTRA_FLAGS =
endif

# Output binaries
UPDATER_OUTPUT = updater-script
LOADER_OUTPUT = mainModuleLoader.elf

# Source files for each target
UPDATER_SRCS = ./include/horizonutils.c ./include/horizonux.c ./include/horizoninstaller.c ./HorizonInstaller/main.c
LOADER_SRCS = ./include/horizonutils.c ./include/modulesLoader.c ./modulesLoader/mainModuleLoader.c

# Error log
ERR_LOG = compiler__errors

# Default: Build both
all: check_compiler updater test-updater loader test-loader

# Check if the compiler exists
check_compiler:
	@if ! command -v $(COMPILER) >/dev/null 2>&1; then \
	    echo "Error: '$(COMPILER)' not found. Please install 'aarch64-linux-gnu-gcc' if targeting ARM."; \
	    exit 1; \
	fi

# Build updater-script
updater:
	@echo "Building HorizonInstaller..."
	@if $(COMPILER) -I./include $(UPDATER_SRCS) -o $(UPDATER_OUTPUT) $(EXTRA_FLAGS) > $(ERR_LOG) 2>&1; then \
	    echo "Build successful: $(UPDATER_OUTPUT)"; \
	else \
	    echo "Error: Compilation failed. Check $(ERR_LOG) for details."; \
	    exit 1; \
	fi

# Build mainModuleLoader
loader:
	@echo "Building moduleLoader..."
	@if $(COMPILER) -I./include $(LOADER_SRCS) -o $(LOADER_OUTPUT) $(EXTRA_FLAGS) > $(ERR_LOG) 2>&1; then \
	    echo "Build successful: $(LOADER_OUTPUT)"; \
	else \
	    echo "Error: Compilation failed. Check $(ERR_LOG) for details."; \
	    exit 1; \
	fi

# Test updater-script
test-updater: updater
	@echo "Testing updater-script..."
	@if [ ! -f "$(UPDATER_OUTPUT)" ]; then \
	    echo "Rebuilding $(UPDATER_OUTPUT)..."; \
	    $(MAKE) updater; \
	fi
	@if ./$(UPDATER_OUTPUT) --test >/dev/null 2>&1; then \
	    echo "✅ Test passed: $(UPDATER_OUTPUT) works as expected!"; \
	else \
	    echo "❌ Test failed: $(UPDATER_OUTPUT) may not be compatible with this system."; \
	    echo "    Possible reasons:"; \
	    echo "                     - Running on a non-ARM machine"; \
	    echo "                     - Syntax Errors in the code"; \
	fi
	@rm -rf $(UPDATER_OUTPUT)

# Test mainModuleLoader
test-loader: loader
	@echo "Testing moduleLoader..."
	@if [ ! -f "$(LOADER_OUTPUT)" ]; then \
	    echo "Rebuilding $(LOADER_OUTPUT)..."; \
	    $(MAKE) loader; \
	fi
	@if ./$(LOADER_OUTPUT) --test >/dev/null 2>&1; then \
	    echo "✅ Test passed: $(LOADER_OUTPUT) works as expected!"; \
	else \
	    echo "❌ Test failed: $(LOADER_OUTPUT) may not be compatible with this system."; \
	    echo "    Possible reasons:"; \
	    echo "                     - Running on a non-ARM machine"; \
	    echo "                     - Syntax Errors in the code"; \
	fi
	@rm -rf $(LOADER_OUTPUT)

# Build and test everything
test: test-updater test-loader

# Clean up
clean:
	rm -f $(UPDATER_OUTPUT) $(LOADER_OUTPUT) $(ERR_LOG)

.PHONY: all check_compiler updater loader test-updater test-loader test clean