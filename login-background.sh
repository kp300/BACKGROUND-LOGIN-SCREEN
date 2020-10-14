#!/usr/bin/bash
#   CHANGE BACKGROUND LOGIN SCREEN FOR Kali Linux 2020 & Ubuntu 2020
# Youtube : https://youtube.com/KaliPentesting
# facebook: https://fb.me/KaliPentesting
# Twitter : @KaliPentesting

id=`awk '{print $1}' /etc/issue`
user=`who | awk {'print $1'}`
###############KALI###########################################
kali_gsource="/usr/share/gnome-shell/gnome-shell-theme.gresource"
dir="/usr/share/gnome-shell/"
css="/tmp/gnome-shell/theme"
rolling=$(hostnamectl | grep Kali | cut -d' ' -f5)
###############ubuntu#########################################
ubuntugsource="/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource"
theme="/org/gnome/shell/theme"
focal="/usr/local/share/gnome-shell/theme/focalgdm3"
focal_gsource="/usr/local/share/gnome-shell/theme/focalgdm3.gresource"
distro=$(hostnamectl | grep Ubuntu | cut -d' ' -f5)
UBUNTU_CODENAME=$(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2)

for i in `cat /etc/X11/default-display-manager`; do
  if ! grep -q gdm3 $i; then
    printf "\n\033[92mThis script only changes the Background Screen Login for Gnome Display Manager.
Exiting..\n"
    exit 1;
  fi
done

command -v zenity > /dev/null 2>&1 || { printf "\033[0;31mZenity not found! Install it. Aborting!\n"; exit 1;}
command -v glib-compile-resources > /dev/null 2>&1 || { printf "\033[0;31mCompile-resources not found! Install it. \033[92msudo apt install libglib2.0-dev\n"; exit 1;}

if [[ $(id -u) != "0" ]]; then
  printf "\033[92m[\e[1;31mX\033[92m] \e[1;31mI Need root to run this script...\n"
  exit 1
fi

chooser (){
printf "\n \e[0m\e[1;92m1. \e[0mTyping image paths on Terminal?\e[0m\n"
printf " \e[0m\e[1;92m2.\e[0m Open path & Select image?\e[0m\n"
printf " \e[0m\e[1;92m3.\e[0m Only change the background color?\e[0m\n\n"
terminal=1
zenity=2
color_background=3

while [ "$choose_number" == "" ]; do
  read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m]\e[0m Choose a number 1/2/3: ' choose_number
done

if [[ "$choose_number" -eq 1 ]] && [[ "$choose_number" -eq 01 ]]; then
terminal=1
  printf "
              \e[0m\e[1;92mEnter Image Path for Login Background\e[0m
Command Example: \033[0;32m/home/Pictures/YourImage.PNG or JPG\e[0m
Command Example: \033[0;32m/usr/share/backgrounds/brad-huchteman-stone-mountain.jpg\e[0m
Command Example: \033[0;32m/usr/share/backgrounds/kali/kali-blue-matrix-16x9.png\e[0m\n\n"
while [ "$image" == "" ]; do
  read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mEnter Image Path: ' image
done

elif [ "$choose_number" -eq 2 ] && [ "$choose_number" -eq 02 ]; then
zenity=2
  image=$(zenity --file-filter=""*.png" "*.jpg"" --title="Choose Image .PNG or .JPG" --file-selection --filename="$user")

elif [ "$choose_number" -eq 3 ] && [ "$choose_number" -eq 03 ]; then
color_background=3
  printf "
------------------------------------------------------------------
\e[0m\e[1;92mThis only changes the background login color. without pictures.\e[0m
\e[0m\e[1;92mAnd see there are still many colors here: https://www.color-hex.com/\e[0m
  Command Example : #00ff5e
  color Magenta   : \e[35m#ff00ff\e[0m
  color Light_blue: \e[94m#add8e6\e[0m
  color Light_cyan: \e[96m#E0FFFF\e[0m
------------------------------------------------------------------\n\n"
while [ "$colors" == "" ]; do
  read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mColor for login background: ' colors
done
fi

if [ -z $image ] && [ -z "$colors" ]; then
  printf "\033[0;31mExiting\e[0m..\n"
  exit 1;
fi

if ! [ -z $image ]; then
  if ! [ -e $image ]; then
  printf "\033[0;31mThe image path you selected does not exist or cannot be found\e[0m..\n"
  exit 1;
  fi
fi

if [ -z "$colors" ]; then
  if [ "$rolling" == "Kali" ]; then
    color="#41494c"
  elif [ "$distro" == "Ubuntu" ]; then
    color="#4f194c"
  fi
else
  color="$colors"
fi

if ! [ -z "$colors" ]; then
  if ! [[ "$colors" =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then
  printf "\033[0;31mThe hex color you input is invalid!\nExiting\e[0m..\n"
  exit 1
  fi
fi
}

banner(){
  clear;
printf "\e[0m\e[0;34mDistro:\033[0;32m "$id"\n
        \e[0m\033[92m[ \033[1;33mCHANGE BACKGROUND LOGIN SCREEN\e[0m\033[92m ]\n\n"
}

case "$1" in
kali|-kali)

if [ "$rolling" == "Kali" ]; then
  banner
  chooser
else
  printf "\033[1;33mThe script only runs if you are using Kali Linux\n"
  exit 1;
fi

if [ ! -d /tmp/gnome-shell/ ]; then
  mkdir -p ${css}/icons/
fi

if [ ! -e $kali_gsource.bak ]; then
  for i in `sudo gresource list $kali_gsource`; do
    gresource extract $kali_gsource $i > /tmp/gnome-shell/${i#\/org\/gnome\/shell/}
  done
else
  for i in `sudo gresource list $kali_gsource.bak`; do
    gresource extract $kali_gsource.bak $i > /tmp/gnome-shell/${i#\/org\/gnome\/shell/}
  done
fi

if [ ! -e "$css/gnome-shell.css" ]; then
  printf "\n\e[0;34m[\e[1;31mx\e[0;34m] \e[1;31mDidn't find gnome-shell.css on the path '$css/gnome-shell.css'.. Canceled!\e[0;33m\n"
  exit 1;
fi

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mMaking theme script.."
echo "<?xml version="1.0" encoding="UTF-8"?>" > $css/gnome-shell-theme.gresource.xml;
sleep 1
echo "<gresources>" >> $css/gnome-shell-theme.gresource.xml
echo '  <gresource prefix="/org/gnome/shell/theme">' >> $css/gnome-shell-theme.gresource.xml
for i in `gresource list /usr/share/gnome-shell/gnome-shell-theme.gresource | sed 's/.......................//'`; do
  echo "    <file>$i</file>" >> $css/gnome-shell-theme.gresource.xml
done
echo "  </gresource>" >> $css/gnome-shell-theme.gresource.xml
echo "</gresources>" >> $css/gnome-shell-theme.gresource.xml

#    background-repeat: no-repeat;
#    background-size: cover;
#    background-position: center;
#    -webkit-filter: blur(5px);
#    /* Safari 6.0 - 9.0 */
#    filter: blur(5px);

grep -v "background: #2e3436 url(resource:///org/gnome/shell/theme/
  background: #41494c url(resource:///org/gnome/shell/theme/
  background: #2e3436;
  background-color: #41494c;
  background-repeat: repeat;
  background-size: cover;
  background-size: 1366px 768px;
  background-size: 1360px 768px;
  background-size: 1280px 720px;
  background-size: 1024px 768px;
  background-size: 960px 720px;
  background-size: 928px 696px;
  background-size: 896px 672px;
  background-size: 1024px 672px;
  background-repeat: no-repeat;
  background-position: center;" ${css}/gnome-shell.css > ${css}/gnome.txt

printf "\n\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mChecking script.."
if [[ "$colors" =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then
  sed -i '/#lockDialogGroup {/a\  background-color: '$color'; }' ${css}/gnome.txt
else
  cp $image $css/
  sed -i '/#lockDialogGroup {/a\  background: '$color' url(resource:///org/gnome/shell/theme/'$(basename -a $image)');\n  background-size: cover;\n  background-repeat: no-repeat;\n  background-position: center; }' ${css}/gnome.txt
  sed -i '/gnome-shell.css/a\    <file>'$(basename $image)'</file>' $css/gnome-shell-theme.gresource.xml
  if ! grep -q $(basename -a $image) $css/gnome.txt; then
    printf "\n\033[1;32m[\033[0;31mx\033[1;32m] \033[0;31mCan't find the image name in script.. Canceled!\n\n"
    rm -rf /tmp/gnome-shell/
    exit 1;
  fi
fi

sleep 2;
cat ${css}/gnome.txt > ${css}/gnome-shell.css
rm -rf ${css}/gnome.txt
(cd ${css}/ && glib-compile-resources gnome-shell-theme.gresource.xml)

if [ ! -e ${css}/gnome-shell-theme.gresource ]; then
  printf "\n\033[1;31mUnable to compile gnome-shell-theme. Something went wrong!
Use command: \e[0m\e[1;92msudo bash $0 --reset\033[1;31m
to reset your login background first. then try running the script again.\n"
  rm -rf /tmp/gnome-shell/
  exit 1;
fi

if [ ! -e $kali_gsource.bak ]; then
  mv $kali_gsource $kali_gsource.bak
fi

mv ${css}/$(basename -a $kali_gsource) $dir
rm -rf /tmp/gnome-shell

  echo "

---------------------------------------------------------------
  All is done!! RESTART And See the New Login-Background :)
---------------------------------------------------------------
      "
exit 1;
;;

ubuntu|-ubuntu)

if [ "$distro" == "Ubuntu" ] && [ $UBUNTU_CODENAME == "focal" ]; then
  banner
  chooser
else
  printf "\033[1;33mThe script only runs if you are using Ubuntu 20.04\n"
  exit 1;
fi

if [ ! -d $focal ]; then
  install -d $focal/icons/scalable/actions
fi

touch $focal/gdm3.css $focal/focalgdm3.gresource.xml
printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mMaking theme Script.."
gresource extract $ubuntugsource $theme/gdm3.css > $focal/original.css
gresource extract $ubuntugsource $theme/checkbox.svg > $focal/checkbox.svg
gresource extract $ubuntugsource $theme/checkbox-off.svg > $focal/checkbox-off.svg
gresource extract $ubuntugsource $theme/checkbox-focused.svg > $focal/checkbox-focused.svg
gresource extract $ubuntugsource $theme/checkbox-off-focused.svg > $focal/checkbox-off-focused.svg
gresource extract $ubuntugsource $theme/toggle-on.svg > $focal/toggle-on.svg
gresource extract $ubuntugsource $theme/toggle-off.svg > $focal/toggle-off.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/pointer-drag-symbolic.svg > $focal/icons/scalable/actions/pointer-drag-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/keyboard-enter-symbolic.svg > $focal/icons/scalable/actions/keyboard-enter-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/keyboard-hide-symbolic.svg > $focal/icons/scalable/actions/keyboard-hide-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/pointer-secondary-click-symbolic.svg > $focal/icons/scalable/actions/pointer-secondary-click-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/keyboard-shift-filled-symbolic.svg > $focal/icons/scalable/actions/keyboard-shift-filled-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/keyboard-caps-lock-filled-symbolic.svg > $focal/icons/scalable/actions/keyboard-caps-lock-filled-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/pointer-primary-click-symbolic.svg > $focal/icons/scalable/actions/pointer-primary-click-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/keyboard-layout-filled-symbolic.svg > $focal/icons/scalable/actions/keyboard-layout-filled-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/eye-not-looking-symbolic.svg > $focal/icons/scalable/actions/eye-not-looking-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/pointer-double-click-symbolic.svg > $focal/icons/scalable/actions/pointer-double-click-symbolic.svg
gresource extract $ubuntugsource $theme/icons/scalable/actions/eye-open-negative-filled-symbolic.svg > $focal/icons/scalable/actions/eye-open-negative-filled-symbolic.svg

echo '@import url("resource:///org/gnome/shell/theme/original.css");
  #lockDialogGroup {
  background: '$color' url(file://'$image');
  background-repeat: no-repeat;
  background-size: cover;
  background-position: center; }' > $focal/gdm3.css

echo '<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
    <file>original.css</file>
    <file>gdm3.css</file>
    <file>toggle-off.svg</file>
    <file>checkbox-off.svg</file>
    <file>toggle-on.svg</file>
    <file>checkbox-off-focused.svg</file>
    <file>checkbox-focused.svg</file>
    <file>checkbox.svg</file>
    <file>icons/scalable/actions/pointer-drag-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-enter-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-hide-symbolic.svg</file>
    <file>icons/scalable/actions/pointer-secondary-click-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-shift-filled-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-caps-lock-filled-symbolic.svg</file>
    <file>icons/scalable/actions/pointer-primary-click-symbolic.svg</file>
    <file>icons/scalable/actions/keyboard-layout-filled-symbolic.svg</file>
    <file>icons/scalable/actions/eye-not-looking-symbolic.svg</file>
    <file>icons/scalable/actions/pointer-double-click-symbolic.svg</file>
    <file>icons/scalable/actions/eye-open-negative-filled-symbolic.svg</file>
  </gresource>
</gresources>' > $focal/focalgdm3.gresource.xml
printf "\n\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mChecking script..";sleep 1;
if [ ! -e $focal/focalgdm3.gresource.xml ]; then
  printf "\n\033[1;32m[\033[0;31mx\033[1;32m] \033[0;31mDid not find the required filename.. Canceled!\n\n"
  rm -rf $focal
  exit 1;
else
  (cd $focal/ && glib-compile-resources focalgdm3.gresource.xml && mv focalgdm3.gresource ..)
fi
rm -rf $focal
update-alternatives --quiet --install ${dir}gdm3-theme.gresource gdm3-theme.gresource $focal_gsource 0
update-alternatives --quiet --set gdm3-theme.gresource $focal_gsource

if [ -e $focal_gsource ]; then
  echo "

---------------------------------------------------------------
  All is done!! RESTART And See the New Login-Background :)
---------------------------------------------------------------
      "
  exit 1;
else
  printf "\n\033[0;31mLogin Background cannot be created.\e[0m\n"
fi
;;

reset|-reset|--reset)

if [ -e $kali_gsource.bak ]; then
  mv $kali_gsource.bak $kali_gsource
  printf "\n\e[0mReset has been \e[0m\e[1;92msuccessfully..\n"
  printf "\e[0mNow your $id Linux login background is back to normal.\n\n"
  exit 1;
elif [ -e $focal_gsource ]; then
  update-alternatives --quiet --set gdm3-theme.gresource "$ubuntugsource"
  rm -rf /usr/local/share/gnome-shell/
  printf "\n\e[0mReset has been \e[0m\e[1;92msuccessfully..\n"
  printf "\e[0mNow your $id login background is back to normal.\n\n"
  exit 1;
else
  echo "----------------------------------------------------------------
Nothing needs resetting. Login background is still the original default $id..
----------------------------------------------------------------"
  exit 1
fi
;;

help|-h|--help)

echo "Usage: $0 <command>

   kali   | -kali     : Change Login Background Wallpaper for Kali Linux.
   ubuntu | -ubuntu   : Change Login Background Wallpaper for Ubuntu.
   reset  | -reset    : Reset automatically to the original background
                        For KALI LINUX and UBUNTU.
   help|-help|--help  : Help Command.
"
exit 1;
;;
*)
printf "\033[92mUsage:\e[0m $0 --help\n"
exit 1

esac
