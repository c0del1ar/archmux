#!/bin/bash

#Window manager
openbox_install() {
	echo -e "$info Installing openbox window manager..."
	execcom "$sudo pacman -S openbox obconf dbus xorg xterm xfce4-terminal pcmanfm shotwell cairo-dock --noconfirm"
	vnc_set "dbus-launch openbox &
dbus-launch cairo-dock &"
}

#Desktop environment
xfce_install() {
	echo -e "$info Installing XFCE desktop..."
	execcom "$sudo pacman -S xfce4 xfce4-goodies lightdm --noconfirm"
	vnc_set "dbus-launch startxfce4 &"
}

plasma_install() {
	echo -e "$info Installing Plasma Desktop"
	execcom "$sudo pacman -S dbus xorg plasma-desktop --noconfirm"
	vnc_set "dbus-launch starplasma-x11 &"
}

gnome_install() {
	echo -e "$info Installing GNOME Desktop"
	execcom "$sudo pacman -S gnome-flashback gnome-terminal gnome-control-center terminator archlinux-wallpaper dconf-editor --noconfirm"
	$sudo pacman -S neofetch
	echo -e "$info Now you can configure your desktop yourself"
	vnc_set "rm -rf /run/dbus/pid
dbus-daemon --system
dbus-launch metacity &
dbus-launch gnome-panel &
dbus-launch gnome-flashback &"
}


#Other Setups

owl4ce_dotfiles() {
	if [[ ! `command -v yay` ]]; then
		echo -e "$warn This setup maybe requires YAY (${C}800MB${reset}) for better installation."
		printf "$quest Install it? (y/n): "
		read yayins
		case "$yayins" in
			Y|y)
				pacman -S git base-devel --needed --noconfirm
				git clone https://aur.archlinux.org/yay.git
				cd yay
				makepkg -si --noconfirm
				cd
				aur_install="yay -S" ;;
			*)
				echo -e "$warn Not installing yay.." 
				echo -e "$info Use ${C}yoi()${reset} instead..."
				aur_install="yoi" ;;
		esac
	else
		aur_install="yay -S"
	fi
	echo -e "$info Installing desktop environment and window manager..."
	$sudo pacman -S dunst nitrogen openbox rofi tint2 picom perl-gtk3 xdg-user-dirs --noconfirm
	echo -e "$info Installing all required bin packages..."
	$aur_install rxvt-unicode-truecolor
	$aur_install obmenu-generator
	$sudo pacman -S pulseaudio pulseaudio-alsa mpd mpc ncmpcpp \
			alsa-utils brightnessctl imagemagick scrot w3m wireless_tools xclip xsettingsd xss-lock \
			thunar thunar-archive-plugin thunar-volman ffmpegthumbnailer tumbler \
			geany geany-plugins gimp gsimplecal inkscape mpv parcellite pavucontrol viewnior xfce4-power-manager \
					--noconfirm
	
	echo -e "$info Installing fonts..."
	mkdir -pv ~/.fonts/{Cantarell,Comfortaa,IcoMoon-Custom,Nerd-Patched,Unifont}
	wget --no-hsts -cNP ~/.fonts/Comfortaa/ https://raw.githubusercontent.com/googlefonts/comfortaa/main/fonts/OTF/Comfortaa-{Bold,Regular}.otf
	wget --no-hsts -cNP ~/.fonts/IcoMoon-Custom/ https://github.com/owl4ce/dotfiles/releases/download/ng/{Feather,Material}.ttf
	wget --no-hsts -cNP ~/.fonts/Nerd-Patched/ https://github.com/owl4ce/dotfiles/releases/download/ng/M+.1mn.Nerd.Font.Complete.ttf
	wget --no-hsts -cNP ~/.fonts/Nerd-Patched/ https://github.com/owl4ce/dotfiles/releases/download/ng/{M+.1mn,Iosevka}.Nerd.Font.Complete.Mono.ttf
	wget --no-hsts -cNP ~/.fonts/Unifont/ https://unifoundry.com/pub/unifont/unifont-14.0.02/font-builds/unifont-14.0.02.ttf
	wget --no-hsts -cN https://download-fallback.gnome.org/sources/cantarell-fonts/0.303/cantarell-fonts-0.303.1.tar.xz
	tar -xvf cantarell*.tar.xz --strip-components 2 --wildcards -C ~/.fonts/Cantarell/ \*/\*/Cantarell-VF.otf
	
	echo -e "$info Installing icons..."
	mkdir -pv ~/.icons
	wget --no-hsts -cN https://github.com/owl4ce/dotfiles/releases/download/ng/{Gladient_JfD,Papirus{,-Dark}-Custom}.tar.xz
	tar -xf Gladient_JfD.tar.xz -C ~/.icons/
	tar -xf Papirus-Custom.tar.xz -C ~/.icons/
	tar -xf Papirus-Dark-Custom.tar.xz -C ~/.icons/
	$sudo ln -vs ~/.icons/Papirus-Custom /usr/share/icons/
	$sudo ln -vs ~/.icons/Papirus-Dark-Custom /usr/share/icons/
	
	echo -e "$info Installing wallpapers..."
	mkdir -pv ~/.wallpapers/{mechanical,eyecandy}
	wget --no-hsts -cNP ~/.wallpapers/mechanical/ https://github.com/owl4ce/dotfiles/releases/download/ng/{batik-1_4K,okita-souji_FHD}.jpg
	wget --no-hsts -cNP ~/.wallpapers/eyecandy/ https://github.com/owl4ce/dotfiles/releases/download/ng/{cherry-blossoms,floral-artistic-2}_FHD.jpg
	
	echo -e "$info Installing extensions (${C}URxvt${reset})..."
	mkdir -pv ~/.urxvt/ext
	(cd ~/.urxvt/ext/; curl -LO https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font)
	(cd ~/.urxvt/ext/; curl -LO https://raw.githubusercontent.com/mina86/urxvt-tabbedex/master/tabbedex)
	
	echo -e "$info Synchronizing dotfiles path directories and files (use ${C}rsync${reset})..."
	xdg-user-dirs-update
	cd ~/Documents/
	git clone --depth 1 --recurse-submodules https://github.com/owl4ce/dotfiles.git
	$sudo pacman -S rsync --noconfirm
	rsync -avxHAXP --exclude-from=- dotfiles/. ~/ << "EXCLUDE"
.git*
LICENSE
*.md
EXTRA_JOYFUL
EXCLUDE
	rsync -avxHAXP --exclude-from=- dotfiles/EXTRA_JOYFUL/. ~/ << "EXCLUDE"
.git*
neofetch
EXCLUDE
	fc-cache -rv
	vnc_set "dbus-launch openbox &
dbus-launch cairo-dock &"
}

ilham25_dotfiles() {
	echo "$info Installing all dependencies..."
	$sudo pacman -S openbox alsa-utils pulseaudio pulseaudio-alsa brightnessctl \
			wireless_tools dunst tint2 gsimplecal rofi feh lxappearance qt5ct \
			lxsession xautolock xclip scrot thunar thunar-archive-plugin \
			thunar-media-tags-plugin thunar-volman lxsession tumbler jq w3m geany \
			nano vim viewnior pavucontrol parcellite neofetch htop  gtk2-perl \
			xfce4-power-manager imagemagick playerctl xsettingsd rsync \
			--noconfirm
	
	if [[ `command -v yay` ]]; then
		yay -S picom-git networkmanager-dmenu rxvt-unicode-truecolor-wide-glyphs qt5-styleplugins
	else
		yoi picom-git
		yoi networkmanager-dmenu-git
		yoi rxvt-unicode-truecolor-wide-glyphs
		yoi qt5-styleplugins
	fi
	
	echo "$info Getting all setups from dotfiles..."
	git clone --depth 1 https://github.com/ilham25/dotfiles-openbox
	pushd dotfiles-openbox/ && \
		bash -c 'cp -v -r {.*,*} ~/' && \
	popd
	rm ~/README.md && rm ~/LICENSE && rm -rf ~/.git
	cd ~/.icons/
	tar -Jxvf oomox-aesthetic-light.tar.xz && tar -Jxvf oomox-aesthetic-dark.tar.xz
	$sudo cp -r {oomox-aesthetic-light,oomox-aesthetic-dark} /usr/share/icons/
	rm -r ~/.icons/{oomox-aesthetic-light,oomox-aesthetic-dark,*.tar.xz} # Delete unnecessary files
	fc-cache -rv
	vnc_set "dbus-launch openbox &"
}
