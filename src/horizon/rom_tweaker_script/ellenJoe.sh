#!/system/bin/sh

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

function grep_prop() {
	local variable_name=$1
	local prop_file=$2
	local args="$#"
	if [ ! "$args" -eq '2' ]; then
		return 1
	fi
    [ -z "$prop_file" ] && prop_file=/system/build.prop 
	grep "$variable_name" $prop_file | cut -d '=' -f 2 | sed 's/"//g'
}

function restart_audioserver() {
    # Wait for system boot completion and audioserver to boot up
    for i in `seq 1 5`; do
        if [ "`getprop sys.boot_completed`" = '1' ] && [ -n "`getprop init.svc.audioserver`" ]; then
            break
        fi
        sleep 1.3
    done

    # Check if audioserver is running before restarting
    if [ -n "`getprop init.svc.audioserver`" ]; then
        # Restart audioserver if it's running
        setprop ctl.restart audioserver
        sleep 0.2
        if [ "`getprop init.svc.audioserver`" != "running" ]; then
            # Workarounds for older devices where the audioserver hangs
            local pid="`getprop init.svc_debug_pid.audioserver`"
            if [ -n "$pid" ]; then
                kill -HUP $pid 1>/dev/null 2>&1
            fi
            for i in `seq 1 10`; do
                sleep 0.2
                if [ "`getprop init.svc.audioserver`" = "running" ]; then
                    break
                elif [ $i -eq 10 ]; then
                    return 1
                fi
            done
        fi
        return 0
    fi
    return 1
}

function is_boot_completed() {
    return $(if [ -z "$(getprop sys.boot_completed)" ]; then return 1; else echo "$(getprop service.bootanim.progress)"; fi)
}

function is_bootanimation_exited() {
    return $(if [ -z "$(getprop service.bootanim.exit)" ]; then return 1; else echo "$(getprop service.bootanim.progress)"; fi)
}

function bootanimStillRunning() {
    return $(if [ -z "$(getprop service.bootanim.progress)" ]; then return 1; else echo "$(getprop service.bootanim.progress)"; fi)
}

function string_case() {
    local smile="$(echo $1 | tr '[:upper:]' '[:lower:]')"
    local string="$2"
    case $smile in
        --lower*|-l*)
            echo "$string" | tr '[:upper:]' '[:lower:]'
        ;;
        --upper*|-u*)
            echo "$string" | tr '[:lower:]' '[:upper:]'
        ;;
        *)
            echo "$string"
        ;;
    esac
}

function horizon_log() {
    local message="$2"
    local service="$(string_case -u "$1")"
    if is_boot_completed; then
        pm list packages | grep -q bellavita.toast && am start -a android.intent.action.MAIN -e toasttext "$service: $message" -n bellavita.toast/.MainActivity
    else
        echo "/ [$(date +%H:%M%p)]-[$(date +%d-%m-%Y)] / $service / ${message} /" >> ${the_logfile}
    fi
}

function maybe_kill_daemons() {
    local daemon_name=$1
    local daemon_pid=$(pidof $daemon_name)
    if [ -z "${daemon_pid}" ]; then
        horizon_log "DAEMON_KILLER" "- The $daemon_name wasn't running or it's removed i guess, well uhh i can't do anything about. Sorry!"
    else
        if ! kill ${daemon_name}; then
            horizon_log "DAEMON_KILLER" "- The $daemon_name can't be killed, well uhh i can't do anything about. Sorry!"
        fi
    fi
}

function dawn() {
    local dir=$1
    local the_fifty_jeez=$(string_case -l $(du -h $dir | head -n 1 | cut -c 4-4))
    if echo $the_fifty_jeez | grep -q m ] || echo $the_fifty_jeez | grep -q g; then
        return 0
    fi
    return 1
}

function maybe_nuke_prop() {
    local variable="$@"
    if [[ ! -z "$(command -v resetprop)" && ! -z "$(resetprop $variable)" ]]; then
        if ! resetprop -d $variable; then
            horizon_log "resetprop_services" "Can't remove $variable for some unknown reason..."
        fi
    fi
}

function check_reset_prop() {
    local NAME=$1
    local EXPECTED=$2
    local VALUE=$(resetprop $NAME)
    [ -z $VALUE ] || [ $VALUE = $EXPECTED ] || resetprop $NAME $EXPECTED
}

########################################### main() #############################################
# let's change the default theme to dark, Thanks to nobletaro for the idea!
if [[ "$(getprop service.bootanim.progress)" == '1' && "$(settings get secure device_provisioned)" == '0' ]]; then
    settings put secure ui_night_mode 2
    cmd uimode night yes
fi

if [ "$(getprop persist.horizonux.ellen)" == "available" ]; then
    if is_boot_completed; then
        # we are gonna remove everything inside the dir if uhhh... it takes up an megabyte(s) of space
        if dawn "/data/media/0/Horizon/logs/"; then
            rm -rf /data/media/0/Horizon/logs/*
            the_logfile="/data/media/0/Horizon/logs/horizon_ellenJoe_tweaker_logs.log"
            horizon_log "ellenJoe" "The ROM decryped the storage, using the $the_logfile file to store logs..."
        else
            # let's cook an tmp file to save our logs because we have to save things on it
            # and after that we have to move it to the /data/media/0/Horizon/logs/ because we
            # still have no idea whether the device is freaking encrypted or not. You might say that
            # we can plug things but idc, im just gonna f'round with the temp file and fuckin' move
            # it to the directory.
            the_logfile=$(mktemp)
            horizon_log "ellenJoe" "using the $the_logfile file to store logs because the storage haven't decryped yet!"
        fi
        # spoof the device to green state, making it seem like an locked device.
        check_reset_prop "ro.boot.vbmeta.device_state" "locked"
        check_reset_prop "ro.boot.verifiedbootstate" "green"
        check_reset_prop "ro.boot.flash.locked" '1'
        check_reset_prop "ro.boot.veritymode" "enforcing"
        check_reset_prop "ro.boot.warranty_bit" '0'
        check_reset_prop "ro.warranty_bit" '0'
        check_reset_prop "ro.debuggable" '0'
        check_reset_prop "ro.secure" '1'
        check_reset_prop "ro.adb.secure" '1'
        check_reset_prop "ro.build.type" "user"
        check_reset_prop "ro.build.tags" "release-keys"
        check_reset_prop "ro.vendor.boot.warranty_bit" '0'
        check_reset_prop "ro.vendor.warranty_bit" '0'
        check_reset_prop "vendor.boot.vbmeta.device_state" "locked"
        check_reset_prop "vendor.boot.verifiedbootstate" "green"
        check_reset_prop "ro.secureboot.lockstate" "locked"
        # Hide that we booted from recovery when magisk is in recovery mode
        contains_reset_prop "ro.bootmode" "recovery" "unknown"
        contains_reset_prop "ro.boot.bootmode" "recovery" "unknown"
        contains_reset_prop "vendor.boot.bootmode" "recovery" "unknown"
        # nuke these mfs if they have any value
        maybe_nuke_prop persist.log.tag.LSPosed
        maybe_nuke_prop persist.log.tag.LSPosed-Bridge
        maybe_nuke_prop ro.build.selinux
        # let's try to disable user apps log visibitlity...
        for idkmanwtfdowhateveridcyouarebomblikemefrfr in $(pm list packages | cut -d':' -f2); do
            cmd package log-visibility --disable $idkmanwtfdowhateveridcyouarebomblikemefrfr || horizon_log "ellenJoe" "Can't disable logs for this application: ${idkmanwtfdowhateveridcyouarebomblikemefrfr}..."
        done
        # gms doze crap 
        horizon_log "GMSDoze" "Tweaking gms..."
        horizon_log "GMSDoze" "The logs of the tweaks can be seen below:"
        {
                # Disable collective device administrators for all users
                for U in $(ls /data/user); do
                    for C in "auth.managed.admin.DeviceAdminReceiver" "mdm.receivers.MdmDeviceAdminReceiver"; do
                        pm disable --user $U com.google.android.gms/com.google.android.gms.$C
                    done
                done
                # The GMS0 variable holds the Google Mobile Services package name
                GMS0="\"com.google.android.gms\""
                STR1="allow-unthrottled-location package=$GMS0"
                STR2="allow-ignore-location-settings package=$GMS0"
                STR3="allow-in-power-save package=$GMS0"
                STR4="allow-in-data-usage-save package=$GMS0"
                # Find all XML files under /data/adb directory (case-insensitive search for .xml files)
                find /data/adb/* -type f -iname "*.xml" -print |
                while IFS= read -r XML; do
                    for X in $XML; do
                    # If any of the defined strings (STR1, STR2, STR3, STR4) are found in the file,
                    # execute the following block
                    if grep -qE "$STR1|$STR2|$STR3|$STR4" $X 2>/dev/null; then
                        # Use sed to remove the matched strings from the XML file
                        # It deletes lines containing any of STR1, STR2, STR3, or STR4
                        sed -i "/$STR1/d;/$STR2/d;/$STR3/d;/$STR4/d" $X
                    fi
                    done
                done
                # Add GMS to battery optimization
                dumpsys deviceidle whitelist com.google.android.gms
        } >> ${the_logfile}
        if [ "$(grep_prop "persist.horizonux.audio.resampler")" == "available" ]; then
            horizon_log "horizonux_features_verifier" "The audio resampler is enabled in this build...."
            horizon_log "late_start_service" "Starting HorizonUX resampler..."
            resetprop ro.audio.resampler.psd.enable_at_samplerate 44100
            resetprop ro.audio.resampler.psd.stopband 194
            resetprop ro.audio.resampler.psd.halflength 520
            resetprop ro.audio.resampler.psd.cutoff_percent 85
            horizon_log "late_start_service" "Restarting audioserver to apply the changes in your device..."
            if restart_audioserver; then
                horizon_log "late_start_service" "audioserver restarted successfully..."
            else
                horizon_log "late_start_service" "failed to reboot audioserver, the resampler stuffs aren't saved.. sorryyy"
            fi
        fi
    fi
fi
########################################### main() #############################################

# let's clear the system logs and exit with '0' because we dont want to f-around things lol
logcat -c
exit 0