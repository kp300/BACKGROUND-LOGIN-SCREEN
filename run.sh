#!/usr/bin/bash
#  CHANGE BACKGROUND LOGIN SCREEN FOR KALI LINUX 2020
# Youtube: KaliPentesting

load1 () { sleep .5;echo -ne .;sleep .5;echo -ne .;sleep .5;echo -ne .;sleep .4;echo -ne .;echo -ne .;sleep .2; }
load2 () { sleep .2;echo -ne .;sleep .1;echo -ne .;sleep .1;echo -ne .;sleep .1;echo -ne .;echo -ne .;sleep .1; }

if [[ $(id -u) != "0" ]]; then
  printf "\n\033[92m[\e[1;31m X \033[92m] \e[1;31mI Need root to run this script...\n"
  printf "\033[92m[\e[1;31m X \033[92m] \e[1;31mexecute [\033[01;33m sudo bash run.sh\e[1;31m ]\n\n"
  exit 1
fi

banner() {
printf "  \033[01;33m..............                        \n";
printf "              ..,;:ccc,.                           \n"
printf "            ......''';lxO.                         \n"
printf "  .....''''..........,:ld;                         \n"
printf "             .';;;:::;,,.x,                        \n"
printf "        ..'''.            0Xxoc:,.  ...            \n"
printf "    ....                ,ONkc;,;cokOdc',.          \n"
printf "   .                   OMo           ':ddo.        \n"
printf "                      dMc               :OO;       \n"
printf "                      0M.                 .:o.     \n"
printf "                      ;Wd                          \n"
printf "                       ;XO,                        \n"
printf "                         ,d0Odlc;,..               \n"
printf "                             ..',;:cdOOd::,.       \n"
printf "                                      .:d;.':;.    \n"
printf " \033[92mCHANGE BACKGROUND LOGIN SCREEN          \033[01;33m'd,  .'\n"
printf "         \033[92mKALI LINUX                        \033[01;33m;l   ..\n"
printf "                                            .o     \n"
printf "                                             c     \n"
printf "                                             .'    \n"
printf " -------------------------------------------------\n"
}

main=shell/gnome-shell.css
rgs=result/gnome-shell/
usgtg=/usr/share/gnome-shell/theme/
usgg=/usr/share/gnome-shell/gnome-shell-theme.gresource
gstb=/usr/share/gnome-shell/gnome-shell-theme.gresource.bak
gtk3=/usr/lib/x86_64-linux-gnu/pkgconfig/gtk+-3.0.pc

check_dependencies () {
zen=$(which zenity)
if [[ ! "$?" -eq "0" ]]; then
  printf "\n\033[92m[\e[1;31mx\033[92m] \e[1;31mzenity Not Found!"
  printf "\n\033[92m[\e[1;31m!\033[92m] \e[0;33mPlease Wait, installing dependencies ";load2;
  printf "\n\n"
  sudo apt-get install zenity -y
  sleep 1;clear

elif [[ ! -e $gtk3 ]]; then
  printf "\n\033[92m[\e[1;31mx\033[92m] \e[1;31mgtk+-3.0 Not Found!"
  printf "\n\033[92m[\e[1;31m!\033[92m] \033[92mPlease Wait, installing dependencies ";load2;
  printf "\n\n"
  sudo apt install libgtk-3-dev -y
  sleep 1;clear
fi

if [[ ! -d shell ]]; then
  sudo mkdir shell
elif [[ ! -d result ]]; then
  sudo mkdir result
elif [[ ! -d $usgtg ]]; then
  sudo mkdir $usgtg
  sleep 2
elif [[ -e result/gnome-shell ]]; then
  sudo rm -rf result/gnome-shell/
fi
if [[ ! -e ${usgtg}gnome-shell-theme.gresource ]]; then
  sudo cp $usgg $usgtg
fi
}

trap ctrl_c INT
ctrl_c () {
  printf "\n\n\033[01;33mYoutube:\033[92mKali Pentesting | \033[01;33mFb:\033[92m@KaliPentesting | \033[01;33mTwitter:\033[92m@KaliPentesting\n\n";
  if [[ -e $usgg ]]; then
    sudo rm -rf $usgg
    sleep 1
    sudo cp ${usgtg}gnome-shell-theme.gresource $usgg
  else
    sudo cp ${usgtg}gnome-shell-theme.gresource $usgg
  fi
  exit 1
}

extract_theme () {
if [[ ! -d ${rgs}/theme ]]; then
  sudo mkdir -p ${rgs}theme/icons/
fi
for i in `sudo gresource list $usgg`; do
  sudo gresource extract $usgg $i >$rgs${i#\/org\/gnome\/shell/}
done
printf "\033[92m[\e[0;34m*\033[92m]\e[0;33m Extract theme ";load2;
if [[ -e ${rgs}theme/gnome-shell.css ]]; then
  printf "\n\033[92m[\e[0;34m✔\033[92m] Succesfully!\e[0;33m\n\n"
else
  printf "\n\e[0;34m[\e[1;31mX\e[0;34m] \e[1;31mExtrack theme failed!\n"
  exit 1
fi


printf "%q\e[0m\e[1;93m Select image extension \e[0m\033[92m.png \e[0m\e[1;93mor \e[0m\033[92m.jpg\e[0m\e[1;93m for login background wallpaper %q\e[0m\n\e[0m\e[1;77m"
read -s -p "[Enter Key] to Continue"
image=$(sudo zenity --file-filter=""*.png" "*.jpg"" --title="Choose Image" --file-selection --filename="/home/")

if [[ -e $image ]]; then
  printf "\n\n\033[92m[\e[0;34m✔\033[92m]\e[0;33m Image found:\e[0m\e[1;77m $image\n"
  sudo cp $image ${rgs}theme/ > /dev/null 2>&1
  sleep 2
else
  sudo rm -rf result
  printf "\n\n\e[1;31mImage not found! Aborting.\n"
  exit 1
fi
if [[ -e ${rgs}theme/$(basename -a $image) ]]; then
  printf "\033[92m[\e[0;34m✔\033[92m] Succesfully!\n"
else
  sudo rm -rf result
  printf "\n\e[1;31mImage names cannot have spaces! Please rename the image..\n\e[1;31mLocate:\e[0m\e[1;77m $image\n\n"
  exit 1
fi
}

createmain () {
if [[ -f ${rgs}theme/gnome-shell.css ]]; then
  sudo sed '2098,$d' ${rgs}theme/gnome-shell.css > $main #> /dev/null 2>&1
  printf "\033[92m[\e[0;34m*\033[92m] \e[0;33mIs making GNOME Shell Theme css "; load1;
  echo -e "#lockDialogGroup {" >> $main
  echo "  background: #2e3436 url(resource:///org/gnome/shell/theme/$(basename $image));" >> $main
  echo "  background-size: 1366px 768px;" >> $main
  echo "  background-repeat: repeat; }" >> $main
  echo -e "\n#unlockDialogNotifications StButton#vhandle, #unlockDialogNotifications StButton#hhandle {" >> $main
  echo "  background-color: rgba(53, 53, 53, 0.3); }" >> $main
  echo "  #unlockDialogNotifications StButton#vhandle:hover, #unlockDialogNotifications StButton#vhandle:focus, #unlockDialogNotifications StButton#hhandle:hover, #unlockDialogNotifications StButton#hhandle:focus {" >> $main
  echo "    background-color: rgba(53, 53, 53, 0.5); }" >> $main
  echo "  #unlockDialogNotifications StButton#vhandle:active, #unlockDialogNotifications StButton#hhandle:active {" >> $main
  echo "    background-color: rgba(27, 106, 203, 0.5); }" >> $main
fi

sudo cat /dev/null > ${rgs}theme/gnome-shell-theme.gresource.xml

printf "\n\033[92m[\e[0;34m*\033[92m] \e[0;33mIs making an xml script "; load2;

echo "<?xml version="1.0" encoding="UTF-8"?>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "<gresources>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo '  <gresource prefix="/org/gnome/shell/theme">' >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>$(basename $image)</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>gnome-shell.css</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>gnome-shell-high-contrast.css</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>pad-osd.css</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>calendar-today.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>checkbox.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>checkbox-focused.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>checkbox-off.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>checkbox-off-focused.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>dash-placeholder.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>no-events.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>no-notifications.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>process-working.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>toggle-off.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>toggle-off-dark.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>toggle-off-hc.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>toggle-on.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>toggle-on-dark.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>toggle-on-hc.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/eye-not-looking-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/eye-open-negative-filled-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/keyboard-caps-lock-filled-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/keyboard-enter-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/keyboard-hide-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/keyboard-layout-filled-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/keyboard-shift-filled-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/message-indicator-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/pointer-double-click-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/pointer-drag-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/pointer-primary-click-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "    <file>icons/pointer-secondary-click-symbolic.svg</file>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "  </gresource>" >> ${rgs}theme/gnome-shell-theme.gresource.xml
echo "</gresources>" >> ${rgs}theme/gnome-shell-theme.gresource.xml

sudo mv $main ${rgs}theme/
#compile theme
printf "\n\033[92m[\e[0;34m*\033[92m] \e[0;33mCompile "; load1;
(cd ${rgs}theme && sudo glib-compile-resources gnome-shell-theme.gresource.xml)
sleep 2

printf "\n\033[92m[\e[0;34m*\033[92m] \e[0;33mChecking preparation "; load1;

if [[ -e ${rgs}theme/gnome-shell-theme.gresource ]]; then
  printf "\n\033[92m[\e[0;34m✔\033[92m] Succesfully!"
else
  sudo rm -rf result
  printf "\n\e[0;34m[\e[1;31mX\e[0;34m]\e[1;31m Compile failed!\n"
  exit 1
fi
}

backup_dir () {
printf "\n\033[92m[\e[0;34m*\033[92m] \e[0;33mBackUp "; load1;load1;
if [[ ! -e $gstb ]]; then
  sudo mv $usgg $gstb
  sleep 2
  sudo mv ${rgs}theme/gnome-shell-theme.gresource $usgg
  sleep 2
else
  sudo rm -rf $usgg
  sleep 2
  sudo mv ${rgs}theme/gnome-shell-theme.gresource $usgg
  sleep 2
fi
if [[ -e $usgg ]] && [[ -e $gstb ]]; then
  printf "\n\033[92m[\e[0;34m✔\033[92m] Succesfully!\n\n"
  printf "  \033[92m╔───────────────────────────────────────────────────────────────────────────╗\n"
  printf "	    \e[0;33mAll is done!! RESTART And See the New Login-Background !!	       \n"
  printf "  \033[92m╚───────────────────────────────────────────────────────────────────────────╝\n\n"
  sudo rm -rf result
  exit 1
else
  sudo mv ${usgtg}gnome-shell-theme.gresource $usgg
  printf "\n\e[0;34m[\e[1;31mX\e[0;34m]\e[1;31m there is something wrong. Please run the script again\n"
  exit 1
fi
}
clear

banner
check_dependencies
extract_theme
createmain
backup_dir
