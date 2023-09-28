#!/bin/bash

source vars.sh

vnc_set () {
	echo -e "$info Setting up Vnc server..."
	if [[ ! `command -v vncserver` ]]; then
		echo -e "$info Installing tigervnc..."
		execcom "$sudo pacman -S tigervnc lightdm --noconfirm"
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
DISPLAY=:1 xhost +" > $SERVICE_SRC
	chmod +x $SERVICE_SRC
}

tx11_set () {
	printf "$info Serting up Termux:X11 Server\n"
	if [[ ! `command -v termux-x11` ]]; then
		printf "$info Installing termux-x11...\n"
		execcom "$sudo pacman -S termux-x11"
	fi
	
	echo "#!/bin/bash
export XDG_RUNTIME_DIR=\${TMPDIR}
termux-x11 :1 &
env DISPLAY=:1 " > $SERVICE_SRC
	chmod +x $SERVICE_SRC
}