#!/bin/bash

check_update() {
	echo -e "$info Updating and upgrading installed system dependencies..."
	$sudo pacman -Syuu --noconfirm
}

app_install() {
	if [[ `command -v $1` ]]; then
		echo -e "$warn $1 was installed successfully."
		printf "$quest Wanna try upgrading it? (Y/n) : "
		read upgrading
		
		if [[ `echo "$upgrading" | tr '[:upper:]' '[:lower:]'` == "n" ]]; then
			echo -e "$info Cancelled"
			return 1
		fi
	fi
	
	echo -e "$info Checking package availability..."
	if [[ `pacman -Si $1 2>/dev/null` ]]; then
		echo -e "$info Installing package use ${C}pacman${reset}"
		execcom "$sudo pacman -S $1"
	else
		echo -e "$info Installing package use AUR git repository"
		if [[ ! `command -v yay` ]]; then
			echo -e "$warn YAY is not installed."
			echo -e "$info Using ${C}yoi()${reset} function installation..."
			yoi $1
		else
			echo -e "$info Install using yay..."
			execcom "yay -S $1"
		fi
	fi
}

sound_set() {
	ARCH_LOG_DIR=$(which archlogin)
	echo -e "$info Setting up sound..."
	if ! grep -Fxq "bash ~/.sound" $ARCH_LOG_DIR
	then
		echo "$(echo "bash ~/.sound" | cat - $ARCH_LOG_DIR)" > $ARCH_LOG_DIR
	fi
}

# yay -S or aur -S minimalist verse
yoi() {
	if [[ $1 == "" ]]; then
		echo -e "$err No package(s) to install... Use \`${C}yoi package1 package2 packageN${reset}\`"
		return 1
	fi

	if [[ ! `command -v git` || ! `command -v fakeroot` ]]; then
		echo -e "$info Downloading package uses for AUR package builder..."
		$sudo pacman -S git base-devel --noconfirm
	fi
	
	for dep_lib in "$@"; do
		git clone https://aur.archlinux.org/$dep_lib.git
		cd $dep_lib
		echo -e "$info Initializing package source..."
		source PKGBUILD
		
		if [[ ! "${arch[@]}" =~ "$myarch" || ! "${arch[@]}" =~ "any" ]]; then
			echo -e "$err Architectur doesn't match!"
			echo -e "$warn Bypassing architectur support, this may break some package(s)..."
			sed -i -e 's/arch=\((.*)\)/arch=\(any\)/g' PKGBUILD
		fi
		
		echo -e "$info Installing missing dependencies..."
		for dep in "${depends[@]}"; do
			printf "$info Checking $dep... "
			if [[ `pacman -Q $dep 2>/dev/null` ]]; then
				printf "was ${G}Installed${reset}! Skipping...\n"
			else
				printf "is ${R}not Installed${reset}, Installing...\n"
				$sudo pacman -S $dep --noconfirm 2> err.log
				if [[ `cat err.log | grep -E "target not found"` ]]; then
					IFS=': ' read -ra strings <<< $(cat err.log | grep -oE "found.*")
					pacname=$(sed 's/=.*//' <<< $(sed 's/<.*//' <<<  $(sed 's/>.*//' <<< $(echo "${strings[1]}" | grep -Po ".*"))))
					rm err.log
					echo -e "$warn ${C}$pacname${reset} seems like an AUR package..."
					yoi $pacname
				fi
			fi
		done
		
		makepkg -si --noconfirm
		cd ../
		$sudo rm -rf $dep_lib
	done
}