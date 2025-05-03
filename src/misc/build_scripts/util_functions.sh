#!/usr/bin/env bash
#
# Copyright (C) 2025 Luna <luna.realm.io.bennett24@outlook.com>
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

# fix: ./src/misc/build_scripts/util_functions.sh: line 43: $thisConsoleTempLogFile : No such file or directory
thisConsoleTempLogFile="./local_build/logs/hux_build.log"
# fix: touch: cannot touch './local_build/logs/hux_build.log': No such file or directory
mkdir -p ./local_build/logs/
touch ./local_build/logs/hux_build.log

function grep_prop() {
    local variable_name="$1"
    local prop_file="$2"
    [[ -z "$variable_name" || -z "$prop_file" || ! -f "$prop_file" ]] && return 1
    grep -E "^${variable_name}=" "$prop_file" 2>>"$thisConsoleTempLogFile" | cut -d '=' -f2- | tr -d '"' || echo ""
}

function download_stuffs() {
    local link="$1"
    local save_path="$2"
    [[ -z "$link" || -z "$save_path" ]] && return 1
    if [ "$1" == "--skip" ]; then
        link="$2"
        save_path="$3"
        aria2c -x 8 -s 8 -o "${save_path}" "${link}" &>>$thisConsoleTempLogFile && return 0
        return 1
    else
        for ((tries = 1; tries <= 4; tries++)); do
            console_print "📥 Trying to download requested file | Attempt: $tries"
            if aria2c -x 8 -s 8 -o "${save_path}" "${link}" &>>"$thisConsoleTempLogFile"; then
                console_print "✅ Successfully downloaded file after $tries attempt(s)"
                return 0
            fi
            console_print "❌ Failed to download the file | Attempt: $tries"
        done
        abort "⚠️ Failed to download the file after $((tries - 1)) attempts."
    fi
}

function setprop() {
    local propFile
    local propVariableName="$2"
    local propValue="$3"
    if string_format --lower "$1" | grep -q "prism"; then
        propFile=${HORIZON_PRISM_PROPERTY_FILE}
    elif string_format --lower "$1" | grep -q "product"; then
        propFile=${HORIZON_PRODUCT_PROPERTY_FILE}
    elif string_format --lower "$1" | grep -q "system"; then
        propFile=${HORIZON_SYSTEM_PROPERTY_FILE}
    elif string_format --lower "$1" | grep -q "system_ext"; then
        propFile=${HORIZON_SYSTEM_EXT_PROPERTY_FILE}
    elif string_format --lower "$1" | grep -q "vendor"; then
        propFile=${HORIZON_VENDOR_PROPERTY_FILE}
    # setprop --custom "/vendor/odm/etc/build.prop" "ro.is_siam" "true"
    elif string_format --lower "$1" | grep -q "custom"; then
        propVariableName="$3"
        propValue="$4"
        propFile=$(if [ -f "$2" ]; then echo "$2"; else echo "$HORIZON_VENDOR_PROPERTY_FILE"; fi)
    fi
    awk -v pat="^${propVariableName}=" -v value="${propVariableName}=${propValue}" '{ if ($0 ~ pat) print value; else print $0; }' ${propFile} > ${propFile}.tmp
    mv ${propFile}.tmp ${propFile}
}

function abort() {
    echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] [:\e[0;36mABORT\e[0;37m:] -\e[0;31m $1\e[0;37m"
    debugPrint "$2(): $1"
    sleep 0.5
    tinkerWithCSCFeaturesFile --encode
    rm -rf $TMPDIR ./local_build/* output
    exit 1
}

function warns() {
    echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] / [:\e[0;36mWARN\e[0;37m:] / [:\e[0;32m$2\e[0;37m:] -\e[0;33m $1\e[0;37m"
    debugPrint "$1"
}

function console_print() {
    echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)\e[0;37m] / [:\e[0;36mMESSAGE\e[0;37m:] / [:\e[0;32mJOB\e[0;37m:] -\e[0;33m $1\e[0;37m"
}

function default_language_configuration() {
    if [ "${SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD}" == true ]; then
        debugPrint "default_language_configuration(): Changing default language...."

        # Convert to proper case
        local language=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        local country=$(echo "$2" | tr '[:lower:]' '[:upper:]')
        
        # Validate length (ISO 639-1 for language, ISO 3166-1 alpha-2 for country)
        [[ ! "$language" =~ ^[a-z]{2,3}$ ]] && abort "Invalid language code: $language" "default_language_configuration"
        [[ ! "$country" =~ ^[A-Z]{2,3}$ ]] && abort "Invalid country code: $country" "default_language_configuration"
        
        for EXPECTED_CUSTOMER_XML_PATH in $PRODUCT_DIR/omc/*/conf/customer.xml $OPTICS_DIR/configs/carriers/*/*/conf/customer.xml; do
            [ -f "$EXPECTED_CUSTOMER_XML_PATH" ] || continue
            # Skip modification if the values are already correct
            if grep -q "<DefLanguage>${language}-${country}</DefLanguage>" "$EXPECTED_CUSTOMER_XML_PATH" && grep -q "<DefLanguageNoSIM>${language}-${country}</DefLanguageNoSIM>" "$EXPECTED_CUSTOMER_XML_PATH"; then
                debugPrint "default_language_configuration(): Skipping $EXPECTED_CUSTOMER_XML_PATH (already set)"
                continue
            fi
            for languages in DefLanguage DefLanguageNoSIM; do
                change_xml_values "${languages}" "${language}-${country}" "$EXPECTED_CUSTOMER_XML_PATH"
            done
            debugPrint "default_language_configuration(): Updated default language in $EXPECTED_CUSTOMER_XML_PATH"
        done
    else
        debugPrint "default_language_configuration(): Skipping changing default language, reason: \"SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD\" set to ${SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD} instead of true"
        return 0;
    fi
}

function custom_setup_finished_messsage() {
    [ -z "${CUSTOM_SETUP_WELCOME_MESSAGE}" ] && CUSTOM_SETUP_WELCOME_MESSAGE="Welcome to HorizonUX"
    [ "${CUSTOM_SETUP_WELCOME_MESSAGE}" == "xxx" ] && CUSTOM_SETUP_WELCOME_MESSAGE="Welcome to HorizonUX"
    sed -i "s|<string name=\"outro_title\">.*</string>|<string name=\"outro_title\">&quot;${CUSTOM_SETUP_WELCOME_MESSAGE}&quot;</string>|" ./src/horizon/overlay_packages/sec_setup_wizard_horizonux_overlay/res/values/strings.xml
}

function build_and_sign() {
    local extracted_dir_path="$1"
    local app_path="$2"
    local apkFileName
    local signed_apk
    local apk_file

    # Common checks
    [[ ! -d "$extracted_dir_path" || ! -f "$extracted_dir_path/apktool.yml" ]] && abort "Invalid Apkfile path: $extracted_dir_path" "build_and_sign"

    # Extract APK file name from apktool.yml dynamically
    apkFileName=$(grep "apkFileName" "$extracted_dir_path/apktool.yml" | cut -d ':' -f 2 | tr -d ' "')
    apk_file="${extracted_dir_path}/dist/${apkFileName}"

    # Change compile SDK version and etc before build
    change_xml_values "compileSdkVersion" "${BUILD_TARGET_SDK_VERSION}" "${extracted_dir_path}/AndroidManifest.xml"
    change_xml_values "platformBuildVersionCode" "${BUILD_TARGET_SDK_VERSION}" "${extracted_dir_path}/AndroidManifest.xml" 
    change_xml_values "compileSdkVersionCodename" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/AndroidManifest.xml"
    change_xml_values "platformBuildVersionName" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/AndroidManifest.xml"
    change_yaml_values "minSdkVersion" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/apktool.yml"
    change_yaml_values "targetSdkVersion" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/apktool.yml"
    change_yaml_values "version" "${CODENAME_VERSION_REFERENCE_ID}" "${extracted_dir_path}/apktool.yml"
    change_yaml_values "versionName" "${CODENAME}" "${extracted_dir_path}/apktool.yml"
    change_yaml_values "versionCode" "${BUILD_TARGET_ANDROID_VERSION}" "${extracted_dir_path}/apktool.yml"

    # Build the package
    if java -jar ./src/dependencies/bin/apktool.jar build "$extracted_dir_path" &>>$thisConsoleTempLogFile; then
        debugPrint "Successfully built: $apkFileName"
    else
        abort "Apktool build failed for $extracted_dir_path" "build_and_sign"
    fi

    # Ensure built APK exists
    [ ! -f "$apk_file" ] && abort "No APK found in $extracted_dir_path/dist/" "build_and_sign"

    # Signing the APK
    if [[ -f "$MY_KEYSTORE_PATH" && -n $MY_KEYSTORE_ALIAS && -n $MY_KEYSTORE_PASSWORD && -n $MY_KEYSTORE_ALIAS_KEY_PASSWORD ]]; then
        signed_apk="$(java -jar ./src/dependencies/bin/signer.jar --apk "$apk_file" --ks "$MY_KEYSTORE_PATH" --ksAlias "$MY_KEYSTORE_ALIAS" --ksPass "$MY_KEYSTORE_PASSWORD" --ksKeyPass "$MY_KEYSTORE_ALIAS_KEY_PASSWORD" 2>>$thisConsoleTempLogFile | grep -oP 'src/.*?-aligned-debugSigned\.apk')"
    else
        signed_apk="$(java -jar ./src/dependencies/bin/signer.jar --apk "$apk_file" 2>>$thisConsoleTempLogFile | grep -oP 'src/.*?-aligned-debugSigned\.apk')"
    fi

    # Ensure signed APK exists
    [[ ! -f "$signed_apk" || -z "$signed_apk" ]] && abort "No signed APK found in $extracted_dir_path/dist/" "build_and_sign"

    # Move signed APK to target directory and do a cleanup
    mv "$signed_apk" "$app_path/"
    rm -rf "$extracted_dir_path/build" "$extracted_dir_path/dist/"
}

function catch_duplicates_in_xml() {
    [ ! -f "$2" ] && return 1
    grep -c "$1" "$2"
}

function add_float_xml_values() {
    local feature_code="$(string_format -u "$1")"
    local feature_code_value="$2"   

    # floating feature conf depending on SDK version:
    case "${BUILD_TARGET_SDK_VERSION}" in
        28|29|30)
            BUILD_TARGET_FLOATING_FEATURE_PATH="${VENDOR_DIR}/etc/floating_feature.xml"
        ;;
        31|32|33|34|35)
            BUILD_TARGET_FLOATING_FEATURE_PATH="${SYSTEM_DIR}/etc/floating_feature.xml"
        ;;
    esac

    # Check if the feature_code already exists in the XML file
    if [ "$(catch_duplicates_in_xml "${feature_code}" "${BUILD_TARGET_FLOATING_FEATURE_PATH}")" == 0 ]; then
        # Insert the new feature code into the XML under <SecFloatingFeatureSet>
        xmlstarlet ed \
            -L \
            -s "/SecFloatingFeatureSet" \
            -t elem \
            -n "${feature_code}" \
            -v "${feature_code_value}" \
            "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
    else
        # If the feature code already exists, call a function to modify the XML
        change_xml_values "${feature_code}" "${feature_code_value}" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
    fi
}

function add_csc_xml_values() {
    local feature_code
    feature_code="$1"
    local feature_code_value="$2"
    for EXPECTED_CSC_FEATURE_XML_PATH in $PRODUCT_DIR/omc/*/conf/cscfeature.xml $OPTICS_DIR/configs/carriers/*/*/conf/system/cscfeature.xml; do
        if [ -f "$EXPECTED_CSC_FEATURE_XML_PATH" ]; then
            if [ "$(catch_duplicates_in_xml "${feature_code}" "${EXPECTED_CSC_FEATURE_XML_PATH}")" == 0 ]; then
                xmlstarlet ed \
                    -L \
                    -s "/FeatureSet" \
                    -t elem \
                    -n "${feature_code}" \
                    -v "${feature_code_value}" \
                    "$EXPECTED_CSC_FEATURE_XML_PATH"
            else
                change_xml_values "${feature_code}" "${feature_code_value}" "${EXPECTED_CSC_FEATURE_XML_PATH}"
            fi
        fi
    done
}

function tinkerWithCSCFeaturesFile() {
    local action="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    local decoder_jar="./src/dependencies/bin/omc-decoder.jar"

    # Ensure decoder exists
    [ ! -f "$decoder_jar" ] && abort "Error: omc-decoder.jar not found!" "tinkerWithCSCFeaturesFile"

    # handle arg
    case "${action}" in
        --decode)
            for EXPECTED_CSC_FEATURE_XML_PATH in $PRODUCT_DIR/omc/*/conf/cscfeature.xml $OPTICS_DIR/configs/carriers/*/*/conf/system/cscfeature.xml; do
                debugPrint "tinkerWithCSCFeaturesFile(): File chosen: $EXPECTED_CSC_FEATURE_XML_PATH"
                [ -f "${EXPECTED_CSC_FEATURE_XML_PATH}" ] || continue
                [ -f "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml" ] || continue
                file "${EXPECTED_CSC_FEATURE_XML_PATH}" | grep -q data || continue
                if java -jar "$decoder_jar" -i "${EXPECTED_CSC_FEATURE_XML_PATH}" -o "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml" &>>$thisConsoleTempLogFile; then
                    debugPrint "tinkerWithCSCFeaturesFile(): CSC feature file successfully decoded: ${EXPECTED_CSC_FEATURE_XML_PATH}"
                else
                    abort "Failed to decode CSC manifest. Check logs for details." "tinkerWithCSCFeaturesFile"
                fi
            done
            debugPrint "CSC feature file(s) successfully decoded."
        ;;
        --encode)
            for EXPECTED_CSC_FEATURE_XML_PATH in $PRODUCT_DIR/omc/*/conf/cscfeature.xml $OPTICS_DIR/configs/carriers/*/*/conf/system/cscfeature.xml; do
                [ -f "${EXPECTED_CSC_FEATURE_XML_PATH}" ] || continue
                [ -f "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml" ] || continue
                file "${EXPECTED_CSC_FEATURE_XML_PATH}" | grep -q data && continue
                if java -jar "$decoder_jar" -e -i "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml" -o "${EXPECTED_CSC_FEATURE_XML_PATH}" &>>$thisConsoleTempLogFile; then
                    debugPrint "CSC feature file successfully encoded: ${EXPECTED_CSC_FEATURE_XML_PATH}"
                    rm -f "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml"
                else
                    abort "Failed to encode: ${EXPECTED_CSC_FEATURE_XML_PATH}. Check logs for details." "tinkerWithCSCFeaturesFile"
                fi
            done
        ;;
        *)
            abort "Usage: tinkerWithCSCFeaturesFile --decode | --encode" "tinkerWithCSCFeaturesFile"
        ;;
    esac
}

function change_xml_values() {
    local feature_code="$1"
    local feature_code_value="$2"
    local file="$3"

    # do checks and put ts shyt in log
    debugPrint "change_xml_values(): Arguments: $1 $2 $3"
    [ -z "$file" ] && abort "Error: No XML file specified!" "change_xml_values"
    [ ! -f "$file" ] && abort "Error: XML file '${file}' not found!" "change_xml_values"

    # Check if the feature code is already set to the desired value
    if xmlstarlet sel -t -v "count(//${feature_code}[text() = '${feature_code_value}'])" "$file" | grep -q '1'; then
        debugPrint "change_xml_values(): ${feature_code} is already set to ${feature_code_value}, skipping."
        return 0
    fi

    # If the feature code is an attribute (e.g., feature_code="value"), update it
    if xmlstarlet sel -t -v "count(//@${feature_code})" "$file" | grep -q '[1-9]'; then
        xmlstarlet ed -L -u "//*[@${feature_code}]" -v "${feature_code_value}" "$file"
        debugPrint "change_xml_values(): Updated ${feature_code} to ${feature_code_value} in $file"
    
    # If the feature code is an element (e.g., <feature_code>value</feature_code>), update it
    elif xmlstarlet sel -t -v "count(//${feature_code})" "$file" | grep -q '[1-9]'; then
        xmlstarlet ed -L -u "//${feature_code}" -v "${feature_code_value}" "$file"
        debugPrint "change_xml_values(): Updated <${feature_code}> value to ${feature_code_value} in $file"
    else
        debugPrint "change_xml_values(): No matching ${feature_code} found. Skipping modification."
    fi
}

function change_yaml_values() {
    local key="$1"
    local value="$2"
    local file="$3"

    # do checks and put ts shyt in log
    [ -z "$file" ] && abort "Error: No file specified!" "change_yaml_values"
    [ ! -f "$file" ] && abort "Error: File '$file' not found!" "change_yaml_values"
    debugPrint "change_yaml_values(): Arguments: $1 $2 $3"

    # ok lets go
    grep -Eq "^[[:space:]]*${key}:" "$file" && sed -i -E "s|(^[[:space:]]*${key}:)[[:space:]]*.*|\1 ${value}|" "$file"
}

function ask() {
    local question="$1"
    local answer
    printf "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)\e[0;37m] / [:\e[0;36mMESSAGE\e[0;37m:] / [:\e[0;32mJOB\e[0;37m:] -\e[0;33m $1\e[0;37m (y/n) : "
    read answer
    answer="$(echo "$answer" | tr '[:upper:]' '[:lower:]')"
    [[ "${answer}" == "y" || "${answer}" == "yes" ]]
}

function remove_attributes() {
    local INPUT_FILE="$1"
    local NAME_TO_SKIP="$2"

    debugPrint "remove_attributes(): Input file: ${INPUT_FILE}, Attribute to Skip: ${NAME_TO_SKIP}"

    # Validate input
    [ ! -f "$INPUT_FILE" ] && { debugPrint "remove_attributes(): Error: Input file not found!"; return 1; }
    [ -z "$NAME_TO_SKIP" ] && { debugPrint "remove_attributes(): Error: Attribute to skip was not provided"; return 1; }

    # Backup original
    cp "$INPUT_FILE" "${INPUT_FILE}.bak"

    # Use xmlstarlet to remove <hal> blocks with <name> equal to NAME_TO_SKIP
    xmlstarlet ed -P -L \
        -d "/manifest/hal[name='$NAME_TO_SKIP']" \
        "$INPUT_FILE"

    if cmp -s "$INPUT_FILE" "${INPUT_FILE}.bak"; then
        debugPrint "remove_attributes(): No changes made. <hal> with name=$NAME_TO_SKIP was not found."
        rm "${INPUT_FILE}.bak"
    else
        debugPrint "remove_attributes(): Updated XML saved to $INPUT_FILE, removed <hal> with name=$NAME_TO_SKIP."
        rm "${INPUT_FILE}.bak"
    fi
}

function ADD_THE_WALLPAPER_METADATA() {
    local value="$1" type="$2" index="$3"
    type="$(echo "$type" | tr '[:upper:]' '[:lower:]')"
    local filename="wallpaper_${value}.png"
    local path

    case "$type" in
        home)
            isDefault=true
            which=1
            the_homescreen_wallpaper_has_been_set=true
            ;;
        lock)
            isDefault=true
            which=2
            the_lockscreen_wallpaper_has_been_set=true
            ;;
        additional)
            isDefault=false
            which=1
            ;;
    esac

    cat >> resources_info.json << EOF
    {
        "isDefault": ${isDefault},
        "index": ${index},
        "which": ${which},
        "screen": 0,
        "type": 0,
        "filename": "${filename}",
        "frame_no": -1,
        "cmf_info": [""]
    }${special_symbol}
EOF

    debugPrint "User chose to make wallpaper_${value}.png as ${type} screen wallpaper."
    printf " - Enter the path to the default ${type^} wallpaper: "
    read path
    if [ -f "$path" ]; then
        debugPrint "[INDEX: $index | TYPE: $type] $path -> ./res/drawable-nodpi/${filename}"
        cp -af "$path" "./res/drawable-nodpi/${filename}"
    else
        abort "Wrong wallpaper image path, aborting this build..." "ADD_THE_WALLPAPER_METADATA"
    fi
    clear
}

function string_format() {
    case "$1" in
        -l|--lower)
            echo "$2" | tr '[:upper:]' '[:lower:]'
        ;;
        -u|--upper)
            echo "$2" | tr '[:lower:]' '[:upper:]'
        ;;
        *)
            echo "$2"
        ;;
    esac
}

function generate_random_hash() {
    local how_much="$1"
    local byte_count=$(( (how_much + 1) / 2 ))
    local hex=$(head -c "$byte_count" /dev/urandom | xxd -p | tr -d '\n')
    [[ $# -eq 1 ]] || abort "generate_random_hash(): Expected 1 argument, got $#" "generate_random_hash"
    debugPrint "generate_random_hash(): Requested random seed: ${how_much}"
    echo "${hex:0:how_much}"
}

function fetch_rom_arch() {
    if [[ ! -f "${SYSTEM_DIR}/lib/libbluetooth.so" && -f "${SYSTEM_DIR}/lib64/libbluetooth.so" && ${BUILD_TARGET_SDK_VERSION} -le "30" ]]; then
        [ "$1" == "--libpath" ] && echo "lib64"
    elif [[ ! -f "${SYSTEM_DIR}/lib/libbluetooth.so" && -f "${SYSTEM_DIR}/lib64/libbluetooth.so" && ${BUILD_TARGET_SDK_VERSION} -ge "31" ]]; then
        [ "$1" == "--libpath" ] && echo "lib64"
    else
        [ "$1" == "--libpath" ] && echo "lib"
    fi
}

function debugPrint() {
    if [ -n "${DEBUG_SCRIPT}" ]; then
        console_print "$@"
        sleep 0.5
    else
        echo "[$(date +%H:%M%p)] - $@" >> ${thisConsoleTempLogFile}
    fi
}

function apply_diff_patches() {
    local DiffPatchFile="$1"
    local TheFileToPatch="$2"
    [ "$#" -ne 2 ] && abort "Error: Missing arguments. Usage: apply_diff_patches <patch file> <target file>" "apply_diff_patches"
    if [ ! -f "$DiffPatchFile" ]; then
        debugPrint "apply_diff_patches(): Patch file '$DiffPatchFile' not found."
        abort "Error: Patch file '${DiffPatchFile}' not found." "apply_diff_patches"
    elif [ ! -f "$TheFileToPatch" ]; then
        debugPrint "apply_diff_patches(): Target file '$TheFileToPatch' not found."
        abort "Error: Target file '${TheFileToPatch}' not found." "apply_diff_patches"
    fi
    debugPrint "apply_diff_patches(): ${DiffPatchFile} → ${TheFileToPatch}"
    patch "$TheFileToPatch" < "$DiffPatchFile" &>>$thisConsoleTempLogFile || console_print "Patch failed! Check logs for details."
}

function check_build_prop() {
    [ -z "$1" ] && abort "Usage: check_build_prop <partition path>" "check_build_prop"
    [ -f "$1/build.prop" ] && echo "$1/build.prop"
    [ -f "$1/etc/build.prop" ] && echo "$1/etc/build.prop"
}

function download_glmodules() {
    # test internet connection before anything:
    check_internet_connection "GOODLOCK_MODULES" || return 1
    local i
    local SequenceValue
    local MaximumSDKVersion=35
    local MinimumSDKVersion=28

    case "${BUILD_TARGET_SDK_VERSION}" in
        28) SequenceValue=13 ;;
        29|33|35) SequenceValue=15 ;;
        30|31|32) SequenceValue=14 ;;
        34) SequenceValue=16 ;;
        *) warns "Unsupported SDK version, skipping the installation of goodlook modules..." "GOODLOCK_INSTALLER"; return 1; ;;
    esac

    for i in $(seq 0 $(($SequenceValue - 1))); do
        if [[ "${BUILD_TARGET_SDK_VERSION}" -ge "${MinimumSDKVersion}" && "${BUILD_TARGET_SDK_VERSION}" -le "${MaximumSDKVersion}" ]]; then
            case "${BUILD_TARGET_SDK_VERSION}" in
                28)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/28/${GOODLOOK_MODULES_FOR_28[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}/
                    fi
                ;;
                29)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/29/${GOODLOOK_MODULES_FOR_29[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}/
                    fi
                ;;
                30)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/30/${GOODLOOK_MODULES_FOR_30[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}/
                    fi
                ;;
                31)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/31/${GOODLOOK_MODULES_FOR_31[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}/
                    fi
                ;;
                32)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/32/${GOODLOOK_MODULES_FOR_32[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}/
                    fi
                ;;
                33)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/33/${GOODLOOK_MODULES_FOR_33[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}/
                    fi
                ;;
                34)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/34/${GOODLOOK_MODULES_FOR_34[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}/ 
                    fi
                ;;
                35)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}?"; then
                        mkdir -p ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/35/${GOODLOOK_MODULES_FOR_35[$i]} ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}/
                    else 
                        rmdir ./local_build/system/priv-app/${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}/
                    fi
                ;;
            esac
        fi
    done
}

function check_internet_connection() {
    ping -w 3 google.com &>/dev/null || warns "Please connect the computer to a wifi or an ethernet connection to access online facilities." "$(string_format -u $1)" && return 1
    return 0
}

function verify() {
    [ "$(sha512sum $1 | awk '{print $1}')" = "$2" ]
}

# needs fix actually.
function manageCameraFeatures() {
    local arg="$1"
    local featureName="$2"
    local extvalues="$3"
    local afterThisAttribute="$4"
    local XMLFile

    # handle args:
    if [ "${arg}" == "--add" ]; then
        XMLFile="$5"
        # First, remove any existing feature (to avoid conflicts)
        manageCameraFeatures --remove "${featureName}" "${XMLFile}"
        # Add new feature after the specified attribute
        xmlstarlet ed -L -s "//resources/*[name()='${afterThisAttribute}']" -t elem -n "${featureName}" -v "${extvalues}" "$XMLFile"
        echo "</resources>" >> "$XMLFile"  # Ensure the resources close tag is still added.
    elif [ "${arg}" == "--remove" ]; then
        XMLFile="$3"
        # Remove the feature from the XML
        xmlstarlet ed -L -d "//resources/*[name()='${featureName}']" "$XMLFile"
        echo "</resources>" >> "$XMLFile"  # Ensure the resources close tag is still added.
    fi
}

function parseBuildValues() {
    local file="$1"
    while IFS='=' read -r key value; do
        echo "$key ${value:-<empty>}"
    done < "$file"
}

function replaceTargetBuildProperties() {
    [[ "$BUILD_TARGET_REPLACE_REQUIRED_PROPERTIES" == true ]] || return 1
    local BUILD_TARGET="$1"
    local scope file key value
    console_print "Replacing properties for your device...."
    for entry in "vendor ./src/target/${BUILD_TARGET}/replaceableVendorProps.prop" "system ./src/target/${BUILD_TARGET}/replaceableSystemProps.prop"; do
        read -r scope file <<< "$entry"
        [[ ! -f "$file" || $(grep -c "nothing to replace" "$file") -ne 0 ]] && continue
        while read -r key value; do
            [[ "$scope" == "vendor" ]] && setprop --vendor "$key" "$value"
            [[ "$scope" == "system" ]] && setprop --system "$key" "$value"
        done < <(parseBuildValues "$file")
    done
}

# takes backup of the blob, restores only if they were not copied properly.
function copyDeviceBlobsSafely() {
    local blobFromSource="$1"
    local blobInROM="$2"
    local backupBlob="./local_build/tmp/hux/${blobInROM}.bak"
    console_print "Trying to copy ${blobFromSource} to ${blobInROM}"
    [ -f "$blobInROM" ] && cp -af "$blobInROM" "$backupBlob"; 
    if [ ! -f "$blobInROM" ] && ask "${blobFromSource} is not found on the ROM, do you wanna copy this blob to the device?"; then
        if ! cp -af "${blobFromSource}" "${blobInROM}" 2>>${thisConsoleTempLogFile}; then
            warns "Failed to copy ${blobFromSource}, this might cause a bootloop, attempting to restore original blob." "copyDeviceBlobsSafely()"
            [ -f "$backupBlob" ] && cp -af "$backupBlob" "$blobInROM"
        fi
    else
        if ! cp -af "${blobFromSource}" "${blobInROM}" 2>>"${thisConsoleTempLogFile}"; then
            warns "Failed to copy ${blobFromSource}, this might cause a bootloop, attempting to restore original blob." "copyDeviceBlobsSafely()"
            [ -f "$backupBlob" ] && cp -af "$backupBlob" "$blobInROM"
        fi
    fi
    console_print "Finished copying given blobs!"
    rm -f "$backupBlob"
}

function magiskboot() {
    local localMachineArchitecture=$(uname -m)
    case "${localMachineArchitecture}" in 
        "i686")
            ./src/dependencies/bin/magiskbootX32 "$@"
        ;;
        "x86_64")
            ./src/dependencies/bin/magiskbootX64 "$@"
        ;;
        "armv7l")
            ./src/dependencies/bin/magiskbootA32 "$@"
        ;;
        "aarch64"|"armv8l")
            ./src/dependencies/bin/magiskbootA64 "$@"
        ;;
        *)
            abort "Undefined architecture ${localMachineArchitecture}" "magiskboot"
        ;;
    esac
}

function avbtool() {
    python3 ./src/dependencies/bin/avbtool "$@"
}

# Thanks to salvo and ravindu for their amazing work!
function javaKeyStoreToHex() {
    # lky variables
    local keystoreFileNameString="$(generate_random_hash 30)"
    local keystorePemFileNameString="$(generate_random_hash 30)"
    local keystoreKeyFileNameString="$(generate_random_hash 30)"
    local hexKey
    
    # check up:
    command -v openssl >/dev/null 2>&1 || abort "openssl not found. Please install it." "javaKeyStoreToHex"
    command -v keytool >/dev/null 2>&1 || abort "keytool not found. Please install JDK." "javaKeyStoreToHex"

    # override if prebuilt key exists:
    if [ -f ${MY_KEYSTORE_PATH} ]; then
        if [ "$MY_KEYSTORE_PATH" == "./test-keys/HorizonUX-testkey.jks" ]; then
            console_print "PLEASE DONT USE THIS PUBLICALLY AVAILABLE KEY, GENERATE YOUR OWN KEY!!"
            ask "By using this key on your release builds, the release builds will become vulnerable. Do you want to continue?" || return 1
        fi
        keytool -exportcert -alias ${MY_KEYSTORE_ALIAS} -keystore ${MY_KEYSTORE_PATH} -storepass ${MY_KEYSTORE_PASSWORD} -rfc > ${keystoreKeyFileNameString}.x509.pem
        ( openssl x509 -inform PEM -in ${keystoreKeyFileNameString}.x509.pem -outform DER | xxd -p | tr -d '\n' ) > hex.key
        hexKey=$(cat hex.key)
        rm ${keystoreKeyFileNameString}.x509.pem hex.key
    else
        # main():
        openssl genrsa -out ${keystorePemFileNameString}.pem 2048
        openssl pkcs8 -in ${keystorePemFileNameString}.pem -topk8 -outform DER -out ${keystoreKeyFileNameString}.pk8 -nocrypt
        openssl req -new -x509 -key ${keystorePemFileNameString}.pem -out ${keystoreKeyFileNameString}.x509.pem -days 82435 -subj "/C=US/ST=Arizona/L=Scottsdale/O=Horizon/OU=HorizonUX_public/CN=Horizon/emailAddress=luna.realm.io.bennett24@outlook.com"
        ( openssl x509 -inform PEM -in ${keystoreKeyFileNameString}.x509.pem -outform DER | xxd -p | tr -d '\n' ) > hex.key
        hexKey=$(cat hex.key)
        rm ${keystorePemFileNameString}.pem hex.key ${keystoreKeyFileNameString}.pk8 ${keystoreKeyFileNameString}.x509.pem
    fi

    # changes the hex in the patch file:
    if [ "${BUILD_TARGET_SDK_VERSION}" == "34" ]; then
        sed -i 's|\(const-string v1, "\)[^"]*|\1'${hexKey}'|' ${DIFF_UNIFIED_PATCHES[36]}
    elif [ "${BUILD_TARGET_SDK_VERSION}" == "35" ]; then
        sed -i 's|\(const-string v1, "\)[^"]*|\1'${hexKey}'|' ${DIFF_UNIFIED_PATCHES[37]}
    else
        console_print "Signature patch is not available for this SDK version."
        return 1
    fi

    # error checks:
    if [ "$?" == 0 ]; then
        console_print "Successfully added your key into the patch file!!"
    else
        abort "Failed to add your key into the patch file!!" "javaKeyStoreToHex"
    fi
}

function addHorizonROMInfo() {
    # check:
    [ "${BUILD_TARGET_SDK_VERSION}" == "35" ] || return 1

    # internal variables, let's not break stuff yk.
    local input_file="$1"
    local output_file="$2"
    local needToAddAttrOnNextRun=false
    local runs=0

    # verify files:
    [[ -f "${input_file}" && -f "${output_file}" ]] || abort "usage: addHorizonROMInfo <input / stock xml> <output (can be anything)>" "addHorizonROMInfo"

    # nukes and recreates the output file
    rm -f $output_file
    touch $output_file

    # Reads line by line
    while IFS= read -r i || [[ -n "$i" ]]; do
        # "ahem"
        runs=$((runs + 1))
        debugPrint "at the $runs line of the xml"
        
        # Removes whitespaces:
        i=$(echo "$i" | sed 's/^[ \t]*//;s/[ \t]*$//')

        # adds whitelines:
        echo "$i" | grep -qE "http://schemas.android.com/apk/res/android|xmlns:android" && spacing="\t"
        echo "$i" | grep -q "</PreferenceScreen>" && spacing=""

        # Skips empty lines
        [ -z "$i" ] && continue

        # Sets flag if we are in the xmlns line so we can add the stuff.
        echo "$i" | grep -q "http://schemas.android.com/apk/res/android" && needToAddAttrOnNextRun=true

        # Writes current line
        echo -e "${spacing}$i" >> "$output_file"

        # Inserts block after xmlns line, only once
        if [ "$needToAddAttrOnNextRun" == true ]; then
            echo -e "\t<Preference android:title=\"Horizon Version &amp; Codename\" android:summary=\"v${CODENAME_VERSION_REFERENCE_ID} - ${CODENAME}\" android:key=\"horizonux_version\" />\n\t<Preference android:title=\"Your Device Maintainer\" android:summary=\"${BUILD_USERNAME} | Unmaintained / Unofficial Build\" android:key=\"horizonux_maintainer\" />\n\t<Preference android:title=\"OS Changelogs\" android:summary=\"View rom changelogs\" android:key=\"horizonux_changelogs\">\n\t<intent android:action=\"android.intent.action.VIEW\"\n\t\tandroid:data=\"http://github.com/forsaken-heart24/HorizonUX/changelogs/changelogs_placebo.html\" />\n\t</Preference>" >> $output_file
            needToAddAttrOnNextRun=false
        fi
    done < "$input_file"
}