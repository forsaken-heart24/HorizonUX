#!/usr/bin/env bash
#
# Copyright (C) 2024 Fede2782
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

# Debloat list for Galaxy A23 5G (a23xq)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# bloats:
SYSTEM_DEBLOAT=(
    "app/ESEServiceAgent"
    "app/MoccaMobile"
    "app/WifiRROverlayAppH2E"
    "app/WifiRROverlayAppQC"
    "app/WifiRROverlayAppWifiLock"
    "bin/esecos_daemon"
    "bin/sem_daemon"
    "bin/dhkprov"
    "bin/qchdcpkprov"
    "etc/init/dhkprov.rc"
    "etc/permissions/privapp-permissions-com.samsung.android.app.aodservice.xml"
    "etc/permissions/privapp-permissions-com.samsung.android.photoremasterservice.xml"
    "etc/permissions/privapp-permissions-com.samsung.android.singletake.service.xml"
    "etc/permissions/cameraservice.xml"
    "etc/permissions/org.carconnectivity.android.digitalkey.rangingintent.xml"
    "etc/permissions/org.carconnectivity.android.digitalkey.secureelement.xml"
    "etc/default-permissions/default-permissions-com.samsung.android.singletake.service.xml"
    "etc/init/esecos.rc"
    "etc/init/sem.rc"
    "etc/permissions/privapp-permissions-com.sec.factoryapp.xml"
    "lib/libsec_sem.so"
    "lib/libsec_semHal.so"
    "lib/libsec_semRil.so"
    "lib/libsec_semTlc.so"
    "lib/libspictrl.so"
    "lib/vendor.samsung.hardware.security.sem@1.0.so"
    "lib64/libsec_sem.so"
    "lib64/libsec_semHal.so"
    "lib64/libsec_semRil.so"
    "lib64/libsec_semTlc.so"
    "lib64/libspictrl.so"
    "lib64/vendor.samsung.hardware.security.sem@1.0.so"
    "lib64/vendor.samsung.hardware.security.hdcp.keyprovisioning@1.0.so"
    "framework/scamera_sep.jar"
    "priv-app/GameDriver-SM8550"
    "priv-app/AODService_v80"
    "priv-app/PhotoRemasterService"
    "priv-app/SumeNNService"
    "priv-app/SingleTakeService"
    "priv-app/SCameraSDKService"
    "priv-app/SEMFactoryApp"
)

SYSTEM_EXT_DEBLOAT=(
    "app/QCC"
    "bin/qccsyshal@1.2-service"
    "etc/permissions/com.qti.location.sdk.xml"
    "etc/permissions/com.qualcomm.location.xml"
    "etc/permissions/privapp-permissions-com.qualcomm.location.xml"
    "framework/com.qti.location.sdk.jar"
    "framework/org.carconnectivity.android.digitalkey.rangingintent.jar"
    "framework/org.carconnectivity.android.digitalkey.secureelement.jar"
    "framework/oat/arm/com.qti.location.sdk.art"
    "framework/oat/arm/com.qti.location.sdk.odex"
    "framework/oat/arm/com.qti.location.sdk.vdex"
    "framework/oat/arm/org.carconnectivity.android.digitalkey.rangingintent.odex"
    "framework/oat/arm/org.carconnectivity.android.digitalkey.rangingintent.vdex"
    "framework/oat/arm/org.carconnectivity.android.digitalkey.secureelement.odex"
    "framework/oat/arm/org.carconnectivity.android.digitalkey.secureelement.vdex"
    "framework/oat/arm64/com.qti.location.sdk.art"
    "framework/oat/arm64/com.qti.location.sdk.odex"
    "framework/oat/arm64/com.qti.location.sdk.vdex"
    "framework/oat/arm64/org.carconnectivity.android.digitalkey.rangingintent.odex"
    "framework/oat/arm64/org.carconnectivity.android.digitalkey.rangingintent.vdex"
    "framework/oat/arm64/org.carconnectivity.android.digitalkey.secureelement.odex"
    "framework/oat/arm64/org.carconnectivity.android.digitalkey.secureelement.vdex"
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
    "overlay/SoftapOverlayOWE"
    "overlay/SoftapOverlay6GHz"
)

if [ ! "$(grep_prop "ro.product.vendor.device" $HORIZON_VENDOR_PROPERTY_FILE)" == "a23" ]; then
    debugPrint "This device is not Galaxy A23, switching to generic debloat script.."
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