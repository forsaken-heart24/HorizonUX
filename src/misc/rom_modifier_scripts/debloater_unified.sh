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

debloat_the_crap() {
    local app=(
        "ANTPlusTest"
        "ATTMessage_ATT"
        "AutomationTest_FB"
        "BluetoothTest"
        "Chrome"
        "ChromeCustomizations"
        "DictDiotekForSec"
        "DuoStub"
        "EasymodeContactsWidget81"
        "Facebook_stub"
        "FBAppManager_NS"
        "FactoryAirCommandManager"
        "FactoryCameraFB"
        "Foundation"
        "GoogleTTS"
        "GalaxyResourceUpdater"
        "KidsHome_Installer"
        "Maps"
        "MAPSAgent"
        "MDMApp"
        "MinusOnePage"
        "MyATTWebLink"
        "MnoDmViewer"
        "MnoDmClient"
        "Notes40"
        "Netflix_activationCommon"
        "Netflix_stub"
        "OpenCalendar"
        "PhotoTable"
        "PartnerBookmarksProvider"
        "PlayAutoInstallConfig"
        "SamsungOne"
        "SecFactoryPhoneTest"
        "SilentLog"
        "SmartSwitchAgent"
        "SLocation"
        "WebManual"
        "VZMessages"
        "WlanTest"
        "YouTube"
    )

    local privilaged_apps=(
        "APNWidgetBaseRoot_ATT"
        "ATTAPNWidget_ATT"
        "AttTvMode"
        "AppUpdateCenter"
        "DeviceBasedServiceConsent"
        "DeviceQualityAgent"
        "DeviceTest"
        "DynamicLockscreen"
        "DumpCollector"
        "EasySetup"
        "FactoryTestProvider"
        "FBInstaller_NS"
        "Fast"
        "Fmm"
        "FotaAgent"
        "GooglePartnerSetup"
        "GoogleRestore"
        "HuxPlatform"
        "HwModuleTest"
        "ImsLogger"
        "LogWriter"
        "LTETest"
        "ModemServiceMode"
        "MemorySaver_O_Refresh"
        "NSDSWebApp"
        "NetworkDiagnostic"
        "PreloadInstaller"
        "PhoneErrService"
        "SNP"
        "SOAgent"
        "SPPPushClient"
        "SamsungSmartSuggestions"
        "SamsungCoreServices-Stub"
        "SettingsBixby"
        "SetupWizard_USA"
        "SmartSwitchAssistant"
        "SoftphoneAccount"
        "SsuService"
        "serviceModeApp_FB"
        "StoryService"
        "SmartEpdgTestApp"
        "TADownloader"
        "Velvet"
        "UserDictionaryProvider"
        "YourPhone_Stub"
        "VzCloud"
    )

    local system_extra_privilaged_apps=(
        "GoogleFeedback"
    )

    local product_apps=(
        "Chrome"
        "DuoStub"
        "Gmail*"
        "Maps"
        "YouTube"
    )

    local product_privilaged_apps=(
        "GooglePartnerSetup"
        "Velvet"
        "GoogleRestore"
    )

    # bomb.
    for i in "${HORIZON_SYSTEM_DIR}/app/${app[@]}" "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[@]}" \
    "${HORIZON_SYSTEM_EXT_DIR}/priv-app/${system_extra_privilaged_apps[@]}" "${HORIZON_PRODUCT_DIR}/app/${product_apps[@]}" \
    "${HORIZON_PRODUCT_DIR}/priv-app/${product_privilaged_apps[@]}"; do
    debugPrint "debloat_the_crap(): Removing ${i}..."
    if [ -d "${i}" ]; then
        rm -rf "${i}" 2>>./$thisConsoleTempLogFile
    else
        debugPrint "Couldn't find this application to remove, don't worry, i will debloat it somehow :D"
    fi
    done
    for unknown in ${HORIZON_SYSTEM_DIR}/app/SBrowser* ${HORIZON_SYSTEM_DIR}/app/SamsungTTS* ${HORIZON_SYSTEM_DIR}/priv-app/BixbyVisionFramework* \
    ${HORIZON_SYSTEM_DIR}/priv-app/GalaxyAppsWidget* ${HORIZON_SYSTEM_DIR}/priv-app/GalaxyApps* ${HORIZON_SYSTEM_DIR}/priv-app/OneDrive* \
    ${HORIZON_SYSTEM_DIR}/priv-app/SecCalculator* ${HORIZON_SYSTEM_DIR}/priv-app/UltraDataSaving*; do
        debugPrint "debloat_the_crap(): Removing ${unknown}..."
        [ -d "${unknown}" ] && rm -rf ${unknown} 2>>./$thisConsoleTempLogFile
    done
}

nuke_or_ignore_these_stuffs() {
    local app=(
        "AASAservice" # 0
        "AllShareAware" # 1
        "AllshareFileShare" # 2
        "AllshareMediaShare" # 3
        "ARCore" # 4
        "ARZone" # 5
        "StickerCenter" # 6
        "PrintSpooler" # 7
        "GooglePrintRecommendationService" # 8
    )

    local privilaged_apps=(
        "AREmoji" # 0
        "AREmojiEditor" # 1
        "sticker" # 2
        "ThemeCenter" # 3
        "BuiltInPrintService" # 4
        "LiveStickers" # 5
        "StickerFaceARAvatar" # 6
        "SecureFolder" # 7
        "SamsungDeviceHealthManagerService" # 8
        "ShareLive" # 9
        "Turbo" # 10
    )

    console_print "[WARNING] - These apps will potentially hurt device performance"
    console_print "            Type \'y\' to remove"
    console_print "            Type \'n\' to keep them"
    ask "Do you want to remove Samsung Weather app" && rm -rf "${HORIZON_SYSTEM_DIR}/app/SamsungWeather" 2>./error_ring.log 
    if ask "Do you want to remove Samsung Sharing tools"; then
        for ((i = 0; i < 4; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/${app[$i]}"
        done
        rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/ShareLive"
    fi
    if ask "Do you want to remove Samsung AR Camera Plugins"; then
        for ((i = 4; i < 7; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/app/${app[$i]}"
        done
        for ((i = 5; i < 7; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[$i]}"
        done
    fi
    if ask "Do you want to remove printing tools from your system"; then
        for ((i = 7; i < 9; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/app/${app[$i]}"
        done
        rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[4]}"
    fi
    ask "Do you want to nuke Finder [heavy ram consuption, used to search apps in homescreen]" && rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/Finder"
    if ask "Do you want to nuke Game Launcher and Game Tools [performance will be doomed if you let it cook]"; then
        rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/GameHome" 2>./error_ring.log
        rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/GameOptimizingService" 2>./error_ring.log
        rm -rf ${HORIZON_SYSTEM_DIR}/priv-app/GameTools* 2>./error_ring.log
    fi
    ask "Do you want to nuke Device Care Plugin [performance will be doomed if you let it cook]" && rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[8]}"
    ask "Do you want to nuke Carrier Services such as ESIM and Wifi-Calling" && rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[10]}"
}
case "${BUILD_TARGET_SDK_VERSION}" in
    30|31|32|33|34|35)
        console_print "Debloating your ROM..."
        debloat_the_crap
        nuke_or_ignore_these_stuffs
        ;;
    29)
        console_print "Debloating your rom..."
        debloat_the_crap
        nuke_or_ignore_these_stuffs
        ;;
    28)
        console_print "The list haven't really focused for Android Pie because no one uses it nowadays, sorry.."
        debloat_the_crap
        nuke_or_ignore_these_stuffs
        ;;
    *)
        console_print "This version of android is not supported, please do a pr if you can, otherwise just report this issue to the bugreporter bot (link can be found in the readme)"
        ;;
esac