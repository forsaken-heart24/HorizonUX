![emergency_food](https://github.com/forsaken-heart24/i_dont_want_to_be_an_weirdo/blob/main/banner_images/emergency_food.png?raw=true)

# Cross-Compiling (arm64) | To compile:
```
cd HorizonUX/modulesLoader
command -v aarch64-linux-gnu-gcc || { echo " - Install aarch64-linux-gnu-gcc please"; exit 1; }
aarch64-linux-gnu-gcc -I../include ../include/horizonutils.c ../include/modulesLoader.c mainModuleLoader.c -o mainModuleLoader.elf -march=armv8-a
```

# Build Errors:
    - ignore the non-critical ones and drop a comment if it's critical

# Tinkering stuffs:
    - look into the code and mod it in your way, if you find any bugs please do a pull-request. Thanks :D