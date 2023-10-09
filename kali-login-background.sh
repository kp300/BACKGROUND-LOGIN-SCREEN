#!/usr/bin/bash
# 
#    CHANGE LOGIN SCREEN BACKGROUND Kali Linux
# -> Kali Linux: 2022, 2023.1, 2023.2, 2023.3 and newer versions <-
#
############## < Support Me > #####################
#
# Youtube  : https://www.youtube.com/Mahinesta
# Facebook : https://fb.me/KaliTutorialOfficial 
###################################################

### Color
Red='\033[0;31m'; BRed='\033[1;31m'; BGreen='\033[1;32m'; BYellow='\033[1;33m'; IYellow='\033[0;93m';
BBlue='\033[1;34m'; BPurple='\033[1;35m'; BCyan='\033[1;36m'; BWhite='\033[1;37m'; Normal='\033[0m'; Gblue='\e[44m';

self=$(basename -a $0)
if [[ -z "$1" ]]; then
	echo -e "${Normal}Try 'sudo bash $(basename -a $self) --help'";
	exit 1;
fi

### Source destination
gresource="/usr/share/gnome-shell/gnome-shell-theme.gresource"
destGST="/usr/share/gnome-shell"
WorkGST="/tmp/gnome-shell/theme"
file_gsxml="gnome-shell-theme.gresource.xml"
file_gst="gnome-shell.css"
KALI_V=$(cat /etc/os-release | sed -n 's/^VERSION=[[:space:]]*//p')
DISTRO=$(lsb_release -i | awk '{print $3}')

### Stop if an error occurs
STOP_ERROR(){ rm -rf /tmp/gnome-shell; exit 1; }
trap STOP_ERROR INT

HELP_COMMAND(){
echo -e "
\t${BGreen}CHANGE LOGIN BACKGROUND KALI LINUX
${BYellow}OPTIONS:${Normal}
 -img|-image|--image 		background with image [.jpg or .png]
 -blur|--blur			background with image blur
 -c|-color|--color 		background with color (Hex Color)
 -s|-start|-gradientstart 	background gradient start
 -e|-end|-gradientend		background gradient end
 -d|--direction 		gradient color direction [vertical or horizontal]
 -r|-reset|--reset		Reset to original background screen
 -usage|--usage   		Example commands
 -h|--help 			Help commands

${BYellow}Example commands: ${Normal}sudo ./$self -usage"
}

USAGE(){ ### Shows examples of usage commands
# clear;	
echo -e "${BCyan}#-- EXAMPLE COMMAND:

${BWhite}With Image 		: ${Gblue}sudo ./$self -img ~/Pictures/your_image.png${Normal}
${BWhite}With Image Blur 	: ${Gblue}sudo ./$self -img ~/Pictures/your_image.png -blur 20%${Normal}
${BYellow}==> You can determine the blur sharpness value ranging from 5% to 50%
${BWhite}With Color 		: ${Gblue}sudo ./$self --color '#e25e31'${Normal}
${BYellow}==> Get more colors here: https://www.color-hex.com
${BWhite}With Gradient-Color	: ${Gblue}sudo ./$self -start \#4287f5 -end \#7207b0 -d vertical${Normal}
			  ${Gblue}sudo ./$self -start '"#4287f5"' -end '"#7207b0"' -d horizontal${Normal}
${BYellow}==> You can change the direction of the gradient horizontal or vertical${Normal}

${BWhite}RESET TO ORIGINAL BACKGROUND SCREEN: ${Gblue}sudo ./$self --reset${Normal}"
}

DdisplayManager=$(cat /etc/X11/default-display-manager)
for gdm in ${DdisplayManager}; do
	### Check! works only for GDM3
	if [[ "$gdm" != "/usr/sbin/gdm3" ]]; then
		echo -e "${Red}This script doesn't work for $(basename -a "${DdisplayManager}") display manager";
		exit 1;
	else
		#### Super user check
		if [ "$EUID" != 0 ]; then echo -e "${Red}Need root to run this script!"; exit 1; else rm -rf /tmp/gnome-shell; fi
	fi
done

BACKUP_GRESOURCE(){
if ! [ -d "${destGST}/theme" ]; then
	mkdir "${destGST}/theme"
fi
### Gresource theme backup
if ! [ -e "${destGST}/theme/$(basename -a $gresource).bak" ]; then
	cp "${gresource}" "${destGST}/theme/$(basename -a $gresource).bak"
fi
}


### Dependency compile-resources
DEPENDENCY_GCR(){
if [[ ! -x $(command -v glib-compile-resources) ]]; then
	echo -e "${Red}glib-compile-resources ${Normal}not installed!"
	read -p 'Do you want to install it? (N/y): ' -n 1
	if [[ "$REPLY" =~ ^[yY]$ ]]; then
		echo ""
		sudo apt install libglib2.0-dev-bin -y
		echo -e "${BYellow}Succesfully!";
		echo -e "Run the script again..";
		exit 0
    else
    	echo -e " Exiting."; STOP_ERROR;
    fi
fi
}
### Dependency imagemagick
DEPENDENCY_GIC(){
if [[ ! -x $(command -v convert) ]]; then
    echo -e "${Red}graphicsmagick-imagemagick-compat ${Normal}not installed!"
	read -p 'Do you want to install it? (N/y): ' -n 1
	if [[ "$REPLY" =~ ^[yY]$ ]]; then
		echo ""
		sudo apt install graphicsmagick-imagemagick-compat -y
		echo -e "${BYellow}Succesfully!";
		echo -e "Run the script again..";
		exit 0
    else
    	echo " Exiting."; STOP_ERROR;
    fi
fi
}

### Extrack GNOME-SHELL-THEME
EXTRACT_RESOURCES(){
BACKUP_GRESOURCE	
if ! [ -e "${destGST}/theme/$(basename -a ${gresource})" ]; then
	cp "${gresource}" "${destGST}/theme"
fi
install -d "${WorkGST}" && touch "$WorkGST/${file_gsxml}"
for gstheme in $(gresource list "${destGST}/theme/$(basename -a ${gresource})"); do
  gresource extract "${destGST}/theme/$(basename -a ${gresource})" $gstheme > "${WorkGST}"/${gstheme#\/org\/gnome\/shell/\theme/}
done
}

### Create an XML Schema THEME
XML_RESOURCES(){
filesource="$(gresource list "${destGST}/theme/$(basename -a ${gresource})" | \
awk '{gsub ("/", ""); print $0}' | \
sed 's/orggnomeshelltheme//' | \
find "${WorkGST}" -type f -printf "    <file>%P</file>\n")"
cat << EOF > "${WorkGST}"/"${file_gsxml}"
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
${filesource}
  </gresource>
</gresources>
EOF
}

### THEME Compiler
COMPILE_RESOURCES() {
(cd "${WorkGST}" && glib-compile-resources $file_gsxml)
if [ -e ${WorkGST}/$(basename -a $gresource) ]; then
	mv "${WorkGST}/$(basename -a $gresource)" "${destGST}";
	PRINT_SUCCES;
	exit 0
else
	echo -e "${Red}Something went wrong!\nAbourting."; STOP_ERROR;
fi
}


### Check availability of gradients
GRADIENT_CHECK(){
if grep -s -q -v "$GRADIENT_START" ${WorkGST}/${file_gst} && \
	grep -s -q -v "$GRADIENT_END" ${WorkGST}/${file_gst};
then
	COMPILE_RESOURCES
else
	echo -e "${Red}Input is invalid!";
	STOP_ERROR;
fi
}


### Check image availability in Theme file
CHECKING_IMG(){
if grep -s -q $img_tmp ${WorkGST}/${file_gst} && \
	grep -s -q $img_tmp ${WorkGST}/${file_gsxml};
then
	COMPILE_RESOURCES; 
else
	echo -e "${Red}Failed to add image inside theme!";
	STOP_ERROR
fi		
}

VERSION_KALI_FORGRADIENTS(){
if [[ "$KALI_V" == '"2023.3"' ]] || [[ "$KALI_V" == '"2023.4"' ]]; then
	### The cover should not be removed
	# new version kali
	if ! grep -Fxq "} /* coverings */" ${WorkGST}/${file_gst}; then
		sed -i '/.login-dialog {/{n;d}' \
		${WorkGST}/${file_gst};
        sed -i '/.login-dialog {/a\} /* coverings */' \
        ${WorkGST}/${file_gst};
    fi
else
	# old version kali
	if ! grep -Fxq "} /* coverings */" ${WorkGST}/${file_gst}; then
        sed -i '/#lockDialogGroup {/{n;d}' \
        ${WorkGST}/${file_gst};
        sed -i '/#lockDialogGroup {/a\} /* coverings */' \
        ${WorkGST}/${file_gst};
    fi
fi
}

VERSION_KALI_FORIMG(){
if [[ "$KALI_V" == '"2023.3"' ]] || [[ "$KALI_V" == '"2023.4"' ]]; then
	echo -e "${IYellow}KALI VERSION: "${Normal}$KALI_V
	SET_IMAGE_NEWVERSION
else
	echo -e "${IYellow}KALI VERSION: "${Normal}$KALI_V
	SET_IMAGE
fi
}

SET_IMAGE_NEWVERSION(){
sed -i "/"$file_gst"/a\    <file>"$img_tmp"</file>" $WorkGST/$file_gsxml;
sed -i '/.login-dialog {/{n;d}' ${WorkGST}/${file_gst};
sed -i '/.login-dialog {/a\  background: #353535 url("resource:///org/gnome/shell/theme/'$img_tmp'"); \
  background-size: cover; \
  background-repeat: no-repeat; \
  background-position: center; }' ${WorkGST}/${file_gst};
}

SET_IMAGE(){		
sed -i "/"$file_gst"/a\    <file>"$img_tmp"</file>" $WorkGST/$file_gsxml;
sed -i '/#lockDialogGroup {/{n;d}' ${WorkGST}/${file_gst};
sed -i '/#lockDialogGroup {/a\  background: #353535 url("resource:///org/gnome/shell/theme/'$img_tmp'"); \
  background-size: cover; \
  background-repeat: no-repeat; \
  background-position: center; }' ${WorkGST}/${file_gst};
}


IMAGE_DEST(){
DEPENDENCY_GCR
image_path="$(realpath -- "$img_path")" && file "$image_path" | grep -qE 'image|bitmap'
img_tmp=$(echo $(basename -a "$image_path") | tr -d ' ')
if [ -f "$image_path" ]; then
	EXTRACT_RESOURCES; XML_RESOURCES;
	cp "$image_path" $WorkGST/$img_tmp && chmod 777 $WorkGST/$img_tmp;
	echo "";echo -e "${IYellow}SET IMAGE: ${Normal}$(basename -a "$image_path")";
else
	echo -e "${Red}Image not found!";
	STOP_ERROR
fi
}

PRINT_SUCCES(){ 
rm -rf /tmp/gnome-shell;
echo -e "${Normal}
---------------------------------------------------------------
${BGreen}All is done!!
${Normal}Run the command: ${BGreen}sudo service gdm3 restart ${Normal}OR ${BGreen}RESTART
And See New Login Background Screen :)${Normal}
---------------------------------------------------------------"
}

RESTORE_GRESOURCE(){
if [ -e "${destGST}/theme/$(basename -a $gresource).bak" ]; then
	mv "${destGST}/theme/$(basename -a $gresource).bak" "${gresource}"
	echo -e "${Normal}
------------------------------------
Reset has been ${BGreen}successfully..
${Normal}------------------------------------"
else
	echo -e "${Normal}\nNothing needs to be reset.\nThe login background is still normal."
fi
}

### Accurate for checking distro
if [[ "$DISTRO" != "Kali" ]]; then
	echo -e "${Red}Sorry! This script is only for Kali Linux";
 	exit 1
fi

######### < START > ######### 
while [ ! -z "$1" ]; do
	case "$1" in
		-image|-img|--image)
			if [ ! -z "$2" ]; then
				img_path="$2"
				IMAGE_DEST
				### [Blur] The expected argument is 4, is the given argument equal to 4
				if [ "$#" -ge 5 ]; then
					echo -e "${Red}Invalid input!";
					STOP_ERROR;
				elif [ "$#" -eq 3 ]; then
					echo -e "${Red}Input is missing!";
					STOP_ERROR;
				elif [ "$#" -eq 4 ]; then
					DEPENDENCY_GIC
				else
					VERSION_KALI_FORIMG; CHECKING_IMG
				fi
			else
				echo -e "${Red}Invalid input!";
				STOP_ERROR;
			fi
			shift ;;
		-blur|--blur)
			if [ -f "$WorkGST/$img_tmp" ]; then
				MAX_BLUR=50
				RP=$(echo "$2" | tr -d '%')
				## If input blur number is less than 5 then set it to default which is 5
				if [ "$RP" -lt 5 ]; then
					echo -e "${IYellow}YOUR BLUR VALUE ${Normal}("$2"%)${IYellow} WILL BE SET TO ${Normal}(5%)";
					convert "$image_path" -sharpen 0x1.0 -blur 0x5 $WorkGST/$img_tmp;
					VERSION_KALI_FORIMG; CHECKING_IMG
				elif [ "$RP" -le $MAX_BLUR ]; then
					echo -e "${IYellow}THE IMAGE BLUR WILL BE SET: ${Normal}("$RP"%)";
					convert "$image_path" -sharpen 0x1.0 -blur 0x"$RP" $WorkGST/$img_tmp;
					VERSION_KALI_FORIMG; CHECKING_IMG
				## Maximum input blur number is 50, no more	
				elif [ "$RP" -gt $MAX_BLUR ]; then
					echo -e "${Red}The blurring value cannot be more than $MAX_BLUR%\nAbourting.";
					STOP_ERROR
				else
					echo -e "${Red}'$RP' input is invalid!"
				fi
			else
				echo -e "${Red}Please set the --image <image_path> first!";
				STOP_ERROR;
			fi
			break ;;			
		-c|-color|--color)
			if [ -z "$2" ]; then
				echo -e "${Red}Color is not provided!";
				STOP_ERROR;
			fi
			if ! [[ "$2" =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then
    			echo -e "${Red}The hex color you input is invalid!";
    			STOP_ERROR;
  			fi
			EXTRACT_RESOURCES; XML_RESOURCES;
			if [[ "$KALI_V" == '"2023.3"' ]] || [[ "$KALI_V" == '"2023.4"' ]]; then
				echo -e "${IYellow}KALI VERSION: "${Normal}$KALI_V;
				sed -i '/.login-dialog {/{n;d}' ${WorkGST}/${file_gst};
				sed -i "/.login-dialog {/a\  background-color: "$2"; }" ${WorkGST}/${file_gst};
			else
				echo -e "${IYellow}KALI VERSION: "${Normal}$KALI_V
				sed -i '/#lockDialogGroup {/{n;d}' ${WorkGST}/${file_gst};
				sed -i "/#lockDialogGroup {/a\  background-color: "$2"; }" ${WorkGST}/${file_gst};
			fi			
			COMPILE_RESOURCES
			break ;;
		-s|-start|-gradientstart)
			if ! [[ "$2" =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then
    			echo -e "${Red}The hex color you input is invalid!"; STOP_ERROR
  			fi
			if [ ! -d "${WorkGST}" ]; then
				EXTRACT_RESOURCES; XML_RESOURCES; 
			fi
			VERSION_KALI_FORGRADIENTS
  			GRADIENT_START="$2"
  			#if gradient is not provided
  			if [ "$#" -eq 2 ]; then
  				echo -e "${Red}You must determine the direction of the gradient!\nThere are no changes whatsoever.\nAbourting.";
  				STOP_ERROR;
  			fi
  			shift ;;
		-e|-end|-gradientend)
			if ! [[ "$2" =~ ^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$ ]]; then
    			echo -e "${Red}The hex color you input is invalid!"; STOP_ERROR
  			fi
			if [ ! -d "${WorkGST}" ]; then
				EXTRACT_RESOURCES; XML_RESOURCES;
			fi
			VERSION_KALI_FORGRADIENTS
  			GRADIENT_END="$2"
  			#if gradient is not provided
  			if [ "$#" -eq 2 ]; then
  				echo -e "${Red}You must determine the direction of the gradient!\nThere are no changes whatsoever.\nAbourting.";
  				STOP_ERROR;
  			fi
	  		shift ;;
		-d|--direction)
			if [ -z "$2" ]; then
				echo -e "${Red}Gradient Direction is not provided! [Horizontal or Vertical]"; 
				echo -e "${Red}Abourting!"; STOP_ERROR
			else
				if [ "$2" == "horizontal" ] || [ "$2" == "vertical" ]; then
    				GRADIENT_DIRECTION="$2"
    				echo "";
    				# echo -e "${IYellow}GRADIENT START: ${Normal}"${GRADIENT_END}""
    				# echo -e "${IYellow}GRADIENT END: ${Normal}"${GRADIENT_START}""
    				# echo -e "${IYellow}GRADIENT DIRECTION: ${Normal}"${GRADIENT_DIRECTION}""
    				if [ "$#" -eq 2 ]; then
						### The cover should not be removed
						if [[ "$KALI_V" == '"2023.3"' ]] || [[ "$KALI_V" == '"2023.4"' ]]; then
							echo -e "${IYellow}KALI VERSION: "${Normal}$KALI_V
							sed -i '/.login-dialog {/a\  background-gradient-start: '$GRADIENT_START';\n  background-gradient-end: '$GRADIENT_END';\n  background-gradient-direction: '$GRADIENT_DIRECTION';' \
							${WorkGST}/${file_gst}; GRADIENT_CHECK; COMPILE_RESOURCES
						else
							echo -e "${IYellow}KALI VERSION: "${Normal}$KALI_V
							sed -i '/#lockDialogGroup {/a\  background-gradient-start: '$GRADIENT_START';\n  background-gradient-end: '$GRADIENT_END';\n  background-gradient-direction: '$GRADIENT_DIRECTION';' \
							${WorkGST}/${file_gst}; GRADIENT_CHECK; COMPILE_RESOURCES
						fi
					else
						echo -e "${Red}Define gradient-start and gradient-end colors first";
						STOP_ERROR;
					fi
				else
					echo -e "${Red}'"$2"' input is invalid!";
					STOP_ERROR;
  				fi
			fi
  			break ;;
		-r|-reset|--reset) RESTORE_GRESOURCE; exit 0 ;;			
		-usage|--usage) USAGE; exit 0 ;;
		-h|--help) HELP_COMMAND; exit 0 ;;
     	*) echo -e "${Red}'"$1"' argument is invalid!"; exit 1 ;;
	esac
	shift # not remove
done
# end
