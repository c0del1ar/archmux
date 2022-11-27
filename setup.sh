#!/bin/bash
source vars.sh

storage_check() {
	if [[ -d "$HOME/storage/" ]]; then
        echo -e "$info Internal storage already set"
    else
        echo -e "$warn You must grant internal storage permission : ${R}termux-setup-storage${reset}"
        termux-setup-storage
    fi
}

package() {
	echo -e "$info Checking required package : (${W}proot-distro pulseaudio tigervnc xorg-xhost${reset})"
	if [[ `command -v pulseaudio` && `command -v proot-distro` && `command -v xhost` ]]; then
        echo -e "$info Packages already installed."
    else
        apt update -y > out.log 2> err.log
        apt upgrade -y > out.log 2> err.log
        packs=(pulseaudio proot-distro tigervnc x11-repo xorg-xhost)
        for pkgname in "${packs[@]}"; do
            type -p "$pkgname" &>/dev/null || {
                echo -e "$info Installing package : ${C}${pkgname}${reset}"
                execcom "apt install $pkgname -y" > out.log 2> err.log
            }
        done
    fi
}

env_install() {
	echo -e "$info Setting up environment.."
	echo -e "$info Generating sound server.."
	
    echo "pulseaudio --start --exit-idle-time=-1" > $HOME/.sound
    echo "pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" >> $HOME/.sound
    
    cp -r distro-config $archdir/root/
    chmod +x $archdir/root/distro-config/*
    
    echo "proot-distro login archlinux --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > $PREFIX/bin/archlogin
    chmod +x $PREFIX/bin/archlogin
    
    echo -e "$info Command to login to your distro : ${G}archlogin${reset}"
    echo -e "$info Command to setting up a user after logging in: ${G}bash set_user.sh${reset}"
    echo -e "$warn Restart your termux first to prevent some issue"
}

distro() {
	echo -e "$info Checking for distro : ${C}archlinux${reset} (120MB)"
	termux-reload-settings
    mkdir -p $archdir
    
    if [[ `ls $archdir` != "" ]]; then
        echo -e "$info Distro already installed."
        echo -e "$info Command to login to your distro : ${G}archlogin${reset}"
        printf "$quest Do you want to reinstalling environment? (y/n): "
        read reins
        case "$reins" in
            Y|y)
                echo -e "$warn Reinstalling.."
                env_install
                ;;
            n|N) echo -e "$info Cancelling..";;
            *) echo -e "$err Invalid input. Quitting.."
        esac
        exit 0
    else
        printf "$quest Do you sure to install it? (y/n) "
        read sure
        if [[ `echo "$sure" | tr '[:upper:]' '[:lower:]'` == "y" ]]; then
            echo -e "$info Installing.."
            execcom "proot-distro install archlinux"
            execcom "termux-reload-settings"
        else
            echo -e "$err Cancelled."
            exit 0
        fi
    fi
    
    if [[ `ls $archdir` != "" ]]; then
        echo -e "$info Successfully installed : ${C}archlinux${reset}"
        env_install
    else
        echo -e "$err Error Installing Distro"
        exit 0
    fi
}


banner
storage_check
package
distro
