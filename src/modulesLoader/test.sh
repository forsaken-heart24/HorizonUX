rm mainModuleLoader.elf errors_log /mnt/c/Users/Luna/Desktop/modulesLoader.log /sdcard/Horizon/modulesLoader.log
gcc -I../include ../include/horizonutils.c ../include/modulesLoader.c mainModuleLoader.c -o mainModuleLoader.elf 2>errors_log
./mainModuleLoader.elf
cat errors_log
cat /mnt/c/Users/Luna/Desktop/modulesLoader.log || cat /sdcard/Horizon/modulesLoader.log
rm mainModuleLoader.elf errors_log
