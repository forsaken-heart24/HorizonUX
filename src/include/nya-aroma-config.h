/////////////////// PREDEFINED VALUES FOR ROM PACKAGE, CHANGE STUFFS WITH PRIOR KNOWLEDGE ///////////////////

// rom codename:
char *codename = "Birds";

// rom buildID:
int buildID(void) {
    time_t now = time(NULL);
    struct tm *tm_info = localtime(&now);
    // date +"%Y%m%d"
    char buffer[9];
    strftime(buffer, sizeof(buffer), "%Y%m%d", tm_info);
    return atoi(buffer);
}

// rom maintainer / author:
char *mainAuth = "Luna";

// public device name (ex: POCO X3 NFC)
char *deviceName = "Galaxy A30";

// public release date for the rom:
char *releaseDate = "24-May-2008";

// flashing ahh idc
char *flashingStatusMessage = "Aroma is flashing the rom right now...";

// to: skip prompt. Anyways, this is meant to add user selectable options.
bool addUserSelectableBox = true;

// the number of checkboxes you want, max is 4
int numberOfCheckBoxes = 4;

// number of terms to flash:
// to flash two images, put 1 and vice versa
int numberOfFlashables = 1;

// supported device codenames: (ex: surya|karna)[case insensitive]
char *supportedDeviceCodenames = "surya|karna";

// index box config | dont change
char *selectbox[] = {"checkbox", "selectbox"};
// index box config | dont change 

// index box header:
char *indexHeader[] = {
    "Choose the Samsung services you want to install - first", // 1
    "Choose the Samsung services you want to install - second", // 2
    "Choose the Samsung services you want to install - third", // 3
    "Choose the Samsung services you want to install - fourth" // 4
};

// Option description:
char *flashableType[] = {"raw", "sparse"};

// Option source path from the zip file
char *flashSource[] = {"horizon/system.img", "horizon/vendor.img"};

// Option extraction path to the device:
char *filePath[] = {"/dev/block/by-name/system", "/dev/block/by-name/vendor"};

// font to use in the aroma installer
// be sure to have the font file (should be an truetype) in aroma_installer/META-INF/com/google/android/aroma/ttf/
char *fontName = "GoogleSansRegular";

//////////////////////////////////////////// index box - 1 /////////////////////////////////////
// number of options in the user selectable box:
// max is 9 (basically 10 per option)
// to have two options, put 1 and vice versa
int numberOfOptionsOne = 1;

// additional values will get ignored by the script, because it's the nature.
// Option names:
char *indexNameOne[] = {"IndexOneNameOne:", "IndexOneNameTwo"};

// Option description:
char *indexDescOne[] = {"IndexOneDeskOne:", "IndexOneDeskTwo:"};

// Option source path from the zip file
char *indexSourcePathOne[] = {"IndexOneSourceOne:", "IndexOneSourceTwo:"};

// Option extraction path to the device:
char *indexExtractionPathOne[] = {"IndexOneExtractOne:", "IndexOneExtractTwo:"};
//////////////////////////////////////////// index box - 1 /////////////////////////////////////

//////////////////////////////////////////// index box - 2 /////////////////////////////////////
// number of options in the user selectable box:
// max is 9 (basically 10 per option)
// to have two options, put 1 and vice versa
int numberOfOptionsTwo = 1;

// additional values will get ignored by the script, because it's the nature.
// Option names:
char *indexNameTwo[] = {"IndexTwoNameOne:", "IndexTwoNameTwo:"};

// Option description:
char *indexDescTwo[] = {"IndexTwoDeskOne:", "IndexTwoDeskTwo:"};

// Option source path from the zip file
char *indexSourcePathTwo[] = {"IndexTwoSourceOne:", "IndexTwoSourceTwo:"};

// Option extraction path to the device:
char *indexExtractionPathTwo[] = {"IndexTwoExtractOne:", "IndexTwoExtractTwo:"};
//////////////////////////////////////////// index box - 2 /////////////////////////////////////

//////////////////////////////////////////// index box - 3 /////////////////////////////////////
// number of options in the user selectable box:
// max is 9 (basically 10 per option)
// to have two options, put 1 and vice versa
int numberOfOptionsThree = 1;

// additional values will get ignored by the script, because it's the nature.
// Option names:
char *indexNameThree[] = {"IndexThreeNameOne:", "IndexThreeNameTwo:"};

// Option description:
char *indexDescThree[] = {"IndexThreeDeskOne:", "IndexThreeDeskTwo:"};

// Option source path from the zip file
char *indexSourcePathThree[] = {"IndexThreeSourceOne:", "IndexThreeSourceTwo:"};

// Option extraction path to the device:
char *indexExtractionPathThree[] = {"IndexThreeExtractOne:", "IndexThreeExtractTwo:"};
//////////////////////////////////////////// index box - 3 /////////////////////////////////////

//////////////////////////////////////////// index box - 4 /////////////////////////////////////
// number of options in the user selectable box:
// max is 9 (basically 10 per option)
// to have two options, put 1 and vice versa
int numberOfOptionsFour = 1;

// additional values will get ignored by the script, because it's the nature.
// Option names:
char *indexNameFour[] = {"IndexFourNameOne:", "IndexFourNameTwo:"};

// Option description:
char *indexDescFour[] = {"IndexFourDeskOne:", "IndexFourDeskTwo:"};

// Option source path from the zip file
char *indexSourcePathFour[] = {"IndexFourSourceOne:", "IndexFourSourceTwo:"};

// Option extraction path to the device:
char *indexExtractionPathFour[] = {"IndexFourExtractOne:", "IndexFourExtractTwo:"};
//////////////////////////////////////////// index box - 4 /////////////////////////////////////