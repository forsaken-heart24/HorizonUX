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

#!/usr/bin/env bash

function setprop() {
    local propFile
    local propVariableName="$2"
    local propValue="$3"
    if string_format --lower "$1" | grep -q "prism"; then
        propFile=$(check_build_prop "${HORIZON_PRISM_DIR}")
    elif string_format --lower "$1" | grep -q "product"; then
        propFile=$(check_build_prop "${HORIZON_PRODUCT_DIR}")
    elif string_format --lower "$1" | grep -q "system"; then
        propFile=$(check_build_prop "${HORIZON_SYSTEM_DIR}")
    elif string_format --lower "$1" | grep -q "system_ext"; then
        propFile=$(check_build_prop "${HORIZON_SYSTEM_EXT_DIR}")
    elif string_format --lower "$1" | grep -q "vendor"; then
        propFile=$(check_build_prop "${HORIZON_VENDOR_DIR}")
    fi
    awk -v pat="^${propVariableName}=" -v value="${propVariableName}=${propValue}" '{ if ($0 ~ pat) print value; else print $0; }' ${propFile} > ${propFile}.tmp
    mv ${propFile}.tmp ${propFile}
}

function abort() {
    echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] [:\e[0;36mABORT\e[0;37m:] -\e[0;31m $1\e[0;37m"
    echo -e "[$(date +%d-%m-%Y) - $(date +%H:%M%p)] [:ABORT:] - $1" >> $thisConsoleTempLogFile
    [ "$(string_format -l $openSeperateConsoleForDebugging)" == "true" ] && echo "[$(date +%d-%m-%Y) - $(date +%H:%M%p)] / [:WARN:] - This console will get killed because this script didn't run properly, share the logs with the developer's handle." >> $thisConsoleTempLogFile
    sleep 0.5
    if [ "${BATTLEMAGE_BUILD}" == "true" ]; then
        umount $HASH_KEY_FOR_SUPER_BLOCK_PATH &>/dev/null
        rmdir $HASH_KEY_FOR_SUPER_BLOCK_PATH &>/dev/null
    fi
    kill $pid
    exit 1
}

function warns() {
    echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] / [:\e[0;36mWARN\e[0;37m:] / [:\e[0;32m$2\e[0;37m:] -\e[0;33m $1\e[0;37m"
    echo -e "[$(date +%d-%m-%Y) - $(date +%H:%M%p)] / [:WARN:] / [:$2:] - $1" >> $thisConsoleTempLogFile
}

function console_print() {
    echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)\e[0;37m] / [:\e[0;36mMESSAGE\e[0;37m:] / [:\e[0;32mJOB\e[0;37m:] -\e[0;33m $1\e[0;37m"
}

function default_language_configuration() {
    local language="$1"
    local country="$2"
    [ -z $language ] && language=en
    [ -z $country ] && country=US
    
    # change the strings cases to prevent issues on the system.
    language=$(string_format -l $language)
    country=$(string_format -u $country)
    
    # capture and abort the op if the length is invalid.
    if [ "$(echo ${country} | wc -c)" -ge "4" ]; then
        abort "invalid country string length."
    elif [ "$(echo ${language} | wc -c)" -ge "4" ]; then
        abort "invalid language string length."
    fi
    
    # thing that actually switches the default lang.
    if [ -f "$(absolute_path --product)/omc/${PRODUCT_CSC_NAME}/conf/consumer.xml" ]; then
        sed 's|<DefLanguage>[^<]*</DefLanguage>|<DefLanguage>${language}-${country}</DefLanguage>|g' $(absolute_path --product)/omc/${PRODUCT_CSC_NAME}/conf/consumer.xml
        sed 's|<DefLanguageNoSIM>[^<]*</DefLanguageNoSIM>|<DefLanguageNoSIM>${language}-${country}</DefLanguageNoSIM>|g' $(absolute_path --product)/omc/${PRODUCT_CSC_NAME}/conf/consumer.xml
    else 
        local tmp_dir="$(echo "$(absolute_path --product)/omc/*/conf/consumer.xml")"
        sed 's|<DefLanguage>[^<]*</DefLanguage>|<DefLanguage>${language}-${country}</DefLanguage>|g' $tmp_dir
        sed 's|<DefLanguageNoSIM>[^<]*</DefLanguageNoSIM>|<DefLanguageNoSIM>${language}-${country}</DefLanguageNoSIM>|g' $tmp_dir
    fi
}

function custom_setup_finished_messsage() {
    [ -z "${CUSTOM_SETUP_WELCOME_MESSAGE}" ] && CUSTOM_SETUP_WELCOME_MESSAGE="Welcome to HorizonUX"
    [ "${CUSTOM_SETUP_WELCOME_MESSAGE}" == "xxx" ] && CUSTOM_SETUP_WELCOME_MESSAGE="Welcome to HorizonUX"
    sed -i 's|<string name="outro_title">.*</string>|<string name="outro_title">&quot;${CUSTOM_SETUP_WELCOME_MESSAGE}&quot;</string>|' ./packages/sec_setup_wizard_horizonux_overlay/res/values/strings.xml
}

function build_and_sign() {
    local app_path="$2"
    local extracted_dir_path="$1"
    local apkFileName
    if [ -f "$extracted_dir_path/apktool.yml" ]; then 
        apkFileName=$(grep apkFileName $extracted_dir_path/apktool.yml | cut -c 14-1000)
    else 
        abort "Invalid Apkfile path.."
    fi
    rm -rf ${extracted_dir_path}/dist/*
    java -jar ./dependencies/bin/apktool.jar build --api-level "${BUILD_TARGET_SDK_VERSION}" "${extracted_dir_path}" &>/dev/null
    if [ -z "$MY_KEYSTORE_PATH" ]; then
        java -jar ./dependencies/bin/signer.jar --apk ${extracted_dir_path}/dist/*.apk
            warns "NOTE: you are now using uber test-key and it's not safe to use this on a pubilc build of this rom, please use your own key to sign packages!" "TEST_KEY_WARNS"
    elif [ -f "$MY_KEYSTORE_PATH" ]; then
        [ "$MY_KEYSTORE_PATH" == "../test-keys/HorizonUX-testkey.jks" ] && warns "NOTE: you are now using HorizonUX test-key and it's not safe to use this on a pubilc build of this rom, please use your own key to sign packages!" "TEST_KEY_WARNS"
        java -jar ./dependencies/bin/signer.jar -apk ${extracted_dir_path}/dist/*.apk --ks $MY_KEYSTORE_PATH --ksAlias $MY_KEYSTORE_ALIAS --ksPass $MY_KEYSTORE_PASSWORD --ksKeyPass $MY_KEYSTORE_ALIAS_KEY_PASSWORD
    fi
    mv ${extracted_dir_path}/dist/$(ls | grep aligned-debugSigned.apk | head -n 1) $app_path/
    rm -rf ${extracted_dir_path}/build ${extracted_dir_path}/dist/
}

function custom_setup_finished_messsage() {
    [ -z "${CUSTOM_SETUP_WELCOME_MESSAGE}" ] && CUSTOM_SETUP_WELCOME_MESSAGE="Welcome to HorizonUX"
    [ "${CUSTOM_SETUP_WELCOME_MESSAGE}" == "xxx" ] && CUSTOM_SETUP_WELCOME_MESSAGE="Welcome to HorizonUX"
    sed -i 's|<string name="outro_title">.*</string>|<string name="outro_title">&quot;${CUSTOM_SETUP_WELCOME_MESSAGE}&quot;</string>|' ./packages/sec_setup_wizard_horizonux_overlay/res/values/strings.xml
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
    # this mf prints this out for the variable shit.
    echo "${count}"
}

function add_float_xml_values() {
    local feature_code="$1"
    local feature_code_value="$2"
    # Convert feature_code to uppercase
    feature_code="$(string_format -u "${feature_code}")"
    
    # check if we have duplicates or not, uf we have anything extra, call the catch_duplicates_in_xml to do the job lol.
    if [ "$(catch_duplicates_in_xml "${feature_code}" "${TARGET_BUILD_FLOATING_FEATURE_PATH}")" == "0" ]; then
        # Create a temporary file to hold the modified content
        local tmp_file="./tmp_feature"
        # Read the original file and write to the temporary file
        {
        while IFS= read -r line; do
            echo "${line}"
            if [ "${line}" == "<SecFloatingFeatureSet>" ]; then
            echo "    <${feature_code}>${feature_code_value}</${feature_code}>"
            fi
        done
        } < "${TARGET_BUILD_FLOATING_FEATURE_PATH}" > "${tmp_file}"
        # write the ending thing cuz this mf is not writing that for some reason.
        echo "</SecFloatingFeatureSet>" >> "${tmp_file}"
        # Replace the original file with the modified one
        mv "${tmp_file}" "${TARGET_BUILD_FLOATING_FEATURE_PATH}"
    else
        change_xml_values "${feature_code}" "${feature_code_value}" "${TARGET_BUILD_FLOATING_FEATURE_PATH}"
    fi
}

function add_csc_xml_values() {
    local feature_code="$1"
    local feature_code_value="$2"
    # Convert feature_code to uppercase
    feature_code="$(string_format -u "${feature_code}")"
    # check if we have duplicates or not, uf we have anything extra, call the catch_duplicates_in_xml to do the job lol.
    if [ "$(catch_duplicates_in_xml "${feature_code}" "${TARGET_BUILD_CSC_FEATURE_PATH}")" == "0" ]; then
        # Create a temporary file to hold the modified content
        local tmp_file="./tmp_csc"
        # Read the original file and write to the temporary file
        {
        while IFS= read -r line; do
            echo "${line}"
            if [[ "${line}" == "<SamsungMobileFeature>" ]]; then
            echo "    <${feature_code}>${feature_code_value}</${feature_code}>"
            fi
        done
        } < "${TARGET_BUILD_CSC_FEATURE_PATH}" > "${tmp_file}"
        # write the ending thing cuz this mf is not writing that for some reason.
        echo "</SamsungMobileFeature>" >> "${tmp_file}"
        # Replace the original file with the modified one
        mv "${tmp_file}" "${TARGET_BUILD_CSC_FEATURE_PATH}"
    else
        change_xml_values "${feature_code}" "${feature_code_value}" "${TARGET_BUILD_CSC_FEATURE_PATH}"
    fi
}

function tinkerWithCSCFeaturesFile() {
    if [ "$(string_format -l "$1")" == "--decode" ]; then
        java -jar ../dependencies/bin/omc-decoder.jar -i ${TARGET_BUILD_CSC_FEATURE_PATH} -o "$HORIZON_PRODUCT_DIR/omc/${PRODUCT_CSC_NAME}/conf/cscfeature_decoded.xml"
        TARGET_BUILD_CSC_FEATURE_PATH="$HORIZON_PRODUCT_DIR/omc/${PRODUCT_CSC_NAME}/conf/cscfeature_decoded.xml"
        rm -rf "$HORIZON_PRODUCT_DIR/omc/${PRODUCT_CSC_NAME}/conf/cscfeature.xml"
        isXmlDecoded=true
    elif [ "$(string_format -l "$1")" == "--encode" ]; then
        java -jar ../dependencies/bin/omc-decoder.jar -e -i $TARGET_BUILD_CSC_FEATURE_PATH -o "$HORIZON_PRODUCT_DIR/omc/${PRODUCT_CSC_NAME}/conf/cscfeature.xml"
    fi
}

function change_xml_values() {
    local feature_code="$1"
    local feature_code_value="$2"
    # Convert feature_code to uppercase
    feature_code="$(string_format --lower "${feature_code}")"
    # catch the duplicate values and warn the user lol.
    if [ "$(catch_duplicates_xml "${feature_code}" "${TARGET_BUILD_FLOATING_FEATURE_PATH}")" -ge "2" ]; then
        warns "${feature_code} named feature has duplicate values, please remove them to prevent conflicts."
    fi
    # Use sed to update the XML value
    sed -i "s|<${feature_code}>.*</${feature_code}>|<${feature_code}>${feature_code_value}</${feature_code}>|" "${TARGET_BUILD_FLOATING_FEATURE_PATH}"
}

# these things are intended for those " pro " programmers 
function int() {
    local variable_name="$1"
    local value="$2"
    # those shits are not working...
    eval "$variable_name=$value"
}

function bool() {
    local variable_name="$1"
    local value="$(string_format -l $2)"
    # Check if the value is either "true" or "false"
    if [ "$value" == "true" || "$value" == "false" || "$value" == "1" || "$value" == "0" ]; then
        eval "$variable_name=$value"
    else
        abort "Error: '$value' is not a boolean."
    fi
}
# these things are intended for those " pro " programmers 

function warns_api_limitations() {
    local adrod_version=$1
    warns "this feature is found on android $adrod_version, report if it doesn't work. thanks!" "TARGET_OUT_OF_BOUNDS"; 
}

function omc() {
    local arg="$1"
    local xml_filename="$2"
    # bomboclatttttttt 😭😭😭😭😭
    if [ "${arg}" == "--decode" ]; then
        java -jar ./dependencies/bin/omc-decoder.jar -i ${xml_filename}.xml -o ${xml_filename}_decoded.xml
    elif [ "${arg}" == "--encode" ]; then
        java -jar ./dependencies/bin/omc-decoder.jar -e -i ${xml_filename}_decoded.xml -o ${xml_filename}.xml
    fi
}

function ask() {
    local question="$1"
    local answer
    printf "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)\e[0;37m] / [:\e[0;36mMESSAGE\e[0;37m:] / [:\e[0;32mJOB\e[0;37m:] -\e[0;33m $1\e[0;37m (y/n) : "
    read answer
    answer="$(string_format -l "${answer}")"
    if [[ "${answer}" == "y" || "${answer}" == "yes" ]]; then
        return 0
    fi
    return 1
}

function remove_attributes() {
	local INPUT_FILE="$1"
	local OUTPUT_FILE="$2"
	local NAME_TO_SKIP="$3"

	# Start writing the new XML file
	{
		echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
		echo "<manifest version=\"2.0\" type=\"device\" target-level=\"3\">"
		
		# Read each line of the input XML
		while IFS= read -r line; do
			# Check if the line starts a <hal> block
			if [[ "$line" == *"<hal"* ]]; then
				# Read the entire <hal> block into a variable
				block="$line"
				skip_block=false

				# Check subsequent lines for the closing </hal>
				while IFS= read -r line; do
					block+=$'\n'"$line"
					if [[ "$line" == *"</hal>"* ]]; then
						break
					fi
				done
				
				# Check if the block contains the <name> to skip
				if [[ "$block" == *"<name>$NAME_TO_SKIP</name>"* ]]; then
					# Skip this block
					continue
				fi
				
				# Write the entire block to the output file if not skipped
				echo "$block"
			else
				# Write lines that are not part of a <hal> block
				echo "$line"
			fi
		done < "$INPUT_FILE"
		
		echo "</manifest>"
	} > "$OUTPUT_FILE"

	# Feedback
	console_print "Rewritten XML saved to $OUTPUT_FILE, skipping <hal> with name='$NAME_TO_SKIP'."
}

function nuke_stuffs() {
    local service
    local line
	local shit
	local stuffs2nukeinvintf=(
        "android.hardware.dumpstate*.xml"
        "engmode_manifest.xml"
		"vaultkeeper_manifest.xml"
        "dumpstate-default.xml"
        "wsm_manifest.xml"
    )
	local stuffs2nukeininitdir=(
		"$(absolute_path --vendor)/etc/init/*android.hardware.dumpstate@*.rc"
		"$(absolute_path --vendor)/etc/init/boringssl_self_test.rc"
		"$(absolute_path --vendor)/etc/init/cass.rc"
		"$(absolute_path --vendor)/etc/init/vaultkeeper_common.rc"
		"$(absolute_path --vendor)/etc/init/pa_daemon_teegris.rc"
		"$(absolute_path --vendor)/etc/init/wsm-service.rc"
	)
    for service in "security.wsm" "vendor.samsung.hardware.security.proca"; do
        console_print "Removing ${service} service from the system config files..."
		remove_attributes "${service}"
        for line in "${stuffs2nukeinvintf[@]}"; do
		    if [ -f "$(absolute_path --vendor)/etc/vintf/manifest/${line}" ]; then
			    rm -f "$(absolute_path --vendor)/etc/vintf/manifest/${line}"
			    console_print "Deleting ${line}..."
		    fi
	    done
        for shit in "${stuffs2nukeininitdir[@]}"; do
		    if [ -f "${shit}" ]; then
			    rm -f "${shit}"
			    console_print "Deleting ${shit}...\e[0m"
		    fi
	    done
        # idk man, it feels like it's useless because the vendor has the same codes on a init file.
        rm -rf "$(absolute_path --vendor)/etc/wlan_common_rc $(absolute_path --vendor)/etc/wlan_vendor_rc"
    done
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
        additionals)
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
	  mkdir -p ./patched_resources/system/lib64/
  	mv "$FILE.tmp" "./patched_resources/system/lib64/libbluetooth_jni.so"
    console_print "Patched successfully, the file was moved to \"patched_resources/system/lib64/libbluetooth_jni.so\" folder.."
}

function existance() {
    local file="$1"
    # grrrrrrrrrrrrrr
    if [ -e "$file" ]; then
        return 0
    fi
    return 1
}

function download_stuffs() {
    local link="$1"
    local save_path="$2"
    if [ "$#" -lt 2 ]; then
        warns "Arguments are not enough.." "DOWNLOADER"
        return 1
    fi
    # Check if the URL is a raw GitHub content
    if [[ "$link" == *"raw.githubusercontent.com"* ]]; then
        wget -O "$save_path" "$link"
    else
        curl -L -o "$save_path" "$link"
    fi
    # Check if the download failed
    if [ "$?" -ne '0' ]; then
        abort "The download failed..."
    fi
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
        warns "Don't you want me like i want you baby?" "arguments"
        abort "Not enough arguments..."
    fi
    timeout 0.1 cat /dev/urandom | xxd -p | head -n 1 | cut -c 1-${how_much}
}

# for compatibility vro
function execute_scripts() {
    local script="$1"
    $BATTLEMAGE_BUILD && { . $script --battlemage 2>> $thisConsoleTempLogFile; } || { . $script --non-battlemage 2>> $thisConsoleTempLogFile; }
}

function absolute_path() {
    local parsed_argument=$(string_format -l $1 | wc -c)
    local parsed_argument="$(string_format -l $1 | cut -c 3-$parsed_argument)"
    if $BATTLEMAGE_BUILD; then
        if ls $HASH_KEY_FOR_SUPER_BLOCK_PATH/ | grep -q $parsed_argument; then
            if [ -f "${HASH_KEY_FOR_SUPER_BLOCK_PATH}/$parsed_argument/etc" ]; then
                echo "${HASH_KEY_FOR_SUPER_BLOCK_PATH}/$parsed_argument"
            elif [ -f "${HASH_KEY_FOR_SUPER_BLOCK_PATH}/$parsed_argument/$parsed_argument/etc" ]; then
                echo "${HASH_KEY_FOR_SUPER_BLOCK_PATH}/$parsed_argument/$parsed_argument"
            fi
        else
            abort "no way this cant be happening..."
        fi
    else
        case $parsed_argument in
            system)
                if [ -f "${HORIZON_SYSTEM_DIR}/build.prop" ]; then
                    echo "${HORIZON_SYSTEM_DIR}"
                elif [ -f "${HORIZON_SYSTEM_DIR}/system/build.prop" ]; then
                    echo "${HORIZON_SYSTEM_DIR}/system"
                fi
            ;;
            system_ext)
                # i've chose to find the etc because after android 11 i guess, the build.prop in system_ext was moved to /system_ext/etc/build.prop on newer versions
                # the etc wont get changed that's why lol.
                if [ -f "$HORIZON_SYSTEM_DIR/system_ext/etc" ]; then
                    echo "$HORIZON_SYSTEM_DIR/system_ext"
                else
                    echo "$HORIZON_SYSTEM_EXT_DIR"
                fi
            ;;
            vendor)
                if [ -f "${HORIZON_VENDOR_DIR}/build.prop" ]; then
                    echo "${HORIZON_VENDOR_DIR}"
                elif [ -f "${HORIZON_VENDOR_DIR}/vendor/build.prop" ]; then
                    echo "${HORIZON_VENDOR_DIR}/vendor"
                fi
            ;;
            product)
                if [ -f "${HORIZON_PRODUCT_DIR}/build.prop" ]; then
                    echo "${HORIZON_PRODUCT_DIR}"
                elif [ -f "${HORIZON_PRODUCT_DIR}/product/build.prop" ]; then
                    echo "${HORIZON_PRODUCT_DIR}/product"
                fi
            ;;
            prism)
                if [ -f "${HORIZON_PRISM_DIR}/build.prop" ]; then
                    echo "${HORIZON_PRISM_DIR}"
                elif [ -f "${HORIZON_PRISM_DIR}/prism/build.prop" ]; then
                    echo "${HORIZON_PRISM_DIR}/prism"
                fi
            ;;
        esac
    fi
}

function fetch_rom_arch() {
    local nvm
    local jk
    local arg="$@"
    for jk in $(absolute_path --system)/build.prop $(absolute_path --system_ext)/build.prop $(absolute_path --product)/build.prop; do
        cat $jk | grep -q ro.product.cpu.abi && break;
    done
    nvm=$(grep_prop $jk)
    if [[ "$(string_format --lower $nvm)" == "arm64-v8a|armeabi-v7a" ]]; then
        if [ "$arg" == "--libpath" ]; then
            case "$(string_format --lower $nvm)" in 
                arm64-v8a) echo "lib64" ;;
                armeabi-v7a) echo "lib" ;;
            esac
        else 
            string_format --lower $nvm
        fi
    else
        abort "Unsupported architecture!!"
    fi
}

function apply_diff_patches() {
    local DiffPatchFile="$1"
    local TheFileToPatch="$2"
    if [ "$#" == "0" ] || [ "$#" -lt "2" ] || [ "$#" -ge "3" ]; then
        abort "Usage: <diff .patch file> <the file to patch>"
    fi
    if [ ! -f "${DiffPatchFile}" ]; then
        abort "please provide a valid path or file."
    elif [ ! -f "${TheFileToPatch}" ]; then
        abort "please provide a valid path or file."
    fi
    if ! patch ${TheFileToPatch} < ${DiffPatchFile} &>/dev/null; then
        warns "Couldn't patch the requested file, please try again" "DIFF_PATCHER"
    fi
}

function stack_build_properties() {
    local unforgettable
    local i
    local stacked_temp_properties="${TMPDIR}/$(generate_random_hash 100)___stacked__properties"
    for i in $HORIZON_HORIZON_PRISM_DIR $HORIZON_HORIZON_PRODUCT_DIR $HORIZON_HORIZON_SYSTEM_DIR $HORIZON_SYSTEM_EXT_DIR $HORIZON_HORIZON_VENDOR_DIR; do
        if [ -f "${i}/build.prop" ]; then
            for unforgettable in "$(cat "${i}/build.prop")"; do
                echo "${unforgettable} - ${i}" >> ${stacked_temp_properties}
            done
        else
            for unforgettable in "$(cat "${i}/etc/build.prop")"; do
                echo "${unforgettable} - ${i}/etc/build.prop" >> ${stacked_temp_properties}
            done
        fi
    done
}

function check_existence_of_property() {
    local property="$1"
    local stacked_properties_file
    stacked_properties_file=$(ls ${TMPDIR} | grep ___stacked__properties)
    if [ -z "$stacked_properties_file" ]; then
        echo "Error: No stacked properties file found in TMPDIR."
        return 1
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

function find_partition_property_file() {
    local i
    local thatthang=$1
    if [ "$thatthang" == "system|product|prism|vendor|system_ext" ]; then
        if [ -f "$(kang_dir "$thatthang")/build.prop" ]; then
            echo "$(kang_dir "$thatthang")/build.prop"
        elif [ -f "$(kang_dir "$thatthang")/etc/build.prop" ]; then
            echo "$(kang_dir "$thatthang")/etc/build.prop"
        fi
    fi
}

function kang_dir() {
    local dir
    local WhySoSerious=$(string_format --lower "$1")
    if "${BATTLEMAGE_BUILD}"; then
        dir="$katarenai/$1"
    else
        if [ "$WhySoSerious1" == "prism" ]; then
            dir="$HORIZON_PRISM_DIR"
        elif [ "$WhySoSerious1" == "product" ]; then
            dir="$HORIZON_PRODUCT_DIR"
        elif [ "$WhySoSerious1" == "system" ]; then
            dir="$HORIZON_SYSTEM_DIR"
        elif [ "$WhySoSerious" == "system_ext" ]; then
            dir="$HORIZON_SYSTEM_EXT_DIR"
        elif [ "$WhySoSerious1" == "vendor" ]; then
            dir="$HORIZON_VENDOR_DIR"
        fi
    fi
    if [ -f "$dir/etc" ]; then
        echo "$dir"
    elif [ -f "$dir/$1/etc" ]; then
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

function check_partition_in_target() {

function set_partition_flag() {
    local partition="$1"
    bool BATTLEMAGE_HAS_$(string_format --upper $partition) true
}

function mount_super_image() {
    local super_image="$1"
    HASH_KEY_FOR_SUPER_BLOCK_PATH=./tmp/$(generate_random_hash 100)
    mkdir -p "$HASH_KEY_FOR_SUPER_BLOCK_PATH"
    sudo mount -o rw "$super_image" "$HASH_KEY_FOR_SUPER_BLOCK_PATH" || abort "Failed to mount $super_image."
    console_print "The image was mounted on: ${HASH_KEY_FOR_SUPER_BLOCK_PATH}"
    console_print "The given image path: ${super_image}"
    katarenai="$HASH_KEY_FOR_SUPER_BLOCK_PATH"
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
        warns "Please connect the computer to a wifi or an ethernet connection to download good look modules." "$(string_format -u ${idkman})"
    fi
}

function fetch_file_arch() {
    local file="$2"
    local argument="$1"
    local fileArch=$(file "${file}" | awk '{print $3}' | cut -c 1-2)
    if [[ "${fileArch}" == "64" || "${fileArch}" == "32" ]]; then
        case "$argument" in
            --binary-path)
                if [[ "${fileArch}" == "64" ]]; then
                    echo "64"
                elif [[ "${fileArch}" == "32" ]]; then
                    echo ""
                fi
            ;;
            --yap-whos-that-pokemon)
                echo "$fileArch"
            ;;
        esac
        return 0
    else
        warns "This binary file is not supported because it's not either 32 or 64 bits, please contact the developer for assistance." "UNSTAGED_BINARY_ARCHITECTURE"
        return 1
    fi
}

function verify() {
    local file="$1"
    local fileHash="$2"
    if [ -f "$file" ]; then
        [ "$(sha512sum $file | awk '{print $1}')" = "$fileHash" ] && return 0
    fi
    return 1
}

# stupid FUCKING function that i have to FUCKING make it to FUCKING fix my FUCKING code.
function boolReturn() {
    local fuckingValue="$@"
    local fuckThisFuckingValue="$(string_format -l $fuckingValue)"
    if [[ "$fuckThisFuckingValue" == "true" || "$fuckThisFuckingValue" == "0" ]]; then
        return 0
    fi
    return 1
}

function build_program() {
    local file="$1"
    local header="-I$2"
    local special_argument="$3"
    local compiler
    local parsedFileExtension="${file##*.}"

    # fuckluna.c
    [ "$parsedFileExtension" == "c" ] && compiler=gcc
    [ "$parsedFileExtension" == "cpp" ] && compiler=g++
    [ -z "$header" ] && header=""
    [ -z "$compiler" ] && abort "Unknown file, change the format specifier if it's a c or a c++ program."

    # build bs starts from here.
    if string_format "$special_argument" | grep -q isLibrary=false; then
        $compiler $header $file &>compiler_build.log
    elif string_format "$special_argument" | grep -q isLibrary=true; then
        $compiler $header $file -shared &>compiler_build.log
    fi

    # error checks.
    [ "$?" -ge "1" ] && abort "can't build the program, check the compiler_build.log for details"
    echo " - The given program compiled without any sensitive errors, consider checking the compiler_build.log file"
}