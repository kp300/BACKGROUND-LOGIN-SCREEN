#!/usr/bin/env bash

#   CHANGE BACKGROUND LOGIN SCREEN FOR Kali Linux 2021 & Ubuntu 2021

######## < Support me on (Media Social) > ########
# New Youtube : https://www.youtube.com/Mahinesta
# Facebook    : https://fb.me/Mahinesta
# Twitter     : @Mahinesta

################################# < grep User and Distro > #################################
id=$(awk '{print $1}' /etc/issue)
user=$(who | awk {'print $1'})
################################# < Kali > #################################
gsource_kali="/usr/share/gnome-shell/gnome-shell-theme.gresource"
gnomeshell="/usr/share/gnome-shell"
tmp_gnomeshell="/tmp/gnome-shell/theme"
kali=$(hostnamectl | grep Kali | cut -d' ' -f5)
################################# < ubuntu > #################################
gsource_ubuntu="/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource"
theme="/org/gnome/shell/theme"
focal="/usr/local/share/gnome-shell/theme/focalgdm3"
focal_gsource="/usr/local/share/gnome-shell/theme/focalgdm3.gresource"
ubuntu=$(hostnamectl | grep Ubuntu | cut -d' ' -f5)
UBUNTU_CODENAME=$(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2)


##########< use root >##########
if [[ $(id -u) != "0" ]]; then
  printf "\033[92m[\e[1;31mX\033[92m] \e[1;31mI Need root to run this script...\n"; exit 1;
fi

##########< check display manager gdm3 >##########
for i in $(cat /etc/X11/default-display-manager); do
  if ! grep -q gdm3 $i; then
    printf "\n\033[92mThis script only changes the Background Screen Login for Gnome Display Manager.\n"; exit 1;
  else
    command -v zenity > /dev/null 2>&1 || { printf "\n\033[0;31mZenity not found! Install it. Aborting!\n"; exit 0;}
    command -v glib-compile-resources > /dev/null 2>&1 || { printf "\n\033[0;31mCompile-resources not found! Install it. \033[92msudo apt install libglib2.0-dev\n"; exit 0;}
  fi
done

##########< select image & color >##########
function chooser_path() {

printf "\e[0m\e[1;92m[01] \e[0mSelect Images [PNG or JPG]\e[0m\n"
printf "\e[0m\e[1;92m[02]\e[0m Select Colors [The Hex Color]\e[0m\n\n"
read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m]\e[0m Choose a number 1/2: ' choose_number

if [[ $choose_number -eq 1 ]] && [[ $choose_number -eq 01 ]]; then
  read -p $'\e[1;77m[\e[0m\e[1;92m?\e[0m\e[1;77m]\e[0m Open the folder and Select Image? [Y/n]: ' openimage
  if [[ $openimage == "y" ]] || [[ $openimage == "Y" ]] || [[ $openimage == "yes" ]] || [[ $openimage == "YES" ]]; then
    images=1
    image=$(zenity --file-filter=""*.png" "*.jpg"" --title="Choose Image .PNG or .JPG" --file-selection --filename="/home/"$user"/" 2>/dev/null)
  else
    images=1
    printf "
    Command Example: \033[0;32m/home/$user/Pictures/YourImage.PNG or JPG\e[0m
    Command Example: \033[0;32m/usr/share/backgrounds/warty-final-ubuntu.png\e[0m\n\n"
    read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mPut Image Path: ' image
  fi
  if [[ ! -e $image ]]; then
    printf "\033[0;31mThe image path you selected does not exist or cannot be found\e[0m\n"; exit 1;
  elif [[ ! -z $image ]]; then
    printf "\033[0;31mPlease change the image name (No spaces) then run the script again!\e[0m\n"; exit 1;
  fi

elif [[ $choose_number -eq 2 ]] && [[ $choose_number -eq 02 ]]; then
  color_background=2
  printf "\n\e[0m\e[1;92mThis only changes the background login color. without pictures.\n\e[1;92mSee there are still many colors here: https://www.color-hex.com/\e[0m\n
  Command Example: #ff0000\n\n"
  read -p $'\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mColor for login background: ' colors
  if ! [[ $colors =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then
    printf "\033[0;31mThe hex color you input is invalid!\e[0m\n"; exit 1;
  fi

else
  printf "\033[0;31mPlease choose number 1 or 2 to Continue..\e[0m\n";sleep 1;
  clear; banner; chooser_path;
fi

if [[ -z $colors ]]; then
  if [[ $ubuntu == "Ubuntu" ]]; then
    color="#4f194c"
  fi
else
  color=$colors
fi
}

##########< configure background login ubuntu >##########
function ubuntu_configure() {

if [[ ! -d $focal ]]; then
  install -d $focal/icons/scalable/actions
fi

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mMaking theme Script.."
touch $focal/gdm3.css $focal/focalgdm3.gresource.xml
gresource extract $gsource_ubuntu $theme/gdm3.css > $focal/original.css
gresource extract $gsource_ubuntu $theme/checkbox.svg > $focal/checkbox.svg
gresource extract $gsource_ubuntu $theme/checkbox-off.svg > $focal/checkbox-off.svg
gresource extract $gsource_ubuntu $theme/checkbox-focused.svg > $focal/checkbox-focused.svg
gresource extract $gsource_ubuntu $theme/checkbox-off-focused.svg > $focal/checkbox-off-focused.svg
gresource extract $gsource_ubuntu $theme/toggle-on.svg > $focal/toggle-on.svg
gresource extract $gsource_ubuntu $theme/toggle-off.svg > $focal/toggle-off.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/pointer-drag-symbolic.svg > $focal/icons/scalable/actions/pointer-drag-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/keyboard-enter-symbolic.svg > $focal/icons/scalable/actions/keyboard-enter-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/keyboard-hide-symbolic.svg > $focal/icons/scalable/actions/keyboard-hide-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/pointer-secondary-click-symbolic.svg > $focal/icons/scalable/actions/pointer-secondary-click-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/keyboard-shift-filled-symbolic.svg > $focal/icons/scalable/actions/keyboard-shift-filled-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/keyboard-caps-lock-filled-symbolic.svg > $focal/icons/scalable/actions/keyboard-caps-lock-filled-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/pointer-primary-click-symbolic.svg > $focal/icons/scalable/actions/pointer-primary-click-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/keyboard-layout-filled-symbolic.svg > $focal/icons/scalable/actions/keyboard-layout-filled-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/eye-not-looking-symbolic.svg > $focal/icons/scalable/actions/eye-not-looking-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/pointer-double-click-symbolic.svg > $focal/icons/scalable/actions/pointer-double-click-symbolic.svg
gresource extract $gsource_ubuntu $theme/icons/scalable/actions/eye-open-negative-filled-symbolic.svg > $focal/icons/scalable/actions/eye-open-negative-filled-symbolic.svg

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
if [[ ! -e $focal/focalgdm3.gresource.xml ]]; then
  printf "\n\033[1;32m[\033[0;31mx\033[1;32m] \033[0;31mDid not find the required filename.. Canceled!\n\n"
  rm -rf $focal; exit 1;
else
  (cd $focal/ && glib-compile-resources focalgdm3.gresource.xml && mv focalgdm3.gresource ..)
fi

rm -rf $focal
update-alternatives --quiet --install $gnomeshell/gdm3-theme.gresource gdm3-theme.gresource $focal_gsource 0
update-alternatives --quiet --set gdm3-theme.gresource $focal_gsource

if [[ -e $focal_gsource ]]; then

printf "

---------------------------------------------------------------
All is done!! RESTART And See the New Login-Background :)
---------------------------------------------------------------\n\n";
exit 0;
else
  printf "\n\033[0;31mLogin Background cannot be created.\e[0m\n"
fi
}
function ubuntu_configure_hirsute {
  printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mMaking theme Script.."
install -d /tmp/gnome-shell/theme/icons/scalable/actions/
install -d /tmp/gnome-shell/theme/icons/scalable/status/
install -d /tmp/gnome-shell/theme/Yaru-light/
install -d /tmp/gnome-shell/theme/Yaru/

echo "<?xml version="1.0" encoding="UTF-8"?>" > $tmp_gnomeshell/gdm3-theme.gresource.xml;
echo "<gresources>" >> $tmp_gnomeshell/gdm3-theme.gresource.xml
echo '  <gresource prefix="/org/gnome/shell/theme">' >> $tmp_gnomeshell/gdm3-theme.gresource.xml

for gs in $(gresource list $gsource_ubuntu); do
  gresource extract $gsource_ubuntu $gs > /tmp/gnome-shell/${gs#\/org\/gnome\/shell/}
done

for i in $(gresource list $gsource_ubuntu | sed 's/.......................//'); do
  echo "    <file>$i</file>" >> $tmp_gnomeshell/gdm3-theme.gresource.xml
done

printf "\n\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mChecking script..";sleep 1;
if [[ $images -eq 1 ]]; then
  echo "    <file>$(basename -a $image)</file>" >> $tmp_gnomeshell/gdm3-theme.gresource.xml
  cp $image $tmp_gnomeshell/
  sed -i "/background-color: #4f194c; }/d" $tmp_gnomeshell/gdm3.css
  sed -i '/#lockDialogGroup {/a\  background: #41494c url(resource:///org/gnome/shell/theme/'$(basename -a $image)');\n  background-size: cover;\n  background-repeat: no-repeat;\n  background-position: center; }' $tmp_gnomeshell/gdm3.css
  if ! grep -q $(basename -a $image) $tmp_gnomeshell/gdm3.css; then
    printf "\n\033[1;32m[\033[0;31mx\033[1;32m] \033[0;31mCan't find the image name in script.\n"; exit 1;
  fi
elif [[ $color_background -eq 2 ]]; then
  sed -i "/background-color: #4f194c;/d" $tmp_gnomeshell/gdm3.css;
  sed -i "/#lockDialogGroup {/a\  background-color: $colors; }" $tmp_gnomeshell/gdm3.css;
fi

echo "  </gresource>" >> $tmp_gnomeshell/gdm3-theme.gresource.xml
echo "</gresources>" >> $tmp_gnomeshell/gdm3-theme.gresource.xml
mv $gnomeshell/gdm3-theme.gresource $gnomeshell/theme
(cd ${tmp_gnomeshell}/ && glib-compile-resources gdm3-theme.gresource.xml)
mv ${tmp_gnomeshell}/gdm3-theme.gresource $gnomeshell

rm -rf /tmp/gnome-shell
printf "

---------------------------------------------------------------
All is done!! RESTART And See the New Login-Background :)
---------------------------------------------------------------\n"
exit 0;

}

##########< configure background login kali linux >##########
function kali_configure() {

rm -rf /tmp/gnome-shell
install -d ${tmp_gnomeshell}/icons/scalable/actions/
install -d ${tmp_gnomeshell}/icons/scalable/status/

printf "\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mMaking theme script xml.."
for tmp in $(gresource list $gnomeshell/theme/$(basename -a $gsource_kali)); do
  gresource extract $gnomeshell/theme/$(basename -a $gsource_kali) $tmp > /tmp/gnome-shell/${tmp#\/org\/gnome\/shell/}
done

echo "<?xml version="1.0" encoding="UTF-8"?>" > $tmp_gnomeshell/gnome-shell-theme.gresource.xml;
echo "<gresources>" >> $tmp_gnomeshell/gnome-shell-theme.gresource.xml
echo '  <gresource prefix="/org/gnome/shell/theme">' >> $tmp_gnomeshell/gnome-shell-theme.gresource.xml

for i in $(gresource list $gnomeshell/theme/$(basename -a $gsource_kali) | sed 's/.......................//'); do
  echo "    <file>$i</file>" >> $tmp_gnomeshell/gnome-shell-theme.gresource.xml
done

echo "  </gresource>" >> $tmp_gnomeshell/gnome-shell-theme.gresource.xml
echo "</gresources>" >> $tmp_gnomeshell/gnome-shell-theme.gresource.xml

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
  background-position: center;" ${tmp_gnomeshell}/gnome-shell.css > ${tmp_gnomeshell}/gnome.txt


printf "\n\e[1;77m[\e[0m\e[1;92m+\e[0m\e[1;77m] \e[0mChecking script..";sleep 1;
if [[ $images -eq 1 ]]; then
  cp $image $tmp_gnomeshell/
  sed -i '/#lockDialogGroup {/a\  background: #41494c url(resource:///org/gnome/shell/theme/'$(basename -a $image)');\n  background-size: cover;\n  background-repeat: no-repeat;\n  background-position: center; }' ${tmp_gnomeshell}/gnome.txt
  sed -i '/gnome-shell.css/a\    <file>'$(basename $image)'</file>' $tmp_gnomeshell/gnome-shell-theme.gresource.xml
  if ! grep -q $(basename -a $image) $tmp_gnomeshell/gnome.txt; then
    printf "\n\033[1;32m[\033[0;31mx\033[1;32m] \033[0;31mCan't find the image name in script.\n"; exit 1;
  fi
elif [[ $color_background -eq 2 ]]; then
  sed -i "/background-color: #41494c;/d" $tmp_gnomeshell/gnome.txt;
  sed -i "/#lockDialogGroup {/a\  background-color: $colors; }" $tmp_gnomeshell/gnome.txt
fi

cat ${tmp_gnomeshell}/gnome.txt > ${tmp_gnomeshell}/gnome-shell.css
(cd ${tmp_gnomeshell}/ && glib-compile-resources gnome-shell-theme.gresource.xml)

if [[ ! -e ${tmp_gnomeshell}/gnome-shell-theme.gresource ]]; then
  printf "\n\033[1;31mcompilation not found, something when wrong!\n"; exit 1;
fi

mv ${tmp_gnomeshell}/$(basename -a $gsource_kali) $gnomeshell
rm -rf /tmp/gnome-shell
printf "

---------------------------------------------------------------
All is done!! RESTART And See the New Login-Background :)
---------------------------------------------------------------\n"
exit 0;
}

##########< help command >##########
function help_command() {
printf "Usage: $(basename -a $0) <options>

 --kali  | kali   -- Change Login Background for Kali Linux
 --ubuntu| ubuntu -- Change Login Background for Ubuntu
 --reset | reset  -- Back Original Background for
                      (Kali Linux & Ubuntu)
 --help  | help   -- Help Command\n\n"; exit 0;
}

##########< simple banner >##########
function banner() {
clear;printf "\e[0m\e[0;34mDistro:\033[1;32m "$id"\n\n\t\e[0m\033[92m[--\033[1;33mCHANGE BACKGROUND LOGIN SCREEN\e[0m\033[92m--]\n\n"
}

##########< main script >##########
case $1 in
  kali|--kali )
    if [[ $kali == "Kali" ]]; then
        rm -rf /tmp/gnome-shell
        if [[ ! -d $gnomeshell/theme ]]; then
          install -d $gnomeshell/theme; cp $gsource_kali $gnomeshell/theme
        else
          if [[ ! -e $gnomeshell/theme/$(basename -a $gsource_kali) ]]; then
            cp $gsource_kali $gnomeshell/theme
          fi
        fi
        banner; chooser_path; kali_configure
    else
        printf "\033[1;33mThe script only runs if you are using Kali Linux..\n"; exit 1;
    fi ;;

  ubuntu|--ubuntu )
    rm -rf /tmp/gnome-shell
    if [[ $UBUNTU_CODENAME == "focal" ]] || [[ $UBUNTU_CODENAME == "groovy" ]]; then
      banner; chooser_path; ubuntu_configure
    elif [[ $UBUNTU_CODENAME == "hirsute" ]]; then
      banner; chooser_path; ubuntu_configure_hirsute
    else
      printf "\033[1;33mThe script only runs if you are using Ubuntu..\n"; exit 1;
    fi ;;

  reset|--reset)
    if [[ -e $gnomeshell/theme/$(basename -a $gsource_kali) ]]; then
      mv $gnomeshell/theme/$(basename -a $gsource_kali) $gnomeshell
      printf "\n\e[0mReset has been \e[0m\e[1;92msuccessfully..\n\e[0mNow your $id Linux login background is back to normal.\n\n"; exit 0;

    elif [[ -e $focal_gsource ]]; then
      update-alternatives --quiet --set gdm3-theme.gresource $gsource_ubuntu; rm -rf /usr/local/share/gnome-shell/
      printf "\n\e[0mReset has been \e[0m\e[1;92msuccessfully..\n\e[0mNow your $id login background is back to normal.\n\n"; exit 0;

    elif [[ -e $gnomeshell/theme/gdm3-theme.gresource ]]; then
      mv $gnomeshell/theme/gdm3-theme.gresource $gnomeshell
      printf "\n\e[0mReset has been \e[0m\e[1;92msuccessfully..\n\e[0mNow your $id login background is back to normal.\n\n"; exit 0;

    else
      printf "
      Nothing needs resetting.
      Login background is still the original default $id..\n\n"; exit 0
    fi ;;

  help|-h|--help )
    help_command ;;

  *)
    help_command ;;
esac
