#!/system/bin/sh

# Copyright (C) 2025 BrotherBoard & Luna
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

new=""
old=""
while true; do
    sleep 0.2
    old_prop_value=$(getprop | grep 'screen_state' | grep '1')
    if [ "$old_prop_value" != "1" ]; then
        if [ -n "$new" ]; then
            su -c 'echo check_connection > /sys/class/sec/tsp/cmd'
            new="$old"
        fi
    fi
done
echo "$?" > /sdcard/.brotherboard_touch_fix_pid
echo "$?" > /data/local/tmp/.brotherboard_touch_fix_pid

pm list packages | grep -q bellavita.toast && am start -a android.intent.action.MAIN -e toasttext "Be gone, touch issues! Thanks to the brotherboard." -n bellavita.toast/.MainActivity