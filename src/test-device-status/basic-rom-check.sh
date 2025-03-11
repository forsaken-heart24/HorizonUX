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

if [[ ! -f "./dependencies/util_functions.sh" ]]; then
	echo -e "[\e[0;35m$(date +%d-%m-%Y) \e[0;37m- \e[0;32m$(date +%H:%M%p)] [:\e[0;36mABORT\e[0;37m:] -\e[0;31m Can't find functions wrapper script, please try again later...\e[0;37m"
	sleep 0.5
	exit 1
else 
	source ./dependencies/util_functions.sh
fi

n=0
if strings ${SYSTEM_DIR}/framework/framework.jar | grep "onEngineGetCertificateChain"; then
	warns "onEngineGetCertificateChain detected!!!!" "BASIC_ROM_CHECK"
	n="$((n + 1))"
fi

if strings ${SYSTEM_DIR}/framework/framework.jar | grep "PixelPropsUtils"; then
	warns "PixelPropsUtils detected!!!!" "BASIC_ROM_CHECK"
	n="$((n + 1))"
fi

if find ${SYSTEM_DIR}/ -iname "*lineage*" 2>/dev/null; then
	warns "LineageOS detected!!!!" "BASIC_ROM_CHECK"
	n="$((n + 1))"
fi

if [[ "${n}" -ge "1" ]]; then
	warns "Modifications on the environment has been detected!!!!!!"
else
	console_print "System image haven't been modified."
fi

console_print "Special Thanks to Gawas Vedraj for the base script!"