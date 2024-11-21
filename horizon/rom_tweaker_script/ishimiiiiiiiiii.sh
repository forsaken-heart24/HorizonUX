function grep_prop() {
	local variable_name=$1
	local prop_file=$2
	if [ -z "$variable_name" ]; then
		echo "Invalid handler request!"; exit 1
	elif [ ! -f "$prop_file" ]; then
		echo "Prop file wasn't found!"; exit 1
	fi
	echo $(grep "$variable_name" $prop_file | cut -d '=' -f 2 | sed 's/"//g')
}

function restart_audioserver() {
    # Wait for system boot completion and audioserver to boot up
    for i in `seq 1 5`; do
        if [ "`getprop sys.boot_completed`" = "1" ] && [ -n "`getprop init.svc.audioserver`" ]; then
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
    else
        return 1
    fi
}

function resampler_fix() {
    resetprop --delete ro.audio.resampler.psd.enable_at_samplerate
    resetprop --delete ro.audio.resampler.psd.stopband
    resetprop --delete ro.audio.resampler.psd.halflength
    resetprop --delete ro.audio.resampler.psd.cutoff_percent
    resetprop --delete ro.audio.resampler.psd.tbwcheat
    resetprop ro.audio.resampler.psd.enable_at_samplerate 44100
    resetprop ro.audio.resampler.psd.stopband 194
    resetprop ro.audio.resampler.psd.halflength 520
    resetprop ro.audio.resampler.psd.cutoff_percent 85
}

function is_boot_completed() {
	if [ "$(getprop sys.boot_completed)" == "1" ]; then
		return 0
	else 
		return 1
	fi
}

function is_bootanimation_exited() {
	if [ "$(getprop service.bootanim.exit)" == "1" ]; then
		return 0
	else 
		return 1
	fi
}

# let's change the default theme to dark, Thanks to nobletaro for the idea!
if [ "$(settings get secure device_provisioned)" == "0" ]; then
    settings put secure ui_night_mode 2
    cmd uimode night yes
fi

# spoof the device to green state, making it seem like an locked device.
if is_bootanimation_exited; then
	resetprop -n ro.boot.verifiedbootstate green
	return 0
fi

# let's initialize the resampler thing.
if [ "$(grep_prop "persist.horizonux.audio.resampler" "/system/build.prop")" == "available" ]; then
	if is_boot_completed; then
		resampler_fix
		restart_audioserver
	fi
	return 0
fi

# GMS-DOZE
# Disable collective device administrators for all users
for U in $(ls /data/user); do
    for C in "auth.managed.admin.DeviceAdminReceiver" "mdm.receivers.MdmDeviceAdminReceiver"; do
        pm disable --user $U com.google.android.gms/com.google.android.gms.$C
    done
done