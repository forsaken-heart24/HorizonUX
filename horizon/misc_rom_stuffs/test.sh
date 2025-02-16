rm changeToPeakRefreshRateifTheDeviceisInLockscreen.elf
gcc -I../../include/ ../../include/horizonutils.c ../../include/horizonux.c ./changeToPeakRefreshRateifTheDeviceisInLockscreen.c -o changeToPeakRefreshRateifTheDeviceisInLockscreen.elf 2>/mnt/c/Users/Luna/Desktop/tst_log_changeToPeakRefreshRateifTheDeviceisInLockscreen.log
./changeToPeakRefreshRateifTheDeviceisInLockscreen.elf
cat /mnt/c/Users/Luna/Desktop/tst_log_changeToPeakRefreshRateifTheDeviceisInLockscreen.log || cat /sdcard/Horizon/changeToPeakRefreshRateifTheDeviceisInLockscreen.log
rm changeToPeakRefreshRateifTheDeviceisInLockscreen.elf 