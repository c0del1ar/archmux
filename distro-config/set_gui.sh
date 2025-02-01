#!/bin/bash

source vars.sh
source apps.sh
source desktop.sh
source services.sh

gui_setup() {
	de_menu=("XFCE" "KDE/Plasma", "GNOME")
	wm_menu=("Openbox")
	other_menu=("Openbox (${G}github.com/owl4ce/dotfiles${reset})"
				"Openbox (${G}github.com/ilham25/dotfiles-openbox${reset})")
	echo -e "$info Choose what you want to set desktop GUI"
	k=1
	echo "- SELF SETUPS"
	echo "--- Desktop Environment setup"
	for ((i=0; i<${#de_menu[@]}; i++)); do
		echo -e "      $k.) ${de_menu[$i]}"
		k=$(($k+1))
	done
	echo "--- Window Manager"
	for ((i=0; i<${#wm_menu[@]}; i++)); do
		echo -e "      $k.) ${wm_menu[$i]}"
		k=$(($k+1))
	done
	echo "- OTHER SETUPS"
	for ((i=0; i<${#other_menu[@]}; i++)); do
		echo -e "      $k.) ${other_menu[$i]}"
		k=$(($k+1))
	done
	printf "$quest Your Option (1,2-5): "
	read mychoice
	case "$mychoice" in
		1) xfce_install ;;
		2) plasma_install ;;
		3) gnome_install ;;
		4) openbox_install ;;
		5) owl4ce_dotfiles ;;
		6) ilham25_dotfiles ;;
		*) echo -e "$err Cancelling..." && sleep 1;;
	esac
	printf "$quest Back to menu (enter): "
	read noRet
}

app_list() {
	echo -e "$info Listing..."
	declare -A menus=(
		[1]=Chromium
		[2]=Firefox
		[3]="Sublime Text"
		[4]="Visual Studio Code"
		[5]=LibreOffice
		[6]=GIMP
		[7]="VLC Media Player"
		[8]=Blender
	)
	menu_alias=(
		[3]=sublime-text-4
		[4]=visual-studio-code-bin
		[5]=libreoffice-fresh
		[7]=vlc
	)
	echo "0) Exit"
	for ((i=0; i<${#menus[@]}; i++)); do
        echo "$((i+1))) ${menus[$((i+1))]}"
    done
	while true; do
		printf "$quest Choose what you want to install (e.g. (1, 2-4, 1-5, 3)): "
		read mychoice
		if [[ $mychoice =~ ^([0-9]+)-([0-9]+)$ ]]; then
			start=${BASH_REMATCH[1]}
			end=${BASH_REMATCH[2]}
			if (( start <= end )) && (( end <= ${#menus[@]} )); then
				for (( i=start; i<=end; i++ )); do
					app=$(echo "${menus[$i]}" | tr '[:upper:]' '[:lower:]')
					if [[ ${menu_alias[$i]} ]]; then
						app=${menu_alias[$i]}
					fi
					
					app_install "$app"
				done
				printf "$info Installations complete.\n"
				break
			else
				printf "$err Range not defined!\n"
			fi
		elif [[ $mychoice =~ ^[0-9]+$ ]] && ((mychoice <= ${#menus[@]})); then
			if ((mychoice == 0)); then
				printf "$info Exiting...\n"
				break
			fi
			
			app=$(echo "${menus[$mychoice]}" | tr '[:upper:]' '[:lower:]')
			if [[ ${menu_alias[$mychoice]} ]]; then
				app=${menu_alias[$mychoice]}
			fi
			if [ -z "$app" ]; then
				printf "$err Invalid choice\n"
			else
				app_install "$app"
				break
			fi
		else
			printf "$err Invalid input\n"
		fi
	done
}


sound_set
check_update
while true; do
	banner
	echo ""
	echo "+----+--------------------+
| No |      Options       |
+----+--------------------+
| 1  | Desktop/GUI Setups |
| 2  |    Install Apps    |
| 3  |  Info / Tutorials  |
| E  |     Quit / Exit    |
+----+--------------------+"
	printf "$quest Choose what you want to do?: "
	read menu_choice
	case "$menu_choice" in
		1) gui_setup ;;
		2) app_list ;;
		3) cat INFO.md && exit 0 ;;
		E|e|*) echo -e "$info Exitting menu..."
			exit 0 ;;
	esac
done
rm ~/distro-config/err.log
