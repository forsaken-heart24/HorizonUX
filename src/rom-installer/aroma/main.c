#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>
#include <nya-aroma-config.h>

int help(char *execBinName) {
    printf("########################################################################\n");
    printf("   _  _     _   _            _                _   ___  __ \n");
    printf(" _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \\/ / \n");
    printf("|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  /  \n");
    printf("|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\  \n");
    printf("  |_||_|   |_| |_|\\___/|_|  |_/___\\___/|_| |_|\\___//_/\\_\\ \n");
    printf("                                                         \n");
    printf("########################################################################\n");
    printf("Usage: %s [OPTION]\n", execBinName);
    printf("Options:\n");
    printf("        --installer: Generates a installer.sh in the current working directory.\n");
    printf("        --aroma: Generates a aroma-config in the current working directory.\n");
    printf("\n");
    printf("Telegram: @forsaken_heart24 / Github: @forsaken-heart24\n");
    return 1;
}

int main(int argc, char *argv[]) {
    if(argc < 2) return help(argv[0]);
    if(numberOfCheckBoxes >= 5) {
        printf("\e[0;31mERROR: Excuse me, you've not supposed to put %d in numberOfCheckBoxes variable, it should be around 1 - 4 -- not %d.\e[0;37m\n", numberOfCheckBoxes, numberOfCheckBoxes);
    }
    if(strcmp(argv[1], "--aroma") == 0) {
        FILE *aromaConfig = fopen("./META-INF/com/google/android/aroma-config", "wb");
        if(!aromaConfig) {
            printf("\e[0;31mPlease either make \"META-INF/com/google/android/\" directory or simply execute this in the cloned dir (to be exact, im talking about HorizonUX/src/rom-installer/aroma/ directory)\e[0;37m\n");
            return 1;
        }
        fprintf(aromaConfig, "ini_set(\"force_colorspace\", \"rgba\");\n");
        fprintf(aromaConfig, "ini_set(\"rom_name\", \"HorizonUX\");\n");
        fprintf(aromaConfig, "ini_set(\"rom_version\", \"%s\");\n", codename);
        fprintf(aromaConfig, "ini_set(\"rom_author\", \"%s\");\n", mainAuth);
        fprintf(aromaConfig, "ini_set(\"rom_device\", \"%s\");\n", deviceName);
        fprintf(aromaConfig, "ini_set(\"rom_date\", \"%s\");\n", releaseDate);
        fprintf(aromaConfig, "splash(2000, \"a1\");\n");
        fprintf(aromaConfig, "fontresload(\"0\", \"ttf/%s.ttf\", \"11\");\n", fontName);
        fprintf(aromaConfig, "fontresload(\"1\", \"ttf/%s.ttf\", \"14\");\n", fontName);
        fprintf(aromaConfig, "theme(\"ics\");\n");
        fprintf(aromaConfig, "viewbox(\n");
        fprintf(aromaConfig, "    \"\",\n");
        fprintf(aromaConfig, "    \"This is Aroma Installer: \"+\n");
        fprintf(aromaConfig, "    \"<b><#selectbg_g>For HorizonUX</#></b>.\"+\n");
        fprintf(aromaConfig, "    \"It will help you to configure your Rom installation.\\n\\n\"+\n");
        fprintf(aromaConfig, "    \"Press <b>Next</b> to continue...\",\n");
        fprintf(aromaConfig, "    \"@install\"\n");
        fprintf(aromaConfig, ");\n");
        fprintf(aromaConfig, "agreebox(\n");
        fprintf(aromaConfig, "    \"\",\n");
        fprintf(aromaConfig, "    \"Please Read The Terms Of Use Carefully Below.\",\n");
        fprintf(aromaConfig, "    \"@license\",\n");
        fprintf(aromaConfig, "    resread(\"tc.txt\"),\n");
        fprintf(aromaConfig, "    \"I Agree with the Terms and Conditions\",\n");
        fprintf(aromaConfig, "    \"<@center>You must accept the terms and conditions</@>\"\n");
        fprintf(aromaConfig, ");\n");
        fprintf(aromaConfig, "textbox(\n");
        fprintf(aromaConfig, "    \"\",\n");
        fprintf(aromaConfig, "    \"ROM Changelog\",\n");
        fprintf(aromaConfig, "    \"@info\",\n");
        fprintf(aromaConfig, "    resread(\"changelogs.txt\")\n");
        fprintf(aromaConfig, ");\n");
        int selectboxIndex = 0;
        if(addUserSelectableBox) {
            for(int i = 0; i < numberOfCheckBoxes; i++) {
                if(i >= 2) selectboxIndex = 1;
                fprintf(aromaConfig, "%s(\n", selectbox[selectboxIndex]);
                fprintf(aromaConfig, "    \"\",\n");
                fprintf(aromaConfig, "    \"%s\",\n", indexHeader[i]);
                fprintf(aromaConfig, "    \"@apps\",\n");
                fprintf(aromaConfig, "    \"checkbox%d.prop\",\n", i);
                fprintf(aromaConfig, "    \"\", \"\", 2,\n");
                char **names = NULL;
                char **descs = NULL; 
                int size = 0;
                switch(i) {
                    case 0:
                        names = indexNameOne;
                        descs = indexDescOne;
                        size = sizeof(indexNameOne) / sizeof(indexNameOne[0]);
                    break;
                    case 1:
                        names = indexNameTwo;
                        descs = indexDescTwo;
                        size = sizeof(indexNameTwo) / sizeof(indexNameTwo[0]);
                    break;
                    case 2:
                        names = indexNameThree;
                        descs = indexDescThree;
                        size = sizeof(indexNameThree) / sizeof(indexNameThree[0]);
                    break;
                    case 3:
                        names = indexNameFour;
                        descs = indexDescFour;
                        size = sizeof(indexNameFour) / sizeof(indexNameFour[0]);
                    break;
                }
                for (int j = 0; j < size; j++) {
                    fprintf(aromaConfig, "    \"%s\", \"%s\", 0%s\n", names[j], descs[j], (j == size - 1) ? "" : ",");
                }
                fprintf(aromaConfig, ");\n");
            }
        }
        fprintf(aromaConfig, "setvar(\"retstatus\",\n");
        fprintf(aromaConfig, "  	install(\n");
        fprintf(aromaConfig, "      	\"\",\n");
        fprintf(aromaConfig, "      	\"%s\\n\"+\n", flashingStatusMessage);
        fprintf(aromaConfig, "      	\"@install\",\n");
        fprintf(aromaConfig, "      	\"Installation finished!\"\n");
        fprintf(aromaConfig, "  	)\n");
        fprintf(aromaConfig, ");\n");
        fclose(aromaConfig);
    }
    else if(strcmp(argv[1], "--installer") == 0) {
        FILE *updater_script = fopen("./META-INF/com/google/android/updater-script", "wb");
        if(!updater_script) {
            printf("\e[0;31mERROR: Please either make \"META-INF/com/google/android/\" directory or simply execute this in the cloned dir (to be exact, im talking about HorizonUX/src/rom-installer/aroma/ directory)\e[0;37m\n");
            return 1;
        }
        fprintf(updater_script, "# unpack busybox, util functions and stuff\n");
        fprintf(updater_script, "export TMPDIR=\"/dev/tmp\"\n");
        fprintf(updater_script, "export INSTALLER=\"$TMPDIR/install\"\n");
        fprintf(updater_script, "export OUTFD=\"$2\"\n");
        fprintf(updater_script, "export ZIPFILE=\"$3\"\n");
        fprintf(updater_script, "mkdir -p \"$INSTALLER\" || exit 1\n");
        fprintf(updater_script, "for file in scripts/util_functions.sh scripts/busybox; do\n");
        fprintf(updater_script, "    unzip -o \"${ZIPFILE}\" \"$file\" -d \"${INSTALLER}/\" || exit 1\n");
        fprintf(updater_script, "done\n\n");
        fprintf(updater_script, "# uhrm idk bro:\n");
        fprintf(updater_script, "chmod +x scripts/util_functions.sh\n\n");
        fprintf(updater_script, "# import the functions and variables.\nsource \"${INSTALLER}/scripts/util_functions.sh\"\n\n");
        fprintf(updater_script, "# put your flashable images list here:\n");
        fprintf(updater_script, "flashables=\"");
        for(int i = 0; i < numberOfFlashables; i++) fprintf(updater_script, "%s -> %s -> %s ", filePath[i], flashSource[i], flashableType[i]);
        fprintf(updater_script, "\"");
        fprintf(updater_script, "\n\n# device codename / model detection, better put your device's codename / model for checking it\n# the \"|\" works as a separator.\nsupportedDeviceCodenameList=\"%s\"", supportedDeviceCodenames);
        fprintf(updater_script, "\n\n# to check build id and abort if the id is older.\ncheckBuildID \"%d\"", buildID());
        fprintf(updater_script, "\n\n# now the real functions start!\nconsolePrint \"########################################################################\"");
        fprintf(updater_script, "\nconsolePrint \"   _  _     _   _            _                _   ___  __ \"");
        fprintf(updater_script, "\nconsolePrint \" _| || |_  | | | | ___  _ __(_)_______  _ __ | | | \\ \\/ / \"");
        fprintf(updater_script, "\nconsolePrint \"|_  ..  _| | |_| |/ _ \\| '__| |_  / _ \\| '_ \\| | | |\\  /  \"");
        fprintf(updater_script, "\nconsolePrint \"|_      _| |  _  | (_) | |  | |/ / (_) | | | | |_| |/  \\  \"");
        fprintf(updater_script, "\nconsolePrint \"  |_||_|   |_| |_|\\___/|_|  |_/___\\___/|_| |_|\\___//_/\\_\\ \"");
        fprintf(updater_script, "\nconsolePrint \"                                                         \"");
        fprintf(updater_script, "\nconsolePrint \"########################################################################\"");
        fprintf(updater_script, "\ngetprop ro.product.system.device | grep -qE \"${supportedDeviceCodenameList}\" || abort \"This build is made for ${supportedDeviceCodenameList} not for your device.\"");
        fprintf(updater_script, "\nunmountPartitions && consolePrint \"Successfully unmounted partitions!\" || abort \"Failed to unmount partitions, please try again after a reboot.\"");
        fprintf(updater_script, "\nconsolePrint \"Horizon - %s for %s | Built by %s\"", codename, deviceName, mainAuth);
        fprintf(updater_script, "\n[ \"$(acpi)\" -le \"35\" ] && abort \"Please atleast charge your device to 40%% to continue the installation\"");
        fprintf(updater_script, "\nset -- $flashables");
        fprintf(updater_script, "\nwhile [ \"$1\" ]; do");
        fprintf(updater_script, "\n    image=\"$1\"");
        fprintf(updater_script, "\n    shift");
        fprintf(updater_script, "\n    delimiter=\"$1\"");
        fprintf(updater_script, "\n    shift");
        fprintf(updater_script, "\n    target=\"$1\"");
        fprintf(updater_script, "\n    shift");
        fprintf(updater_script, "\n    shift");
        fprintf(updater_script, "\n    imageType=\"$1\"");
        fprintf(updater_script, "\n    shift");
        fprintf(updater_script, "\n    if [ \"$delimiter\" = \"->\" ]; then");
        fprintf(updater_script, "\n        consolePrint \"Patching $(basename \"${image}\" .img) image unconditionally...\"");
        fprintf(updater_script, "\n        installImages \"$image\" \"$target\" \"${imageType}\"");
        fprintf(updater_script, "\n    else");
        fprintf(updater_script, "\n        abort \"Error: Expected '->' but got '$delimiter'\"");
        fprintf(updater_script, "\n    fi");
        fprintf(updater_script, "\ndone");
        if(addUserSelectableBox) {
            fprintf(updater_script, "\nconsolePrint \"Handling aroma actions..\"");
            int arraySize;
            int propIndex = 0;
            char **loopIndexSourcePath = NULL;
            char **loopIndexExtractionPath = NULL;
            for(int k = 0; k < numberOfCheckBoxes; k++) {
                switch(k) {
                    case 0:
                        loopIndexSourcePath = indexSourcePathOne;
                        loopIndexExtractionPath = indexExtractionPathOne;
                        arraySize = sizeof(indexSourcePathOne) / sizeof(indexSourcePathOne[0]);
                        break;
                    case 1:
                        loopIndexSourcePath = indexSourcePathTwo;
                        loopIndexExtractionPath = indexExtractionPathTwo;
                        arraySize = sizeof(indexSourcePathTwo) / sizeof(indexSourcePathTwo[0]);
                        propIndex = 1;
                        break;
                    case 2:
                        loopIndexSourcePath = indexSourcePathThree;
                        loopIndexExtractionPath = indexExtractionPathThree;
                        arraySize = sizeof(indexSourcePathThree) / sizeof(indexSourcePathThree[0]);
                        propIndex = 2;
                        break;
                    case 3:
                        loopIndexSourcePath = indexSourcePathFour;
                        loopIndexExtractionPath = indexExtractionPathFour;
                        arraySize = sizeof(indexSourcePathFour) / sizeof(indexSourcePathFour[0]);
                        propIndex = 3;
                        break;
                }
                for(int m = 0; m < arraySize; m++) {
                    fprintf(updater_script, "\nif [ \"$(getAromaProp \"item.1.%d\" \"/tmp/checkbox%d.prop\")\" == \"1\" ]; then", m, propIndex);
                    fprintf(updater_script, "\n    unzip -o \"${ZIPFILE}\" \"%s\" \"${INSTALLER}/\"", loopIndexSourcePath[m]);
                    fprintf(updater_script, "\n    mv \"${INSTALLER}/%s\" \"%s\"", loopIndexSourcePath[m], loopIndexExtractionPath[m]);
                    fprintf(updater_script, "\nfi");
                }
            }
        }
        fprintf(updater_script, "\nconsolePrint \"                                              \"");
        fprintf(updater_script, "\nconsolePrint \"              ******       ******\"");
        fprintf(updater_script, "\nconsolePrint \"            **********   **********\"");
        fprintf(updater_script, "\nconsolePrint \"          ************* *************\"");
        fprintf(updater_script, "\nconsolePrint \"         *****************************\"");
        fprintf(updater_script, "\nconsolePrint \"         *****************************\"");
        fprintf(updater_script, "\nconsolePrint \"         *****************************\"");
        fprintf(updater_script, "\nconsolePrint \"          ***************************\"");
        fprintf(updater_script, "\nconsolePrint \"            ***********************\"");
        fprintf(updater_script, "\nconsolePrint \"              *******************\"");
        fprintf(updater_script, "\nconsolePrint \"                ***************\"");
        fprintf(updater_script, "\nconsolePrint \"                  ***********\"");
        fprintf(updater_script, "\nconsolePrint \"                    *******\"");
        fprintf(updater_script, "\nconsolePrint \"                      ***\"");
        fprintf(updater_script, "\nconsolePrint \"                       *\"");
        fprintf(updater_script, "\nconsolePrint \"Thank you dear user for considering my project\"");
        fprintf(updater_script, "\nconsolePrint \"let us know your thoughts on our official chat.\"");
        fclose(updater_script);
    }
    else if(strcmp(argv[1], "--test") == 0) {
        printf("ts pmo icl\n");
        return 0;
    }
    else {
        return help(argv[0]);
    }
    return 0;
}