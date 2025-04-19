#!/usr/bin/env bash
#
# Copyright (C) 2024 Salvo Giangreco
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

# Debloat list for Galaxy S20 FE (Qualcomm) (r8q)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# bloats:
SYSTEM_DEBLOAT=(
    "system/app/WifiRROverlayAppH2E"
    "system/app/WifiRROverlayAppQC"
    "system/app/WifiRROverlayAppWifiLock"
    "system/bin/mafpc_write"
    "system/etc/default-permissions/default-permissions-com.samsung.android.globalpostprocmgr.xml"
    "system/etc/default-permissions/default-permissions-com.samsung.petservice.xml"
    "system/etc/default-permissions/default-permissions-com.samsung.videoscan.xml"
    "system/etc/permissions/privapp-permissions-com.samsung.android.globalpostprocmgr.xml"
    "system/etc/permissions/privapp-permissions-com.samsung.petservice.xml"
    "system/etc/permissions/privapp-permissions-com.samsung.videoscan.xml"
    "system/etc/permissions/org.carconnectivity.android.digitalkey.rangingintent.xml"
    "system/etc/permissions/org.carconnectivity.android.digitalkey.secureelement.xml"
    "system/priv-app/GameDriver-SM8550"
    "system/priv-app/GlobalPostProcMgr"
    "system/priv-app/PetService"
    "system/priv-app/VideoScan"
    "system/priv-app/SohService"
)

SYSTEM_EXT_DEBLOAT=(
    "app/QCC"
    "bin/qccsyshal@1.2-service"
    "etc/init/vendor.qti.hardware.qccsyshal@1.2-service.rc"
    "etc/permissions/com.qti.location.sdk.xml"
    "etc/permissions/com.qualcomm.location.xml"
    "etc/permissions/privapp-permissions-com.qualcomm.location.xml"
    "framework/com.qti.location.sdk.jar"
    "framework/org.carconnectivity.android.digitalkey.rangingintent.jar"
    "framework/org.carconnectivity.android.digitalkey.secureelement.jar"
    "lib/libqcc.so"
    "lib/libqcc_file_agent_sys.so"
    "lib/libqccdme.so"
    "lib/libqccfileservice.so"
    "lib/vendor.qti.hardware.qccsyshal@1.0.so"
    "lib/vendor.qti.hardware.qccsyshal@1.1.so"
    "lib/vendor.qti.hardware.qccsyshal@1.2.so"
    "lib/vendor.qti.hardware.qccvndhal@1.0.so"
    "lib/vendor.qti.hardware.trustedui@1.1.so"
    "lib/vendor.qti.hardware.trustedui@1.2.so"
    "lib/vendor.qti.qccvndhal_aidl-V1-ndk.so"
    "lib64/libqcc.so"
    "lib64/libqcc_file_agent_sys.so"
    "lib64/libqccdme.so"
    "lib64/libqccfileservice.so"
    "lib64/vendor.qti.hardware.qccsyshal@1.0.so"
    "lib64/vendor.qti.hardware.qccsyshal@1.1.so"
    "lib64/vendor.qti.hardware.qccsyshal@1.2-halimpl.so"
    "lib64/vendor.qti.hardware.qccsyshal@1.2.so"
    "lib64/vendor.qti.hardware.qccvndhal@1.0.so"
    "lib64/vendor.qti.hardware.trustedui@1.1.so"
    "lib64/vendor.qti.hardware.trustedui@1.2.so"
    "lib64/vendor.qti.qccvndhal_aidl-V1-ndk.so"
    "priv-app/com.qualcomm.location"
    "priv-app/com.qualcomm.qti.services.systemhelper"
)

PRODUCT_DEBLOAT=(
    "overlay/SoftapOverlay6GHz"
    "overlay/SoftapOverlayDualAp"
    "overlay/SoftapOverlayOWE"
)

if [ ! "$(grep_prop "ro.product.vendor.device" $HORIZON_VENDOR_PROPERTY_FILE)" == "r8q" ]; then
    debugPrint "This device is not Galaxy S20 FE, switching to generic debloat script.."
    . ${SCRIPTS[5]}
elif [ ! "${BUILD_TARGET_SDK_VERSION}" == "35" ]; then
    debugPrint "This rom is not Android 15, switching to generic debloat script.."
    . ${SCRIPTS[5]}
fi

for systemBloats in ${SYSTEM_DEBLOAT[@]}; do
    [ -f "${SYSTEM_DIR}/${systemBloats}" ] || continue
    if rm -rf "${SYSTEM_DIR}/${systemBloats}"; then
        debugPrint "Removed ${systemBloats}"
    else
        debugPrint "Failed to remove ${systemBloats}"
    fi
done

for systemEtceteraBloats in ${SYSTEM_EXT_DEBLOAT[@]}; do
    [ -f "${SYSTEM_EXT_DIR}/${systemEtceteraBloats}" ] || continue
    if rm -rf "${SYSTEM_EXT_DIR}/${systemEtceteraBloats}"; then
        debugPrint "Removed ${systemEtceteraBloats}"
    else
        debugPrint "Failed to remove ${systemEtceteraBloats}"
    fi
done

for productBloats in ${PRODUCT_DEBLOAT[@]}; do
    [ -f "${PRODUCT_DIR}/${productBloats}" ] || continue
    if rm -rf "${PRODUCT_DIR}/${productBloats}"; then
        debugPrint "Removed ${productBloats}"
    else
        debugPrint "Failed to remove ${productBloats}"
    fi
done