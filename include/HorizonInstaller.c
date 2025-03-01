#include "HorizonInstaller.h"

// returns bool acc. to the requested type.
bool check_installation_type(const char *requiredType, const char *zipPackage) {
    if(strstr(requiredType, zipPackage) == 0) {
        return true;
    }
    return false;
}


// returns true if thr shit is not encrypted/
bool checkInternalStorageStatus() {
    DIR *iPlayedTheseGamesBefore = opendir("/data/media");
    if(!iPlayedTheseGamesBefore) {
        return false;
    }
    return true;
}