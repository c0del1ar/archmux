#!/bin/bash

app_install() {
	if [[ `command -v $1` ]]; then
		echo -e "$warn $1 was installed successfully."
		echo -e "$info Try upgrading it..."
	fi
	
	echo -e "$info Checking package availability..."
	if [[ `sudo pacman -Si $1 2>err.log` ]]; then
		echo -e "$info Installing package use ${C}pacman${reset}"
		execcom "sudo pacman -S $1"
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

vnc_set () {
	echo -e "$info Setting up Vnc server..."
	if [[ ! `command -v vncserver` ]]; then
		echo -e "$info Installing tigervnc..."
		execcom "sudo pacman -S tigervnc lightdm --noconfirm"
	fi
	
	echo "#!/bin/bash
[ -r ~/.Xresources ] && xrdb ~/.Xresources
export PULSE_SERVER=127.0.0.1
export DISPLAY=:1
XAUTHORITY=~/.Xauthority
export XAUTHORITY
$1" > /usr/local/bin/vncstart
	chmod +x /usr/local/bin/vncstart
	echo "#!/bin/bash
vncserver -geometry 1280x720 -listen tcp :1
DISPLAY=:1 xhost +" > /data/data/com.termux/files/usr/bin/vncstart
	chmod +x /data/data/com.termux/files/usr/bin/vncstart
}

sound_set() {
	echo -e "$info Setting up sound..."
	echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/archlogin)" > /data/data/com.termux/files/usr/bin/archlogin
}

# is like yay -S
yoi() {
	if [[ $1 == "" ]]; then
		exit 0;
	fi

	if [[ ! `command -v git` ]]; then
		echo -e "$info Downloading git uses for AUR package builder..."
		sudo pacman -S git
	fi
	
	git clone https://aur.archlinux.org/$1.git
	cd $1
	echo -e "$info Initializing package source..."
	source PKGBUILD
	
	if [[ ! "${arch[@]}" =~ "$myarch" && ! "${arch[@]}" =~ "any" ]]; then
		echo -e "$err Architectur doesn't match!"
		echo -e "$warn Bypassing architectur support, this may break some package(s)..."
		sed -i -e 's/arch=\((.*)\)/arch=\(any\)/g' PKGBUILD
	fi

	echo -e "$info Installing missing dependencies..."
	for dep in "${depends[@]}"; do
		echo -e "$info Installing $dep..."
		sudo pacman -S $dep --noconfirm 2> err.log
		if [[ `cat err.log | grep -E "target not found"` ]]; then
			IFS=': ' read -ra strings <<< $(cat err.log | grep -oE "found.*")
			pacname=$(sed 's/=.*//' <<< $(sed 's/<.*//' <<<  $(sed 's/>.*//' <<< $(echo "${strings[1]}" | grep -Po ".*"))))
			rm err.log
			echo -e "$warn ${C}$pacname${reset} seems like an AUR package..."
			yoi $pacname
		fi
	done
	makepkg -si --noconfirm
	cd ../
	sudo rm -rf $1
}