#!/usr/bin/env bash

#color
CYAN='\e[0;36m'
GREEN='\e[0;34m'
GREEN2="\033[01;32m"
okegreen='\033[92m'
lightgreen='\e[1;32m'
WHITE='\e[1;37m'
RED='\e[1;31m'
YELLOW='\e[0;33m'
YELLOW1="\033[01;33m"
BLUE='\e[1;34m' #Blue
RESET="\033[00m" #normal
ORANGE='\e[38;5;166m'
BOLD="\033[01;01m"
PURPLE='\e[0;35m'

load2 ()
{
sleep .2
echo -ne .
sleep .1
echo -ne .
sleep .1
echo -ne .
sleep .1
echo -ne .
sleep .1
}

clear
# check if user is root
if [ $(id -u) != "0" ]; then
  echo ""
  printf "$okegreen[$RED X $okegreen] "$RED" Need to be root to run this script...\n"
  echo ""
  exit
fi

banner () {
printf "$RED	╔─────────────────────────────────────────────────────────╗\n"
printf "$YELLOW1 		RESTORE TO DEFAULT BACKGROUND LOGIN SCREEN \n"
printf "$YELLOW1         			KALI LINUX                   	 \n"
printf "$RED	╚─────────────────────────────────────────────────────────╝\n"
}
banner

sleep .05

path1=/usr/share/gnome-shell/theme/gnome-shell-theme.gresource
path2=/usr/share/gnome-shell/gnome-shell-theme.gresource
path3=/usr/share/gnome-shell/gnome-shell-theme.gresource.bak
if [[ -e ${path1} ]]; then
	echo ""
  printf "\n$GREEN [$okegreen+$GREEN] $YELLOW Restore to Default "; load2;
	sudo rm -rf ${path2}
	sleep 2
	sudo mv ${path1} /usr/share/gnome-shell/
	sleep 2
	echo ""
else
	echo ""
  printf "$GREEN [$RED X $GREEN]$RED  File Not Found! Can't return to the default login background!\n"
	echo ""
	exit 0
fi

if [[ -e ${path2} ]]; then
  printf "$okegreen [$GREEN✔$okegreen] Succesfully!\n"
  echo ""
else
	printf "$GREEN [$RED X $GREEN]$RED Failed!"
	sudo mv ${path3} ${path2}
	echo ""
	exit 0
fi

if [[ -e ${path3} ]]; then
	sudo rm -rf ${path3}
	sleep 1
	exit 0
else
	printf ""
	exit 0
fi
done
