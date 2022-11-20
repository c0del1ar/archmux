#!/bin/bash

source vars.sh

echo -e "$info Updating package.. (${C}400 MB${reset})"
sleep 2
pacman -Syuu --noconfirm
echo -e "$info Installing sudo..."
pacman -S sudo wget dialog --noconfirm
echo -e "$info Configurating ${C}patch${reset} bin data to prevent AUR package's installation issue..."
ln -s /data/data/com.termux/files/usr/bin/patch /usr/local/bin/patch
read -p "Make your username (lowercase): " user
read -p "Make password for $user: " pass
useradd -m -s $(which bash) ${user}
echo "${user}:${pass}" | chpasswd
echo "$user ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "proot-distro login --user $user archlinux --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > /data/data/com.termux/files/usr/bin/archlogin
mv ~/distro-config /home/$user/
cd /home/$user/distro-config
echo -e "$warn Exit your termux first to prevent some issue."
echo -e "$info Then login again."
exit