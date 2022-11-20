c='\033['
R=$c'31m'
G=$c'32m'
Y=$c'33m'
B=$c'34m'
C=$c'36m'
W=$c'1;37m'
reset=$c'0m'
warn="[ "$Y"WARN"$reset" ]"
info="[ "$G"INFO"$reset" ]"
quest="[ "$B"QUEST"$reset" ]"
err="[ "$R"CRITICAL"$reset" ]"
myarch=$(uname -m)

banner() {
	echo -e ' \e[H\e[2J
           \e[1;32m.
          \e[1;32m/#\
         \e[1;32m/###\      \e[1;37m               #     \e[1;32m
        \e[1;32m/p^###\     \e[1;37m a##e #%" a#"e 6##%  \e[1;32m|        |
       \e[1;32m/##P^q##\    \e[1;37m.oOo# #   #    #  #  \e[1;32m| \    / |  |  | \ /
      \e[1;32m/##(-  )##\   \e[1;37m%OoO# #   %#e" #  #  \e[1;32m|   \/   |  ._.| / \ \e[0;37m
     \e[1;32m/###P   q#,^\
    \e[1;32m/P^         ^q\ \e[0;37mAn archlinux for \e[1;37m`proot-distro` \e[0;37mtermux setup\n\n'
}

pkginfo(){
	echo -e "$info Package name : (${C}$1${reset})"
	echo -e "$info Package size : (${C}$2${reset})"
	echo -e "$info Command to install : (${W}$3${reset})"
}

execcom(){
	echo -e "$info Executing command: ${G}$1${reset}"
	echo $1 >> history_cmd.log
	$1
}