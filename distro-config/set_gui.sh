#!/bin/bash

source vars.sh
source apps.sh
source desktop.sh

gui_setup() {
	de_menu=("XFCE" "XFCE/Openbox" "KDE/Plasma", "GNOME")
	wm_menu=("Openbox")
	other_menu=("Openbox (${G}@owl4ce/dotfiles${reset})"
				"Openbox (${G}@ilham25/dotfiles-openbox${reset})")
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
		2) openbox_install && xfce_install ;;
		3) plasma_install ;;
		4) gnome_install ;;
		5) openbox_install ;;
		6) owl4ce_dotfiles ;;
		7) ilham25_dotfiles ;;
		*) echo -e "$err Cancelling..." && sleep 1;;
	esac
	printf "$quest Back to menu (enter): "
	read noRet
}

app_list() {
	echo -e "$info Listing..."
	menus=(Exit Chromium Firefox Sublime VSCode)
	while [[ True ]]; do
		for ((i=0; i<${#menus[@]}; i++)); do
			echo -e "   $i) ${menus[$i]}"
		done
		printf "$quest Choose what you want to install (1-$((${#menus[@]}-1))): "
		read mychoice
		case "$mychoice" in
			0) echo -e "$info Exitting..." && break;;
			1) app_install chromium ;;
			2) app_install firefox ;;
			3) app_install sublime-text-4 ;;
			4) app_install visual-studio-code-bin ;;
			*) echo -e "$err Input is not valid" ;;
		esac
	done
}

sound_set
check_update
while [[ True ]]; do
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