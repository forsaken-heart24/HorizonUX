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

# device blob path and etc...
BUILD_TARGET_BLOB_PATH="./target/r8q/patches/stock_blobs"

if [[ "$(grep_prop "ro.product.vendor.device" "$HORIZON_VENDOR_PROPERTY_FILE")" == *"a23"* && -f "${VENDOR_DIR}/etc/fstab.qcom" ]]; then
    console_print "Customizing experience for Galaxy A23..."
    setprop --custom "${VENDOR_DIR}/default.prop" "log.tag.stats_log" "D"
    setprop --custom "${VENDOR_DIR}/default.prop" "persist.sys.usb.config" "mtp,adb"
    boolReturn "${BUILD_TARGET_ADD_FRAMEWORK_OVERLAY_TO_FIX_CUTOUT}" && build_and_sign "./target/a23/overlay/framework-res/" "${VENDOR_DIR}"
    replaceTargetBuildProperties "a23"
fi