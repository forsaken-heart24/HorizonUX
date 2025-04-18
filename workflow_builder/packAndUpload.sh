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

# get stuffs
source ./src/target/${TARGET_DEVICE}/buildTargetProperties.conf

# build and upload the firmware
if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == "true" ]; then
    repackSuperFromDump "./local_build/workflow_builds/super.img"
    uploadGivenFileToTelegram "./local_build/workflow_builds/super.img" "Super image build for ${TARGET_DEVICE}"
if [ "${BUILD_TARGET_USES_DYNAMIC_PARTITIONS}" == "false" ]; then
    for images in ./local_build/workflow_partitions/*; do
        buildImage ${images}
    done
    for uploadCases in ./local_build/workflow_builds/*_built.img
        uploadGivenFileToTelegram "./local_build/workflow_builds/super.img" "$(basename ${uploadCases} .img) image build for ${TARGET_DEVICE}"
    done
fi
rm -rf ./local_build/*
console_print "Build finished at $(TZ=America/Phoenix date +%d\ %b\ %Y), $(TZ=America/Phoenix date +%I:%M%p) (Phoenix Standard Time)"