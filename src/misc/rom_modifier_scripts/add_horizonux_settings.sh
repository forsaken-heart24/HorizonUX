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

# Check if the correct number of arguments is provided
XML_FILE="$1"
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <XML file>"
    exit 1
fi
REFERENCE_ONE='<SecPreference android:icon="@drawable/sec_ic_settings_connections" android:title="@string/tab_category_connections" android:key="top_level_connections" android:summary="@string/summary_placeholder" android:order="-500000" android:fragment="com.samsung.android.settings.connection.ConnectionsSettings" settings:controller="com.samsung.android.settings.homepage.TopLevelConnectionsPreferenceController" settings:keywords="@string/keywords_connections_settings" />'
NEW_ENTRY='<SecPreferenceScreen android:icon="@drawable/sec_ic_settings_connections" android:title="HorizonUX Settings" android:key="horizonux_artillery" android:summary="yet another oneui rom which has some customization things" android:order="-490000" android:fragment="com.focus.Item3" />'
TEMP_FILE="temp.xml"
LINES=( $(cat "$XML_FILE") )
FOUND=0
for (( i=0; i<${#LINES[@]}; i++ )); do
    echo "${LINES[$i]}" >> "$TEMP_FILE"
    if [[ "${LINES[$i]}" == "$REFERENCE_ONE" ]]; then
        echo "$NEW_ENTRY" >> "$TEMP_FILE"
        FOUND=1
    fi
done
mv "$TEMP_FILE" "$XML_FILE"