function main () {
    local i
    local wallpaper_count
    local special_symbol
	local index_score
    local the_homescreen_wallpaper_has_been_set=false
    local the_lockscreen_wallpaper_has_been_set=false
    local wallpaper_count_additional_int=00
	# the main stuff starts from here!
    printf "\e[1;36m - How many wallpapers do you need to add to the FLOSSPaper App?\e[0;37m "
    read wallpaper_count
    # failsafe, let's avoid weird values..
    if ! [[ "$wallpaper_count" =~ ^[0-9]+$ ]]; then
        echo -e "\e[0;31m - Invalid input. Please enter a valid number. Exiting...\e[0;37m"
        return 1
    fi
    rm -rf resources_info.json
    touch resources_info.json
    echo -e "{\n\t\"version\": \"0.0.1\",\n\t\"phone\": [" > resources_info.json
    echo -e " - Adding requested number of wallpapers to the list..\n"
    # Loop through each wallpaper
    for ((i=1; i<=wallpaper_count; i++)); do
        # Format wallpaper count for file names (ensure proper leading zeroes)
        if [ "$wallpaper_count" -ge 10 ]; then
            wallpaper_count_additional_int=0
        fi
        echo -e "\e[0;36m - Adding configurations for wallpaper_${wallpaper_count_additional_int}${i}.png.\e[0;37m"
		# increase the index score.
		index_score=${i}
        # Handle JSON commas for the last item
        if [ "$wallpaper_count" -eq "$i" ]; then
            special_symbol=""
        else
            special_symbol=","
        fi
        # Ask the user how to handle each wallpaper
        echo -e "\e[1;36m - What do you want to do with wallpaper_${wallpaper_count_additional_int}${i}.png?\e[0;37m"
        if ! $the_lockscreen_wallpaper_has_been_set; then
            echo "[1] - Set this as the default lockscreen wallpaper.."
        fi
        if ! $the_homescreen_wallpaper_has_been_set; then
            echo "[2] - Set this as the default homescreen wallpaper.."
        fi
        echo "[3] - Include this into the wallpaper lists.."
        printf "\e[1;36mType your answer here \e[0;37m- "
        read user_choice
        # Handle the user's choice for wallpaper action
        case "$user_choice" in
                1)
                    if ! $the_lockscreen_wallpaper_has_been_set; then
                        the_lockscreen_wallpaper_has_been_set=true
                        ADD_THE_WALLPAPER_METADATA "${wallpaper_count_additional_int}${i}" "lock" "$i"
                    else
                        ADD_THE_WALLPAPER_METADATA "${wallpaper_count_additional_int}${i}" "additionals" "$i"
                    fi
                ;;
                2)
                    if ! $the_homescreen_wallpaper_has_been_set; then
                        the_homescreen_wallpaper_has_been_set=true
                        ADD_THE_WALLPAPER_METADATA "${wallpaper_count_additional_int}${i}" "home" "$i"
                    else
                        ADD_THE_WALLPAPER_METADATA "${wallpaper_count_additional_int}${i}" "additionals" "$i"
                    fi
                ;;
                3)
                    ADD_THE_WALLPAPER_METADATA "${wallpaper_count_additional_int}${i}" "additionals" "$i"
                ;;
                *)
                    echo -e "\e[0;31m Invalid response! Please enter a valid option.\e[0;37m"
                    rm resources_info.json
					sleep 2
                    exit 1
                ;;
        esac
        echo -e "\e[0;36m - Finished adding configurations for wallpaper_${wallpaper_count_additional_int}${i}.png..\e[0;37m"
        echo ""
    done
        echo -e "  ]\n}" >> resources_info.json
        # Warning messages if default wallpapers were not set
        if ! $the_homescreen_wallpaper_has_been_set; then
            echo -e "\e[0;31m - Warning! The default homescreen wallpaper was not included in the lists.\e[0;37m"
        fi
        if ! $the_lockscreen_wallpaper_has_been_set; then
            echo -e "\e[0;31m - Warning! The default lockscreen wallpaper was not included in the lists.\e[0;37m"
        fi
}

# nein nein nein
sleep 0.5
console_print "Welcome to FLOSSPaper!"
console_print "Made by Luna (@forsaken-heart24 Github)"
main
echo -e "\e[0;31m"
echo "######################################################################"
echo "#                                                                    #"
echo "#       __        ___    ____  _   _ ___ _   _  ____ _               #"
echo "#       \ \      / / \  |  _ \| \ | |_ _| \ | |/ ___| |              #"
echo "#        \ \ /\ / / _ \ | |_) |  \| || ||  \| | |  _| |              #"
echo "#         \ V  V / ___ \|  _ <| |\  || || |\  | |_| |_|              #"
echo "#          \_/\_/_/   \_\_| \_\_| \_|___|_| \_|\____(_)              #"
echo "#                                                                    #"
echo "#                                                                    #"
echo "######################################################################"
echo -e "\e[1;36m"
echo -e "  Be sure to move the images to the drawable-nodpi/ folder with their appropriate names."
echo -e "\e[0;31m  This script is still in beta stages. Please check the \"res/raw/resources_info.json\" if you're concerned about issues."
echo -e "  Thanks for your time!\e[0;37m"