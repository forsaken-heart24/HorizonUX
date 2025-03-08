if [[ ! -f "./dependencies/util_functions.sh" ]]; then
	echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] [:\e[0;36mABORT\e[0;37m:] -\e[0;31m Can't find functions wrapper script, please try again later...\e[0;37m"
	sleep 0.5
	exit 1
else 
	source ./dependencies/util_functions.sh
fi

if [[ ! -f "./dependencies/makeconfigs.prop" ]]; then
	abort "Can't find makeconfigs file, please try again later..."
else 
	source ./dependencies/makeconfigs.prop
fi

n=0
if strings ${SYSTEM_DIR}/framework/framework.jar | grep "onEngineGetCertificateChain"; then
	warns "onEngineGetCertificateChain detected!!!!"
	n="$((n + 1))"
fi

if strings ${SYSTEM_DIR}/framework/framework.jar | grep "PixelPropsUtils"; then
	warns "PixelPropsUtils detected!!!!"
	n="$((n + 1))"
fi

if find ${SYSTEM_DIR}/ -iname "*lineage*" 2>/dev/null; then
	warns "LineageOS detected!!!!"
	n="$((n + 1))"
fi

if [[ "${n}" -ge "1" ]]; then
	warns "Modifications on the environment has been detected!!!!!!"
else
	console_print "System image haven't been modified."
fi

console_print "Special Thanks to gawas vedraj from telegram!!!!!!!"