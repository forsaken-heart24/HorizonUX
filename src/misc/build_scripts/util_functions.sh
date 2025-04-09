#!/usr/bin/env bash
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

function grep_prop() {
    local variable_name="$1"
    local prop_file="${2:-$SYSTEM_DIR/build.prop}"
    if [ -z "$variable_name" ] || [ -z "$prop_file" ]; then
        return 1
    fi
    if [ ! -f "$prop_file" ]; then
        echo "Error: Property file '$prop_file' not found." >&2
        return 1
    fi
    grep "^${variable_name}=" "$prop_file" | cut -d '=' -f 2- | tr -d '"' 2>>$thisConsoleTempLogFile
}

function download_stuffs() {
    local link="$1"
    local save_path="$2"
    [[ -z "$link" || -z "$save_path" ]] && return 1
    if [ "$1" == "--skip" ]; then
        link="$2"
        save_path="$3"
        aria2c -x 8 -s 8 -o "${save_path}" "${link}" &>>$thisConsoleTempLogFile
    else
        for ((tries = 1; tries <= 4; tries++)); do
            sendMessageToTelegramChat "📥 Trying to download: $link | Attempt: $tries"
            if aria2c -x 8 -s 8 -o "${save_path}" "${link}" &>>"$thisConsoleTempLogFile"; then
                sendMessageToTelegramChat "✅ Successfully downloaded file after $tries attempt(s)"
                return 0
            fi
            sendMessageToTelegramChat "❌ Failed to download the file | Attempt: $tries"
        done
        sendMessageToTelegramChat "⚠️ Failed to download the file after $((tries - 1)) attempts."
        exit 1
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
    if ! cat ${stacked_temp_properties} | grep ${propVariableName} | grep -q ${propValue}; then
        awk -v pat="^${propVariableName}=" -v value="${propVariableName}=${propValue}" '{ if ($0 ~ pat) print value; else print $0; }' ${propFile} > ${propFile}.tmp
        mv ${propFile}.tmp ${propFile}
    fi
}

function abort() {
    echo -e "\e[0;31m$1\e[0;37m"
    debugPrint "[:ABORT:] - $1"
    sleep 0.5
    tinkerWithCSCFeaturesFile --encode
    sendMessageToTelegramChat "Workflow failed"
    sendMessageToTelegramChat "Workflow ended at $(date +%I:%M%p --date='TZ="America/Mountain_Standard_Time"')"
    rm -rf $TMPDIR ${BUILD_TARGET_FLOATING_FEATURE_PATH}.bak ../local_build/* output
    uploadGivenFileToTelegram "${thisConsoleTempLogFile}"
    exit 1
}

function warns() {
    echo -e "[$2]: $1"
    debugPrint "[$(date +%d-%m-%Y) - $(date +%H:%M%p)] / [:WARN:] / [:$2:] - $1"
}

function console_print() {
    echo -e "$1"
}

function default_language_configuration() {
    if [ "${SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD}" == true ]; then
        debugPrint "Changing default language...."
    else
        console_print "Skipping changing default language, reason: \"SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD\" set to ${SWITCH_DEFAULT_LANGUAGE_ON_PRODUCT_BUILD} instead of true"
        return 0;
    fi
    # Default values
    [ -z "$language" ] && language="en"
    [ -z "$country" ] && country="US"
    # Convert to proper case
    language=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    country=$(echo "$2" | tr '[:lower:]' '[:upper:]')
    # Validate length (ISO 639-1 for language, ISO 3166-1 alpha-2 for country)
    if [[ ! "$language" =~ ^[a-z]{2,3}$ ]]; then
        abort "Invalid language code: $language"
    fi
    if [[ ! "$country" =~ ^[A-Z]{2,3}$ ]]; then
        abort "Invalid country code: $country"
    fi
    for EXPECTED_CUSTOMER_XML_PATH in $HORIZON_PRODUCT_DIR/omc/*/conf/customer.xml $HORIZON_OPTICS_DIR/configs/carriers/*/*/conf/customer.xml; do
        [ -f "$EXPECTED_CUSTOMER_XML_PATH" ] || continue
        # Skip modification if the values are already correct
        if grep -q "<DefLanguage>${language}-${country}</DefLanguage>" "$EXPECTED_CUSTOMER_XML_PATH" && grep -q "<DefLanguageNoSIM>${language}-${country}</DefLanguageNoSIM>" "$EXPECTED_CUSTOMER_XML_PATH"; then
            debugPrint "Skipping $EXPECTED_CUSTOMER_XML_PATH (already set)"
            continue
        fi
        sed -i "s|<DefLanguage>[^<]*</DefLanguage>|<DefLanguage>${language}-${country}</DefLanguage>|g" "$EXPECTED_CUSTOMER_XML_PATH" 2>>"$thisConsoleTempLogFile"
        sed -i "s|<DefLanguageNoSIM>[^<]*</DefLanguageNoSIM>|<DefLanguageNoSIM>${language}-${country}</DefLanguageNoSIM>|g" "$EXPECTED_CUSTOMER_XML_PATH" 2>>"$thisConsoleTempLogFile"
        debugPrint "Updated default language in $EXPECTED_CUSTOMER_XML_PATH"
    done
}

function custom_setup_finished_messsage() {
    [ -z "${CUSTOM_SETUP_WELCOME_MESSAGE}" ] && CUSTOM_SETUP_WELCOME_MESSAGE="Welcome to HorizonUX"
    [ "${CUSTOM_SETUP_WELCOME_MESSAGE}" == "xxx" ] && CUSTOM_SETUP_WELCOME_MESSAGE="Welcome to HorizonUX"
    sed -i 's|<string name="outro_title">.*</string>|<string name="outro_title">&quot;${CUSTOM_SETUP_WELCOME_MESSAGE}&quot;</string>|' ./horizon/overlay_packages/sec_setup_wizard_horizonux_overlay/res/values/strings.xml
}

function build_and_sign() {
    local extracted_dir_path="$1"
    local app_path="$2"
    local apkFileName
    local signed_apk
    local apk_file

    # Common checks
    if [[ ! -d "$extracted_dir_path" || ! -f "$extracted_dir_path/apktool.yml" ]]; then
        abort "Invalid Apkfile path: $extracted_dir_path"
    fi

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
    mkdir -p "$extracted_dir_path/dist/"
    if java -jar ./dependencies/bin/apktool.jar build "$extracted_dir_path" &>>"$thisConsoleTempLogFile"; then
        debugPrint "Successfully built: $apkFileName"
    else
        abort "Apktool build failed for $extracted_dir_path"
    fi

    # Ensure built APK exists
    [ ! -f "$apk_file" ] && abort "No APK found in $extracted_dir_path/dist/"

    # Signing the APK
    if [[ -f "$MY_KEYSTORE_PATH" && -n $MY_KEYSTORE_ALIAS && -n $MY_KEYSTORE_PASSWORD && -n $MY_KEYSTORE_ALIAS_KEY_PASSWORD ]]; then
        java -jar ./dependencies/bin/signer.jar --apk "$apk_file" --ks "$MY_KEYSTORE_PATH" --ksAlias "$MY_KEYSTORE_ALIAS" --ksPass "$MY_KEYSTORE_PASSWORD" --ksKeyPass "$MY_KEYSTORE_ALIAS_KEY_PASSWORD" &>>"$thisConsoleTempLogFile"
    else
        warns "NOTE: You are using Uber test-key! This is not safe for public builds. Use your own key!" "TEST_KEY_WARNS"
        java -jar ./dependencies/bin/signer.jar --apk "$apk_file" &>>"$thisConsoleTempLogFile"
    fi

    # Check if the signed APK exists
    signed_apk=$(find "$extracted_dir_path/dist/" -type f -name "${apk_base_name}*-debugSigned.apk" | head -n 1)
    [ ! -f "$signed_apk" ] && abort "No signed APK found in $extracted_dir_path/dist/"

    # Move signed APK to target directory and do a cleanup
    mv "$signed_apk" "$app_path/"
    rm -rf "$extracted_dir_path/build" "$extracted_dir_path/dist/"
}

function catch_duplicates_in_xml() {
    local feature_code="$1"
    local file="$2" 
    
    # Convert feature_code to uppercase
    feature_code="$(echo "${feature_code}" | tr '[:lower:]' '[:upper:]')"

    # Initialize count
    count=0
    
    # Count occurrences of the feature_code in the file
    while IFS= read -r line; do
        if echo "$line" | grep -q "${feature_code}"; then
        count=$((count + 1))
        fi
    done < "${file}"
    
    # no need to explain tbh
    echo "${count}"
}

function add_float_xml_values() {
    local feature_code="$(string_format -u "$1")"
    local feature_code_value="$2"
    
    # check if we have duplicates or not, if we have anything extra, call the catch_duplicates_in_xml to do the job lol.
    if [ "$(catch_duplicates_in_xml "${feature_code}" "${BUILD_TARGET_FLOATING_FEATURE_PATH}")" == "0" ]; then
        {
            while IFS= read -r line; do
                echo "${line}"
                [ "${line}" == "<SecFloatingFeatureSet>" ] && echo "    <${feature_code}>${feature_code_value}</${feature_code}>"
            done
        } < "${BUILD_TARGET_FLOATING_FEATURE_PATH}" > "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
    else
        change_xml_values "${feature_code}" "${feature_code_value}" "${BUILD_TARGET_FLOATING_FEATURE_PATH}"
    fi
}

function add_csc_xml_values() {
    local feature_code="$(string_format -u "$1")"
    local feature_code_value="$2"

    # write it to the path
    for EXPECTED_CSC_FEATURE_XML_PATH in $HORIZON_PRODUCT_DIR/omc/*/conf/cscfeature.xml $HORIZON_OPTICS_DIR/configs/carriers/*/*/conf/system/cscfeature.xml; do
        if [ -f "$EXPECTED_CSC_FEATURE_XML_PATH" ]; then
            if [ "$(catch_duplicates_in_xml "${feature_code}" "${EXPECTED_CSC_FEATURE_XML_PATH}")" == "0" ]; then
                {
                    while IFS= read -r line; do
                        echo "${line}"
                        if [[ "${line}" == "<SamsungMobileFeature>" ]]; then
                            echo "    <${feature_code}>${feature_code_value}</${feature_code}>"
                        fi
                    done
                } < "${EXPECTED_CSC_FEATURE_XML_PATH}" > "${EXPECTED_CSC_FEATURE_XML_PATH}"
                # write the ending thing cuz this mf is not writing that for some reason.
                echo "</SamsungMobileFeature>" >> "${EXPECTED_CSC_FEATURE_XML_PATH}"
            else 
                change_xml_values "${feature_code}" "${feature_code_value}" "${EXPECTED_CSC_FEATURE_XML_PATH}"
            fi
        fi
    done
}

function tinkerWithCSCFeaturesFile() {
    local action="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    local decoder_jar="./dependencies/bin/omc-decoder.jar"

    # Ensure decoder exists
    [ ! -f "$decoder_jar" ] && abort "Error: omc-decoder.jar not found!"

    # handle arg
    case "${action}" in
        --decode)
            for EXPECTED_CSC_FEATURE_XML_PATH in $HORIZON_PRODUCT_DIR/omc/*/conf/cscfeature.xml $HORIZON_OPTICS_DIR/configs/carriers/*/*/conf/system/cscfeature.xml; do
	            [ -f "${EXPECTED_CSC_FEATURE_XML_PATH}" ] || continue
                if java -jar "$decoder_jar" -i "${EXPECTED_CSC_FEATURE_XML_PATH}" -o "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml" &>$thisConsoleTempLogFile; then
                    debugPrint "CSC feature file successfully decoded."
                else
                    abort "Failed to decode the CSC feature file, please try again..."
                fi
            done
            debugPrint "CSC feature file successfully decoded."
        ;;
        --encode)
            for EXPECTED_CSC_FEATURE_XML_PATH in $HORIZON_PRODUCT_DIR/omc/*/conf/cscfeature.xml $HORIZON_OPTICS_DIR/configs/carriers/*/*/conf/system/cscfeature.xml; do
	            [ -f "${EXPECTED_CSC_FEATURE_XML_PATH}" ] || continue
                if java -jar "$decoder_jar" -e -i "${EXPECTED_CSC_FEATURE_XML_PATH}__decoded.xml" -o "${EXPECTED_CSC_FEATURE_XML_PATH}" &>$thisConsoleTempLogFile; then
                    debugPrint "CSC feature file successfully encoded."
                else
                    abort "Failed to encode the CSC feature file, please try again..."
                fi
            done
        ;;
        *)
            abort "Usage: tinkerWithCSCFeaturesFile --decode | --encode"
        ;;
    esac
    return $?
}

function change_xml_values() {
    local feature_code="$(echo "$1" | tr '[:lower:]' '[:upper:]')"
    local feature_code_value="$2"
    local file="$3"

    # do checks and put ts shyt in log
    debugPrint "change_xml_values(): Arguments: $1 $2 $3"
    [ -z "$file" ] && abort "Error: No XML file specified!"
    [ ! -f "$file" ] && abort "Error: XML file '${file}' not found!"

    # uhrm achshually!
    if grep -q "${feature_code}=" "$file"; then
        if ! grep -q "${feature_code}=\"${feature_code_value}\"" "$file"; then
            sed -i.bak "s|\(${feature_code}=\)\"[^\"]*\"|\1\"${feature_code_value}\"|g" "$file"
            debugPrint "change_xml_values(): Updated ${feature_code} to ${feature_code_value} in $file"
        else
            debugPrint "change_xml_values(): ${feature_code} is already set to ${feature_code_value}, skipping."
        fi
    elif grep -qi "<${feature_code}>" "$file"; then
        if ! grep -q "<${feature_code}>${feature_code_value}</${feature_code}>" "$file"; then
            sed -i.bak "s|<${feature_code}>[^<]*</${feature_code}>|<${feature_code}>${feature_code_value}</${feature_code}>|g" "$file"
            debugPrint "change_xml_values(): Updated <${feature_code}> value to ${feature_code_value}"
        else
            debugPrint "change_xml_values(): <${feature_code}> is already set to ${feature_code_value}, skipping."
        fi
    else
        debugPrint "change_xml_values(): No matching ${feature_code} or ${manifest_attr} found. Skipping modification."
    fi
}

function change_yaml_values() {
    local key="$1"
    local value="$2"
    local file="$3"

    # do checks and put ts shyt in log
    debugPrint "change_yaml_values(): Arguments: $1 $2 $3"
    [ -z "$file" ] && abort "Error: No file specified!"
    [ ! -f "$file" ] && abort "Error: File '$file' not found!"

    # ok lets go
    if grep -Eq "^[[:space:]]*${key}:" "$file"; then
        sed -i -E "s|(^[[:space:]]*${key}:)[[:space:]]*.*|\1 ${value}|" "$file"
    else
        echo "${key}: ${value}" >> "$file"
    fi
}

function ask() {
    local question="$1"
    local answer
    printf "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)\e[0;37m] / [:\e[0;36mMESSAGE\e[0;37m:] / [:\e[0;32mJOB\e[0;37m:] -\e[0;33m $1\e[0;37m (y/n) : "
    read answer
    answer="$(echo "$answer" | tr '[:upper:]' '[:lower:]')"
    [[ "${answer}" == "y" || "${answer}" == "yes" ]] && return 0
    return 1
}

function remove_attributes() {
    local INPUT_FILE="$1"
    local OUTPUT_FILE="$2"
    local NAME_TO_SKIP="$3"
    local MODIFIED=false

    # capture ts input action:
    debugPrint "remove_attributes(): Input file: ${INPUT_FILE}, Output File: ${OUTPUT_FILE}, Attribute to Skip: ${NAME_TO_SKIP}"

    # Validate input
    [ ! -f "$INPUT_FILE" ] && { debugPrint "Error: Input file not found!"; return 1; }
    [ -z "$NAME_TO_SKIP" ] && { debugPrint "Error: Attribute to skip was not provided"; return 1; }

    # Create output file
    touch "$OUTPUT_FILE"

    # Start writing new XML
    {

        # Read the input XML file line by line
        while IFS='' read -r line; do
            # Check if this line starts a <hal> block
            if [[ "$line" =~ ^[[:space:]]*"<hal" ]]; then
                block="$line"
                skip_block=false

                # Read the rest of the <hal> block
                while IFS='' read -r inner_line; do
                    block+=$'\n'"$inner_line"

                    # If we find a <name> tag with the specified value, mark this block for skipping
                    if [[ "$inner_line" =~ ^[[:space:]]*"<name>"$NAME_TO_SKIP"</name>"[[:space:]]* ]]; then
                        skip_block=true
                    fi

                    # Stop reading if we reach the closing </hal>
                    if [[ "$inner_line" =~ ^[[:space:]]*"</hal>" ]]; then
                        break
                    fi
                done

                # If block was marked for skipping, do not write it to the output file
                if $skip_block; then
                    MODIFIED=true
                    continue
                fi

                # Otherwise, write the block to the output
                echo "$block"
            else
                # Write all other lines that are not part of a <hal> block
                echo "$line"
            fi
        done < "$INPUT_FILE"

        echo "</manifest>"
    } > "$OUTPUT_FILE"

    # Only replace the input file if changes were made
    if $MODIFIED; then
        mv "$OUTPUT_FILE" "$INPUT_FILE"
        console_print "Updated XML saved to $INPUT_FILE, removed <hal> with name=$NAME_TO_SKIP."
        debugPrint "remove_attributes(): Updated XML saved to $INPUT_FILE, removed <hal> with name=$NAME_TO_SKIP."
    else
        console_print "No changes made. <hal> with name=$NAME_TO_SKIP was not found."
        debugPrint "remove_attributes(): No changes made. <hal> with name=$NAME_TO_SKIP was not found."
        rm "$OUTPUT_FILE"
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
        cp -af "$path" "./res/drawable-nodpi/${filename}"
    fi
    clear
}

HEX_PATCH() {
    local FILE="$1"
    local FROM="$2"
    local TO="$3"

    if xxd -p "$FILE" | tr -d \\n | tr -d " " | grep -q "$TO"; then
        warns "the patches were already applied to the file, no need to apply them again.." "HEX_PATCHER"
        return 0
    fi

    if ! xxd -p "$FILE" | tr -d \\n | tr -d " " | grep -q "$FROM"; then
        warns "No need to patch the file cuz the file was perfect..." "HEX_PATCHER"
        return 1
    fi

	# hmm, understandable :/
    console_print "Patching the bluetooth system file..."
    xxd -p "$FILE" | tr -d \\n | tr -d " " | sed "s/$FROM/$TO/" | xxd -r -p > "$FILE.tmp"
  	mv "$FILE.tmp" "${HORIZON_SYSTEM_DIR}/lib64/libbluetooth_jni.so" && console_print "Patched successfully, the file was moved to \"patched_resources/system/lib64/libbluetooth_jni.so\" folder.."
    abort "Failed to patch the bluetooth lib, please try again.."
}

function existance() {
    local file="$1"
    # grrrrrrrrrrrrrr
    [ -e "$file" ] && return 0
    return 1
}

function string_format() {
    local string="$2"
    case "$1" in
        -l|--lower)
            echo $string | tr '[:upper:]' '[:lower:]'
        ;;

        -u|--upper)
            echo $string | tr '[:lower:]' '[:upper:]'
        ;;

        *)
            echo $string
        ;;
    esac
}

function generate_random_hash() {
    local how_much
    how_much=$(echo "$1")
    if [ ! "$#" == "1" ]; then
        abort "Not enough arguments..."
    fi
    debugPrint "generate_random_hash(): Requested random seed: ${how_much}"
    timeout 0.1 cat /dev/urandom | xxd -p | head -n 1 | cut -c 1-${how_much}
}

# for compatibility vro
function execute_scripts() {
    local script="$1"
    . $script 2>> $thisConsoleTempLogFile;
}

function absolute_path() {
    local parsed_argument
    parsed_argument="$(string_format -l "$1")"
    parsed_argument="${parsed_argument:2}"
    case "$parsed_argument" in
        system)
            [[ -f "$HORIZON_SYSTEM_DIR/build.prop" ]] && echo "$HORIZON_SYSTEM_DIR"
            [[ -f "$HORIZON_SYSTEM_DIR/system/build.prop" ]] && echo "$HORIZON_SYSTEM_DIR/system"
        ;;
        system_ext)
            [[ -f "$HORIZON_SYSTEM_DIR/system_ext/etc" ]] && echo "$HORIZON_SYSTEM_DIR/system_ext"
            echo "$HORIZON_SYSTEM_EXT_DIR"
        ;;
        vendor)
            [[ -f "$HORIZON_VENDOR_DIR/build.prop" ]] && echo "$HORIZON_VENDOR_DIR"
            [[ -f "$HORIZON_VENDOR_DIR/vendor/build.prop" ]] && echo "$HORIZON_VENDOR_DIR/vendor"
        ;;
        product)
            [[ -f "$HORIZON_PRODUCT_DIR/build.prop" ]] && echo "$HORIZON_PRODUCT_DIR"
            [[ -f "$HORIZON_PRODUCT_DIR/product/build.prop" ]] && echo "$HORIZON_PRODUCT_DIR/product"
        ;;
        prism)
            [[ -f "$HORIZON_PRISM_DIR/build.prop" ]] && echo "$HORIZON_PRISM_DIR"
            [[ -f "$HORIZON_PRISM_DIR/prism/build.prop" ]] && echo "$HORIZON_PRISM_DIR/prism"
        ;;
        *)
            abort "Invalid partition argument: $parsed_argument"
        ;;
    esac
}

function fetch_rom_arch() {
    local arch_file=""
    local arch=""
    local arg="$1"

    # Find build.prop file containing architecture info
    for file in "$HORIZON_SYSTEM_DIR/build.prop" "$HORIZON_SYSTEM_EXT_DIR/build.prop" "$HORIZON_PRODUCT_DIR/build.prop"; do
        if grep -q "ro.product.cpu.abi" "$file"; then
            arch_file="$file"
            break
        fi
    done

    # Check if no file was found
    if [ -z "$arch_file" ]; then
        abort "Error: Could not determine ROM architecture!"
        return 1
    fi

    # Extract architecture from build.prop
    arch=$(grep_prop ro.product.cpu.abi "$arch_file" | tr '[:upper:]' '[:lower:]')

    # Check architecture validity
    case "$arch" in
        arm64-v8a|armeabi-v7a)
            if [ "$arg" == "--libpath" ]; then
                case "$arch" in
                    arm64-v8a) echo "lib64" ;;
                    armeabi-v7a) echo "lib" ;;
                esac
            else
                echo "$arch"
            fi
            ;;
        *)
            abort "Unsupported architecture: $arch"
            return 1
            ;;
    esac
}

function debugPrint() {
    if [ ! -z "${DEBUG_SCRIPT}" ]; then
        console_print "$@"
    else
        echo "[$(date +%H:%M%p)] - $@" >> ${thisConsoleTempLogFile}
    fi
}

function apply_diff_patches() {
    local DiffPatchFile="$1"
    local TheFileToPatch="$2"
    if [ "$#" -ne 2 ]; then
        abort "Error: Missing arguments. Usage: apply_diff_patches <patch file> <target file>"
    fi
    if [ ! -f "$DiffPatchFile" ]; then
        debugPrint "apply_diff_patches(): Patch file '$DiffPatchFile' not found."
        abort "Error: Patch file '${DiffPatchFile}' not found."
    elif [ ! -f "$TheFileToPatch" ]; then
        debugPrint "apply_diff_patches(): Target file '$TheFileToPatch' not found."
        abort "Error: Target file '${TheFileToPatch}' not found."
    fi
    debugPrint "apply_diff_patches(): ${DiffPatchFile} → ${TheFileToPatch}"
    if ! patch "$TheFileToPatch" < "$DiffPatchFile" &>>$thisConsoleTempLogFile; then
        console_print "Patch failed! Check logs for details."
    fi
}

function stack_build_properties() {
    local unforgettable
    local i
    local stacked_temp_properties="${TMPDIR}/$(generate_random_hash 20)___stacked__properties"
    for i in $HORIZON_PRODUCT_PROPERTY_FILE $HORIZON_SYSTEM_PROPERTY_FILE $HORIZON_SYSTEM_EXT_PROPERTY_FILE $HORIZON_VENDOR_PROPERTY_FILE; do
        for unforgettable in "$(cat "${i}")"; do
            echo "${unforgettable}" >> ${stacked_temp_properties}
        done
    done
}

function check_existence_of_property() {
    local property="$1"
    local stacked_properties_file
    stacked_properties_file=$(ls ${TMPDIR} | grep ___stacked__properties)
    if [ -z "$stacked_properties_file" ]; then
        abort "Error: No stacked properties file found in TMPDIR."
    fi
    if grep -q "$property" "${TMPDIR}/$stacked_properties_file"; then
        if grep -q "system/" <<< "$property"; then
            echo "system"
        elif grep -q "system_ext/" <<< "$property"; then
            echo "system_ext"
        elif grep -q "vendor/" <<< "$property"; then
            echo "vendor"
        elif grep -q "product/" <<< "$property"; then
            echo "product"
        elif grep -q "prism/" <<< "$property"; then
            echo "prism"
        fi
    fi
    return 1
}

function kang_dir() {
    local dir
    local WhySoSerious=$(string_format --lower "$1")
    if [ "$WhySoSerious1" == "prism" ]; then
        dir="$PRISM_DIR"
    elif [ "$WhySoSerious1" == "product" ]; then
        dir="$PRODUCT_DIR"
    elif [ "$WhySoSerious1" == "system" ]; then
        dir="$SYSTEM_DIR"
    elif [ "$WhySoSerious" == "system_ext" ]; then
        dir="$SYSTEM_EXT_DIR"
    elif [ "$WhySoSerious1" == "vendor" ]; then
        dir="$VENDOR_DIR"
    elif [ "$WhySoSerious1" == "optics" ]; then
        dir="$OPTICS_DIR"
    fi
    if [ -d "$dir/etc" ]; then
        echo "$dir"
    elif [ -d "$dir/$1/etc" ]; then
        echo "$dir/$1"
    fi
}

function check_build_prop() {
    local dir="$1"
    if [ -f "$dir/build.prop" ]; then
        echo "$dir/build.prop"
    elif [ -f "$dir/etc/build.prop" ]; then
        echo "$dir/etc/build.prop"
    fi
    return 1
}

function download_glmodules() {
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
                        mkdir -p ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/28/${GOODLOOK_MODULES_FOR_28[$i]} ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}/
                    else 
                        rmdir ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_28_APP_NAMES[$i]}/
                    fi
                ;;
                29)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}?"; then
                        mkdir -p ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/29/${GOODLOOK_MODULES_FOR_29[$i]} ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}/
                    else 
                        rmdir ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_29_APP_NAMES[$i]}/
                    fi
                ;;
                30)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}?"; then
                        mkdir -p ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/30/${GOODLOOK_MODULES_FOR_30[$i]} ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}/
                    else 
                        rmdir ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_30_APP_NAMES[$i]}/
                    fi
                ;;
                31)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}?"; then
                        mkdir -p ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/31/${GOODLOOK_MODULES_FOR_31[$i]} ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}/
                    else 
                        rmdir ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_31_APP_NAMES[$i]}/
                    fi
                ;;
                32)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}?"; then
                        mkdir -p ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/32/${GOODLOOK_MODULES_FOR_32[$i]} ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}/
                    else 
                        rmdir ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_32_APP_NAMES[$i]}/
                    fi
                ;;
                33)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}?"; then
                        mkdir -p ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/33/${GOODLOOK_MODULES_FOR_33[$i]} ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}/
                    else 
                        rmdir ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_33_APP_NAMES[$i]}/
                    fi
                ;;
                34)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}?"; then
                        mkdir -p ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/34/${GOODLOOK_MODULES_FOR_34[$i]} ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}/
                    else 
                        rmdir ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_34_APP_NAMES[$i]}/ 
                    fi
                ;;
                35)
                    if ask "Do you want to download ${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}?"; then
                        mkdir -p ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}/
                        download_stuffs https://github.com/corsicanu/goodlock_dump/releases/download/35/${GOODLOOK_MODULES_FOR_35[$i]} ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}/
                    else 
                        rmdir ../local_build/system/priv-app/${GOODLOOK_MODULES_FOR_35_APP_NAMES[$i]}/
                    fi
                ;;
            esac
        fi
    done
}

function check_internet_connection() {
    local idkman="$@"
    if ! ping -w 3 google.com &>/dev/null; then
        warns "Please connect the computer to a wifi or an ethernet connection to access online facilities." "$(string_format -u ${idkman})"
    fi
}

function fetch_file_arch() {
    local file="$2"
    local argument="$1"
    local fileArch=$(file "${file}" | awk '{print $3}' | cut -c 1-2)
    if [[ "${fileArch}" == "64" || "${fileArch}" == "32" ]]; then
        case "$argument" in
            --binary-path)
                [ "${fileArch}" == "64" ] && echo "64"
            ;;
            --yap-whos-that-pokemon)
                echo "$fileArch"
            ;;
        esac
    else
        warns "This binary file is not supported because it's not either 32 or 64 bits, please contact the developer for assistance." "UNDEFINED_BINARY_ARCHITECTURE"
        return 1
    fi
}

function verify() {
    local file="$1"
    local fileHash="$2"
    return $([ "$(sha512sum $file | awk '{print $1}')" = "$fileHash" ])
}

# stupid FUCKING function that i have to FUCKING make it to FUCKING fix my FUCKING code.
function boolReturn() {
    local value="$(string_format -l "$@")"
    [[ "$value" == "true" || "$value" == "0" ]] && return 0
    return 1
}

# needs fix actually.
function manageCameraFeatures() {
    local arg="$1"
    local featureName="$2"
    local extvalues="$3"
    local afterThisAttribute="$4"
    local XMLFile
    if [ "${arg}" == "--add" ]; then
        XMLFile="$5"
        # fixes confilcts
        manageCameraFeatures --remove "${featureName}" "${XMLFile}"
        {
            while IFS= read -r line; do
                if echo "${line}" | awk '{print $2}' | grep -q ${afterThisAttribute}; then
                    echo -e "\t    <local name=${featureName} ${extvalues}/>"
                else
                    echo -e "\t${line}"
                fi
            done
            echo -e "\t</resources>"
        } < "${XMLFile}" > ${XMLFile}_tmp
    elif [ "${arg}" == "--remove" ]; then
        XMLFile="$3"
        {
            while IFS= read -r line; do
                if echo "${line}" | grep -q ${featureName}; then
                    continue
                else
                    echo -e "\t${line}"
                fi
            done
            echo -e "\t</resources>"
        } < "${XMLFile}" > ${XMLFile}_tmp
    fi
    mv  ${XMLFile}_tmp ${XMLFile}
}

function parseBuildValues() {
    local file="$1"
    while IFS='=' read -r key value; do
        echo "$key"
        echo "${value:-<empty>}"
    done < "$file"
}

function replaceTargetBuildProperties() {
    [[ "$BUILD_TARGET_REPLACE_REQUIRED_PROPERTIES" == true ]] || return 1
    local BUILD_TARGET="$1"
    local scope file key value
    console_print "Replacing properties for your device...."
    for entry in "vendor ./target/${BUILD_TARGET}/replaceableVendorProps.prop" "system ./target/${BUILD_TARGET}/replaceableSystemProps.prop"; do
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
    local backupBlob="../local_build/tmp/hux/${blobInROM}.bak"
    console_print "Trying to copy ${blobFromSource} to ${blobInROM}"
    if [ -f "$blobInROM" ]; then
        cp -af "$blobInROM" "$backupBlob"
    fi
    if [ ! -f "$blobInROM" ] && ask "${blobFromSource} is not found on the ROM, do you wanna copy this blob to the device?"; then
        if ! cp -af "${blobFromSource}" "${blobInROM}" 2>${thisConsoleTempLogFile}; then
            warns "Failed to copy ${blobFromSource}, this might cause a bootloop, attempting to restore original blob." "copyDeviceBlobsSafely()"
            [ -f "$backupBlob" ] && cp -af "$backupBlob" "$blobInROM"
        fi
    else
        if ! cp -af "${blobFromSource}" "${blobInROM}" 2>"${thisConsoleTempLogFile}"; then
            warns "Failed to copy ${blobFromSource}, this might cause a bootloop, attempting to restore original blob." "copyDeviceBlobsSafely()"
            [ -f "$backupBlob" ] && cp -af "$backupBlob" "$blobInROM"
        fi
    fi
    console_print "Finished copying given blobs!"
    return 0
}

function getImageFileSystem() {
    if [[ "$(xxd -p -l "2" --skip "1080" "$1")" == "53ef" ]]; then
        echo "ext4"
    elif [[ "$(xxd -p -l "4" --skip "1024" "$1")" == "1020f5f2" ]]; then
        echo "f2fs"
    elif [[ "$(xxd -p -l "4" --skip "1024" "$1")" == "e2e1f5e0" ]]; then
        echo "erofs"
    else
        echo "unknown"
    fi
}

function setMakeConfigs() {
    local propVariableName="$1"
    local propValue="$2"
    local propFile="$3"
    awk -v pat="^${propVariableName}=" -v value="${propVariableName}=${propValue}" '{ if ($0 ~ pat) print value; else print $0; }' ${propFile} > ${propFile}.tmp
}

function buildImage() {
    local blockPath="$1"
    local block="$2"
    local buildType="$3"
    local imagePath=$(mount | grep ${blockPath} | awk '{print $1}')
    if echo "$blockPath" | grep -q "__rw"; then
        echo "EROFS fs detected, building an EROFS image..."
        sudo mkfs.erofs -z lz4 --mount-point=$block ../local_build/workflow_builds/${block}.erofs.img $blockPath/
    else 
        echo "F2FS/EXT4 fs detected, unmounting the image.."
        sudo umount "${blockPath}" || abort "Failed to unmount the image, aborting this instance.."
        echo "Successfully unmounted ${blockPath}.."
    fi
    cp $imagePath ../local_build/workflow_builds/${block}_buildImage.img && rm $imagePath
    [ "$?" -ne '0' ] && abort "Failed to copy the image to the build directory, aborting this instance.."
    echo "Successfully built ${block}_buildImage.img"
    return 0
}

function uploadGivenFileToTelegram() {
    local userRequestedFile="$1"
    [ -f "${userRequestedFile}" ] || return 1
    sendMessageToTelegramChat "Trying to upload ${userRequestedFile} to the requested chat..."
    curl -F "chat_id=${chatID}" -F "document=@${userRequestedFile}" "https://api.telegram.org/bot${theBotToken}/sendDocument" &>output
    if [ "$(cat output | grep -o '"ok":[^,}]*' | sed 's/"ok"://')" == "true" ]; then
        console_print "Uploaded ${userRequestedFile} to $(cat output | grep -o '"first_name":[^,}]*' | sed 's/"first_name"://' | xargs) successfully....."
        return 0
    fi
    warns "Failed to upload ${userRequestedFile}, please try again...."
    return 1
}

function sendMessageToTelegramChat() {
    local messageToBeSent="$1"
    if [ -z "${theBotToken}" ]; then
        console_print "${messageToBeSent}"
        return 0
    fi
    curl -s -X POST "https://api.telegram.org/bot${theBotToken}/sendMessage" -d "chat_id=${chatID}" -d "text=${messageToBeSent}" &>output
    if [ "$(cat output | grep -o '"ok":[^,}]*' | sed 's/"ok"://')" == "true" ]; then
        debugPrint "Sent message to $(cat output | grep -o '"first_name":[^,}]*' | sed 's/"first_name"://' | xargs) successfully....."
        return 0
    fi
    debugPrint "Failed to send message to $(cat output | grep -o '"first_name":[^,}]*' | sed 's/"first_name"://' | xargs)"
    return 1
}

function deviceCodenameToModel() {
    case $(string_format -l $1) in
        "r8q")
            echo "S20 FE"
        ;;
        "a30")
            echo "A30"
        ;;
    esac
}