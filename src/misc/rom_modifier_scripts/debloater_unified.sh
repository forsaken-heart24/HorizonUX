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
        "SBrowser*"
        "SamsungOne"
        "SamsungTTS*"
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
        "BixbyVisionFramework*"
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
        "GalaxyAppsWidget*"
        "GalaxyApps*"
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
        "OneDrive*"
        "PreloadInstaller"
        "PhoneErrService"
        "SNP"
        "SOAgent"
        "SPPPushClient"
        "SamsungSmartSuggestions"
        "SamsungCoreServices-Stub"
        "SecCalculator*"
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
        "UltraDataSaving*"
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
    warns "Removing ${i}..." "HorizonDebloater"
    if [ -f ${i} ]; then
        rm -rf ${i} 2>./error_ring.log
    else
        console_print "Couldn't find this application to remove, don't worry, i will debloat it somehow :D"
    fi
    done
}

nuke_or_ignore_these_stuffs() {
    local app=(
        "AASAservice"
        "AllShareAware"
        "AllshareFileShare"
        "AllshareMediaShare"     
        "ARCore"
        "ARZone"
        "StickerCenter"
        "PrintSpooler"
        "GooglePrintRecommendationService"
    )

    local privilaged_apps=(
        "AREmoji" 
        "AREmojiEditor" 
        "sticker"
        "ThemeCenter"
        "BuiltInPrintService" 
        "Finder" 
        "GameHome" 
        "GameOptimizingService" 
        "GameTools*" 
        "LiveStickers"
        "StickerFaceARAvatar"
        "SecureFolder"
        "SamsungDeviceHealthManagerService"
        "ShareLive"
        "Turbo"
    )

    console_print "[WARNING] - These apps will potentially hurt device performance"
    console_print "            Type \'y\' to NUKE IT"
    console_print "            Type \'n\' to LET IT COOK!"
    ask "Do you want to remove Samsung Weather app" && rm -rf "${HORIZON_SYSTEM_DIR}/app/SamsungWeather" 2>./error_ring.log 
    if ask "Do you want to remove Samsung Sharing tools"; then
        for ((i = 0; i < 4; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/${app[$i]}"
        done
        rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/ShareLive"
    fi
    if ask "Do you want to remove Samsung AR Camera Plugins"
        for ((i = 4; i < 7; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/app/${app[$i]}"
        done
        for ((i = 4; i < 7; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[$i]}"
        done
    fi
    if ask "Do you want to remove printing tools from your system"; then
        for ((i = 7; i < 9; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/app/${app[$i]}"
        done
        rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[4]}"
    fi
    console_print "Do you want to remove Device care plugin"
    if ask "Do you still want to nuke it or let it be in the system"; then
        for ((i = 4; i < 7; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[$i]}" 2>./error_ring.log
        done
    fi
    ask "Do you want to nuke Finder [heavy ram consuption, used to search apps in homescreen]" && rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/Finder"
    if ask "Do you want to nuke Game Launcher and Game Tools [performance will be doomed if you let it cook]"; then
        for ((i = 4; i < 7; i++)); do
            rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[$i]}" 2>./error_ring.log
        done
    fi
    ask "Do you want to nuke Device Care Plugin [performance will be doomed if you let it cook]" && rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[12]}"
    ask "Do you want to nuke Carrier Services such as ESIM and Wifi-Calling" && rm -rf "${HORIZON_SYSTEM_DIR}/priv-app/${privilaged_apps[14]}"
}

if [ "${BUILD_TARGET_SDK_VERSION}" -ge "30" ] && [ "${BUILD_TARGET_SDK_VERSION}" -le "34" ]; then
    console_print "Debloating your rom..."
    debloat_the_crap
    nuke_or_ignore_these_stuffs
elif [ "${BUILD_TARGET_SDK_VERSION}" -eq "29" ]; then
    console_print "The list haven't really focused for Android Pie because no one uses it nowadays, sorry.."
    console_print "Debloating your rom..."
    debloat_the_crap
    nuke_or_ignore_these_stuffs
else
    console_print "This version of android is not supported, please do a pr if you can, otherwise just report this issue to the bugreporter bot (link can be found in the github bio)"
fi