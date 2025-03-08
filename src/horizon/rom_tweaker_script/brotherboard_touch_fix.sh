#!/system/bin/sh

while true; do
    sleep 0.2
    old_prop_value=$(getprop | grep 'screen_state' | grep '1')
    if [ -z $old_prop_value ]; then
        if [ ! -z "$new" ]; then
            su -c 'echo check_connection > /sys/class/sec/tsp/cmd'
            new="$old"
        fi
    fi
done &

pm list packages | grep -q bellavita.toast && am start -a android.intent.action.MAIN -e toasttext "Be gone, touch issues! Thanks to the brotherboard." -n bellavita.toast/.MainActivity