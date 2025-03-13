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
BUILD_USER="$(id -un | cut -c 1-1 | tr '[:lower:]' '[:upper:]')$(id -un | cut -c 2-200)"
SOURCE_FILE="$1"
SOURCE_HEADER_PATH="$2"
SOURCE_NEEDS_CUSTOM_COMPILER=false

# let's source our util functions.
source ./misc/build_scripts/util_functions.sh || { echo "Please run this script in the HorizonUX cloned repo directory"; sleep 2; exit 1; }
for i in gcc g++; do 
	command -v $i &>/dev/null || abort "Please install dependencies like gcc and g++ to further use this script or edit the script to use other compilers."
done

# main shit starts from here.
echo " - Build initiated by ${BUILD_USER}"
if [[ "$SOURCE_NEEDS_CUSTOM_COMPILER" = "false" || -z "$SOURCE_NEEDS_CUSTOM_COMPILER" ]]; then	
	case "$(string_format -l "$SOURCE_FILE")" in 
		"--file")
			for i in "${SOURCE_FILE}"; do
				build_program "$i" "$SOURCE_HEADER_PATH" isLibrary=false
			done
		;;
		"--library")
			for i in "${SOURCE_FILE}"; do
				build_program "$i" "$SOURCE_HEADER_PATH" isLibrary=true
			done
		;;
		*)
			echo " - undefined statement, please use a defined statement."
		;;
	esac
fi