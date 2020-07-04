#!/usr/bin/bash
#	  CHANGE BACKGROUND LOGIN SCREEN FOR KALI LINUX 2019/2020
#	  Youtube	: kali pentesting
#	  Facebook	: https://fb.me/kalipentesting
#	  Twitter	: https://twitter.com/kalipentesting

#clear;
load () {
sleep .5
echo -ne .
sleep .5
echo -ne .
sleep .5
echo -ne .
sleep .4
echo -ne .
echo -ne .
sleep .2
}
load2 () {
sleep .2
echo -ne .
sleep .1
echo -ne .
sleep .1
echo -ne .
sleep .1
echo -ne .
echo -ne .
sleep .1
}
clear

banner () {

echo ""
printf "  \033[01;33m..............                        \n"
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

banner
clear

# check if user is root
if [ $(id -u) != "0" ]; then
  echo ""
  printf "\033[92m[\e[1;31m X \033[92m] \e[1;31mNeed to be root to run this script..."
  sleep .10
  echo ""
  printf "\033[92m[\e[1;31m X \033[92m] \e[1;31mexecute [\033[01;33m sudo bash run.sh \e[1;31m] on terminal"
  echo ""
  echo ""
  exit
fi

banner

main=shell/main.css
tgst=/tmp/gnome-shell/
tgstt=/tmp/gnome-shell/theme/
tgsttg=/tmp/gnome-shell/theme/gnome-shell-theme.gresource
tgstg=/tmp/gnome-shell/theme/gnome-shell.css
fpath=/usr/share/gnome-shell/
fpath1=/usr/share/gnome-shell/theme/
gst=/usr/share/gnome-shell/gnome-shell-theme.gresource
gstt=/usr/share/gnome-shell/theme/gnome-shell-theme.gresource
gstb=/usr/share/gnome-shell/gnome-shell-theme.gresource.bak
gstxml=/tmp/gnome-shell/theme/gnome-shell-theme.gresource.xml

if [[ -e $tgst ]]; then
  sudo rm -rf $tgst
  sleep 1
fi

trap ctrl_c INT
ctrl_c() {
  echo ""
  printf "\n        \033[01;33mYoutube : \033[92mKali Pentesting"
  echo ""
  printf "        \033[01;33mFollow me on Facebook: \033[92m@https://fb.me/KaliPentesting"
  echo ""
  printf "        \033[01;33mFollow me on Twitter : \033[92m@https://twitter.com/KaliPentesting\n"
  echo ""
  exit 0
}
zen=$(which zenity)
if ! [ "$?" -eq "0" ]; then
   printf "\033[92m[\e[1;31mX\033[92m] \e[1;31mzenity Not Found!"
   printf "\033[92m[\e[1;31m!\033[92m] \e[0;33mPlease Wait, installing dependencies "; load2;
   sudo apt-get install zenity -y
   sleep 1;clear
fi

libgtk=$(pkg-config --cflags gtk+-3.0 > /dev/null 2>&1)
if ! [[ $libgtk ]]; then
  printf "\n \033[92m[\e[0;34m*\e[1;32m] \e[0;33mStart Installing"; load2;
  echo ""
  sudo apt install libgtk-3-dev -y
  echo ""
else
  printf "\n \033[92m[\e[0;34m*\e[1;32m] \e[0;33mReady Installed "; load2;
  echo ""
fi
printf "\033[92m [\e[0;34m*\033[92m] \e[0;33mExtract theme "; load2;
echo ""

if [[ ! -d ${tgst}/theme ]]; then
  sudo mkdir -p ${tgst}/theme/icons/
fi
for i in `sudo gresource list $gst`; do
  sudo gresource extract $gst $i >$tgst${i#\/org\/gnome\/shell/}
done

if [[ -e $tgstg ]]; then
  printf " \033[92m[\e[0;34m✔\033[92m] Succesfully!\n"
else
  printf "\n \e[0;34m[\e[1;31mX\e[0;34m] \e[1;31mgnome-shell.css not found!\n"
  echo ""
 exit 0
fi

sleep 1
echo ""
printf " Choose Image for the Background Screen :"
image=$(zenity --file-filter=""*.png" "*.jpg"" --title="Choose Image for the Background Screen" --file-selection --filename="/home/") > /dev/null 2>&1
echo ""

if [[ -e $image ]]; then
  printf "\n \033[92m[\e[0;34m✔\033[92m] \e[0;33mImage found!\n"
  sudo cp $image $tgstt
  sleep 2
else
  echo ""
  printf " \e[1;31mImage not found!\n"
  echo ""
  exit 0
fi
if [[ -e $tgstt$(basename -a $image) ]]; then
  printf " \033[92m[\e[0;34m✔\033[92m] Succesfully!\n"
  #sleep 1
else
  printf "\n \e[1;31mImage names cannot have spaces!\n "
  printf "$image"
  echo ""
  echo ""
  exit 0
fi

if [[ -e $main ]]; then
  printf ""
  cat $main > $tgstg
  sleep 2
else
  printf "\n \e[1;31mFile $main Not Found!\n "
  echo ""
  exit 0
fi

echo -e "\n#lockDialogGroup {" >> $tgstg
echo "  background: #2e3436 url(resource:///org/gnome/shell/theme/$(basename $image));" >> $tgstg
echo "  background-size: 1366px 768px;" >> $tgstg
echo "  background-repeat: repeat; }" >> $tgstg
echo -e "\n#unlockDialogNotifications StButton#vhandle, #unlockDialogNotifications StButton#hhandle {" >> $tgstg
echo "  background-color: rgba(53, 53, 53, 0.3); }" >> $tgstg
echo "  #unlockDialogNotifications StButton#vhandle:hover, #unlockDialogNotifications StButton#vhandle:focus, #unlockDialogNotifications StButton#hhandle:hover, #unlockDialogNotifications StButton#hhandle:focus {" >> $tgstg
echo "    background-color: rgba(53, 53, 53, 0.5); }" >> $tgstg
echo "  #unlockDialogNotifications StButton#vhandle:active, #unlockDialogNotifications StButton#hhandle:active {" >> $tgstg
echo "    background-color: rgba(27, 106, 203, 0.5); }" >> $tgstg

if [[ -e $gstxml ]]; then
  sudo rm -rf $gstxml
  sleep 1
else
  echo ""
  printf " \033[92m[\e[0;34m*\033[92m] \e[0;33mIs making an xml script "; load2;
fi

echo "<?xml version="1.0" encoding="UTF-8"?>" >> $gstxml
echo "<gresources>" >> $gstxml
echo '  <gresource prefix="/org/gnome/shell/theme">' >> $gstxml
echo "    <file>$(basename $image)</file>" >> $gstxml
echo "    <file>gnome-shell.css</file>" >> $gstxml
echo "    <file>gnome-shell-high-contrast.css</file>" >> $gstxml
echo "    <file>pad-osd.css</file>" >> $gstxml
echo "    <file>calendar-today.svg</file>" >> $gstxml
echo "    <file>checkbox.svg</file>" >> $gstxml
echo "    <file>checkbox-focused.svg</file>" >> $gstxml
echo "    <file>checkbox-off.svg</file>" >> $gstxml
echo "    <file>checkbox-off-focused.svg</file>" >> $gstxml
echo "    <file>dash-placeholder.svg</file>" >> $gstxml
echo "    <file>no-events.svg</file>" >> $gstxml
echo "    <file>no-notifications.svg</file>" >> $gstxml
echo "    <file>process-working.svg</file>" >> $gstxml
echo "    <file>toggle-off.svg</file>" >> $gstxml
echo "    <file>toggle-off-dark.svg</file>" >> $gstxml
echo "    <file>toggle-off-hc.svg</file>" >> $gstxml
echo "    <file>toggle-on.svg</file>" >> $gstxml
echo "    <file>toggle-on-dark.svg</file>" >> $gstxml
echo "    <file>toggle-on-hc.svg</file>" >> $gstxml
echo "    <file>icons/eye-not-looking-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/eye-open-negative-filled-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/keyboard-caps-lock-filled-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/keyboard-enter-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/keyboard-hide-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/keyboard-layout-filled-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/keyboard-shift-filled-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/message-indicator-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/pointer-double-click-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/pointer-drag-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/pointer-primary-click-symbolic.svg</file>" >> $gstxml
echo "    <file>icons/pointer-secondary-click-symbolic.svg</file>" >> $gstxml
echo "  </gresource>" >> $gstxml
echo "</gresources>" >> $gstxml

echo ""
sleep 2
printf " \033[92m[\e[0;34m*\033[92m] \e[0;33mCompile "; load;
(cd $tgstt && sudo glib-compile-resources gnome-shell-theme.gresource.xml)
sleep 1
if [[ -e $tgsttg ]]; then
  printf "\n \033[92m[\e[0;34m✔\033[92m] Succesfully!"
  echo ""
else
  printf "\n \e[0;34m[\e[1;31mX\e[0;34m]\e[1;31m Compile failed!"
  sudo rm -rf $tgst
  echo ""
 exit 0
fi

#checking
printf "\n \033[92m[\e[0;34m*\033[92m] \e[0;33mChecking BackUp "; load2;
if [[ -e $gstt ]]; then
  printf "\n \033[92m[\e[0;34m✔\033[92m] Found!"
  echo ""
else
  sudo cp $gst $fpath1
  printf "\n \033[92m[\e[0;34m+\033[92m] \e[0;33mWaiting "; load;
  echo ""
fi

sleep .05
if [[ -e $gstb ]]; then
  printf " \033[92m[\e[0;34m✔\033[92m] BackUp Ready!"
  echo ""
else
  sudo mv $gst $gstb
  printf " \033[92m[\e[0;34m+\033[92m] BackUp Now!"; load2;
fi

if [[ -e $gst ]]; then
  #statements
  sudo rm -rf $gst
  sleep 2
  sudo cp $tgsttg $gst
  printf " \033[92m[\e[0;34m✔\033[92m] Remove $(basename $gst) "; load;
  if [[ -e $gst ]]; then
    echo ""
    printf " \033[92m[\e[0;34m✔\033[92m] Succesfully!\n"
    echo ""
    printf " \033[92m╔───────────────────────────────────────────────────────────────────────────╗\n"
    printf "	    \e[0;33mAll is done!! RESTART And See the New Login-Background !!	       \n"
    printf " \033[92m╚───────────────────────────────────────────────────────────────────────────╝\n"
    echo "";
    exit 0
  else
    printf "\e[0;34m[\e[1;31mX\e[0;34m] \e[1;31mBackground login failed!"
    sudo cp $gstt $fpath
    sudo rm -rf $gstb
    sudo rm -rf $tgst
    echo "";
    exit 0
  fi
else
  sudo cp $tgsttg $gst
  echo ""
  printf " \033[92m[\e[0;34m✔\033[92m] Skipped!"; load;
  if [[ -e $gst ]]; then
    echo ""
    printf " \033[92m[\e[0;34m✔\033[92m] Succesfully!\n"
    echo ""
    printf " \033[92m╔───────────────────────────────────────────────────────────────────────────╗\n"
    printf "	    \e[0;33mAll is done!! RESTART And See the New Login-Background !!	       \n"
    printf " \033[92m╚───────────────────────────────────────────────────────────────────────────╝\n"
    echo "";
    exit 0
  else
    printf "\e[0;34m[\e[1;31mX\e[0;34m] \e[1;31mBackground login failed!"
    sudo cp $gstt $fpath
    sudo rm -rf $gstb
    sudo rm -rf $tgst
    echo "";
    exit 0
  fi
fi
