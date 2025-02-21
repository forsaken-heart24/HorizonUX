rm haystack.elf
gcc -I../include ../include/horizonutils.c ../include/modulesLoader.c haystack.c -o haystack.elf 2>errors_log
./haystack.elf
cat errors_log
cat /mnt/c/Users/Luna/Desktop/modulesLoader.log || cat /sdcard/Horizon/modulesLoader.log
rm haystack.elf