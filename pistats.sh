#!/bin/bash

# README
# Save this file to /etc/profile.d/pistats.sh
# Change owner to root using;
#	`sudo chown root:root /etc/profile.d/pistats.sh`
# Make the file executable using;
#	`sudo chmod +x /etc/profile.d/pistats.sh`
# Remove existing MOTD and last login using;
#	`sudo rm /etc/motd`
# Disable the last login information from the sshd service using;
#	`sudo nano /etc/ssh/sshd_config` - Uncomment the line 'PrintLastLog yes' and change it to 'PrintLastLog no'
# Disable the system information line using;
# 	`sudo /etc/update-motd.d/10-uname` - Comment out the line 'uname -snrvm'
# On RetroPie, remove the existing MOTD;
# 	`sudo nano ~/.bashrc` - Comment out the second last line 'retropie_welcome'
# Change the logo below by commenting out the default Ras-Pi logo and uncommenting one of the others. 


# Logged on user - Example: pi
VAR_USR="$(whoami)"
# OS version - Example: Raspbian GNU/Linux 10 (buster)"
VAR_OS="$(cat /etc/os-release | grep "PRETTY_NAME=" | cut -c 14-)"
# OS version and hardware name - Example: Raspbian GNU/Linux 10 (buster) armv6l
VAR_OS2="${VAR_OS::-1} $(uname -m)"
# Raspberry Pi model - Example: Raspberry Pi Zero W Rev 1.1
VAR_MODEL="$(tr -d '\0' </proc/device-tree/model)"
# Device hostname - Example: raspberrypi
VAR_HOST="$(hostname)"
# Kernel version - Example: 4.19.58+
VAR_KERNEL="$(uname -r)"
# Number of available updates - Example: 12
VAR_UPDATES="$(apt-get -s dist-upgrade | grep -Po '^[[:digit:]]+ (?=upgraded)')"
# Number of installed packages - Example: 526
VAR_PACKAGES="$(dpkg -l | grep -c '^ii')"
# Version of bash installed - Example: bash 5.0.3(1)-release
VAR_SHELL="bash $(echo $BASH_VERSION)"
# Uptime of the System in days, hours and minutes
VAR_UPTIME="$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* user.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/')"
# RAM information
VAR_MEMORY="$(free -m | awk 'NR==2 { printf "Used: %sMB (%.0f%%), %sMB free of %sMB",$3,substr($3/$2*100,0,3),$4,$2; }')"
# Storage information
VAR_SPACE="$(df -h ~ | awk 'NR==2 { printf "Used: %sB (%.0f%%), %sB free of %sB",$3,substr($3/$2*100,0,3),$4,$2; }')"
# CPU load averages
VAR_LOADAVG="$(uptime | sed 's/^.*\(load*\)/\1/g' | awk '{printf "%s (1m) %s (5m) %s (15m)", substr($3,0,5),substr($4,0,5),substr($5,0,5); }')"
# Number of logged in users
VAR_USERS_LOGGED="$(who | grep -v localhost | wc -l)"
# Usernames of all logged in users
VAR_USERNAMES_LOGGED="$(users)"
# Number of running processes
VAR_PROCESSES="$(ps ax | wc -l | tr -d ' ')"
# Internal IP address
VAR_IP_INTERN="$(hostname -I)"
# External IP address
VAR_IP_EXTERN="$(timeout --signal=SIGINT 3 wget -q -O - http://icanhazip.com/ | tail)"
# CPU temperature - Example: 40.9°C
VAR_TEMP="$(/opt/vc/bin/vcgencmd measure_temp | cut -c '6-9')°C"
# Last login time - Example: 6 Aug 2019 17:45:45
VAR_LAST_LOGIN="$(last -i $USER -F | grep -v 'still logged' | head -1 | awk '{print $6,$5,$8,$7}')"
# IP of last login user - Example: 192.168.0.43
VAR_LAST_LOGIN_IP="$(last -i $USER -F | grep -v 'still logged' | head -1 | awk '{print $3}')"
# Current date and time - Example: Tuesday, 6 August 2019, 19:35
VAR_DATE="$(date +'%A,%e %B %Y, %R')"
# System kernel name, hostname, kernel release, machine hardware name, and operating system -  Example: Linux raspberrypi 4.19.58+ armv6l GNU/Linux
VAR_UNAME="$(uname -snrmo)"

# Assign colours to variables
RST="$(tput sgr0)" # Reset Colour
BLD="$(tput bold)" # Make Bold
BLK="${RST}$(tput setaf 0)"
RED="${RST}$(tput setaf 1)"
GRE="${RST}$(tput setaf 2)"
YEL="${RST}$(tput setaf 3)"
BLU="${RST}$(tput setaf 4)"
MAG="${RST}$(tput setaf 5)"
CYA="${RST}$(tput setaf 6)"
WHI="${RST}$(tput setaf 7)"
BBLK="${BLD}$(tput setaf 0)"
BRED="${BLD}$(tput setaf 1)"
BGRE="${BLD}$(tput setaf 2)"
BYEL="${BLD}$(tput setaf 3)"
BBLU="${BLD}$(tput setaf 4)"
BMAG="${BLD}$(tput setaf 5)"
BCYA="${BLD}$(tput setaf 6)"
BWHI="${BLD}$(tput setaf 7)"

# Lines of info to be displayed
Line01="${BGRE}${VAR_DATE}"
Line02="${BWHI}-------------"
Line03="${BRED}OS${WHI}:           ${VAR_OS2}"
Line04="${BRED}Model${WHI}:        ${VAR_MODEL}"
Line05="${BRED}Kernel${WHI}:       ${VAR_KERNEL}"
Line06="${BRED}Shell${WHI}:        ${VAR_SHELL}"
Line07="${BYEL}Uptime${WHI}:       ${VAR_UPTIME}"
Line08="${BYEL}CPU${WHI}:          [${VAR_TEMP}] ${VAR_LOADAVG}"
Line09="${BYEL}Memory${WHI}:       ${VAR_MEMORY}"
Line10="${BYEL}Filesystem${WHI}:   ${VAR_SPACE}"
Line11="${BMAG}Processes${WHI}:    ${VAR_PROCESSES} Running"
Line12="${BMAG}Updates:${WHI}      ${VAR_UPDATES}/ ${VAR_PACKAGES} Packages Require Updates"
Line13="${BCYA}Last Login${WHI}:   ${VAR_LAST_LOGIN} from ${VAR_LAST_LOGIN_IP}"
Line14="${BCYA}SSH Logins${WHI}:   ${VAR_USERS_LOGGED} users: ${VAR_USERNAMES_LOGGED}"
Line15="${BCYA}IP Addresses${WHI}: ${VAR_IP_INTERN}(${VAR_IP_EXTERN})"
Line16=""

# Logos - Uncomment one to use 
logo=(
	"${BWHI}     ___             ___ _       "
	"${BWHI}    | _ \__ _ ______| _ (_)      "
	"${BWHI}    |   / _\` (_-<___|  _/ |      "
	"${BWHI}    |_|_\__,_/__/   |_| |_|      "
	"${BWHI}                                 "
	"${BGRE}          .~~.   .~~.            "
	"${BGRE}         '. \ ' ' / .'           "
	"${BRED}          .~ .~~~..~.            "
	"${BRED}         : .~.'~'.~. :           "
	"${BRED}        ~ (   ) (   ) ~          "
	"${BRED}       ( : '~'.~.'~' : )         "
	"${BRED}        ~ .~ (   ) ~. ~          "
	"${BRED}         (  : '~' :  )           "
	"${BRED}          '~ .~~~. ~'            "
	"${BRED}              '~'                "
	"${BWHI}                                 "
)	

# logo=(
	# "${BWHI}                                 "
	# "${BWHI}  ___  _ ____ ___ _ ____ _  _    "
	# "${BWHI}  |--' | ====  |  | |___ |-:_    "
	# "${BWHI}                                 "
	# "${BGRE}          .~~.   .~~.            "
	# "${BGRE}         '. \ ' ' / .'           "
	# "${BRED}          .~ .~~~..~.            "
	# "${BRED}         : .~.'~'.~. :           "
	# "${BRED}        ~ (   ) (   ) ~          "
	# "${BRED}       ( : '~'.~.'~' : )         "
	# "${BRED}        ~ .~ (   ) ~. ~          "
	# "${BRED}         (  : '~' :  )           "
	# "${BRED}          '~ .~~~. ~'            "
	# "${BRED}              '~'                "
	# "${BWHI}                                 "
# )	

# logo=(
	# "${BWHI}  ___     _           ___ _      "
	# "${BWHI} | _ \___| |_ _ _ ___| _ (_)___  "
	# "${BWHI} |   / -_)  _| '_/ _ \  _/ / -_) "
	# "${BWHI} |_|_\___|\__|_| \___/_| |_\___| "
	# "${RED}                                 "
	# "${RED}              .***.              "
	# "${RED}              ***${BWHI}*${RED}*              "
	# "${RED}              \`***'              "
	# "${BWHI}               |*|               "
	# "${BWHI}               |*|               "
	# "${BRED}             ..${BWHI}|*|${BRED}..             "
	# "${BRED}           .*** ${BWHI}*${BRED} ***.           "
	# "${BRED}           *******${GRE}@@${BRED}**           "
	# "${RED}           \`*${BRED}****${BYEL}@@${BRED}*${RED}*'           "
	# "${RED}            \`*******'            "
	# "${RED}              \`\"\"\"'              "
# )

# logo=(
	# "${BWHI}     ${BRED}_${BYEL}_${BGRE}_ _   ${BYEL}_        ${BRED}_          "
	# "${BWHI}    ${BRED}| ${BYEL}_ ${BGRE}(${BCYA}_)${BBLU}_${BMAG}| ${BRED}|_  ${BGRE}__${BCYA}_| ${BBLU}|${BMAG}__${BRED}_      "
	# "${BWHI}    ${BYEL}|  ${BGRE}_${BCYA}/ ${BBLU}|${BMAG}_${BRED}| ${BYEL}' ${BGRE}\/ ${BCYA}_ ${BBLU}\ ${BMAG}/ ${BRED}-${BYEL}_)     "
	# "${BWHI}    ${BGRE}|_${BCYA}| ${BBLU}|_${BMAG}| ${BYEL}|_${BGRE}||${BCYA}_\\${BBLU}__${BMAG}_/${BRED}_\\${BYEL}__${BGRE}_|     "
	# "${BGRE}         .~~.                    "
	# "${BGRE}         : \ '.     ..^.         "
	# "${BGRE}          '.\ ~   .'~~.'         "
	# "${BGRE}            ~ .'~~'..~'          "
	# "${BRED}              #####              "
	# "${BRED}         ..###########..         "
	# "${BRED}        '##'.#######.'##'        "
	# "${BRED}       ######\  '  /######       "
	# "${BRED}     #########)   (#########     "
	# "${BRED}       ######/  .  \######       "
	# "${BRED}        .##.'#######'.##.        "
	# "${BRED}          ''#########''          "
	# "${BRED}              #####              "
# )

# Loop to stick logo and lines together 
for i in "${!logo[@]}"; do
	out+="  ${logo[$i]}  "
	case "$i" in
		0) out+="${Line01}";;
		1) out+="${Line02}";;
		2) out+="${Line03}";;
		3) out+="${Line04}";;
		4) out+="${Line05}";;
		5) out+="${Line06}";;
		6) out+="${Line07}";;
		7) out+="${Line08}";;
		8) out+="${Line09}";;
		9) out+="${Line10}";;
		10) out+="${Line11}";;
		11) out+="${Line12}";;
		12) out+="${Line13}";;
		13) out+="${Line14}";;
		14) out+="${Line15}";;
		15) out+="${Line16}";;
	esac
	out+="\n"
done

# Display the combined result 
echo -e "\n$out"

# Colour Bar - Uncomment to display
#echo "                                     ${BLK}██${RED}██${GRE}██${YEL}██${BLU}██${MAG}██${CYA}██${WHI}██${BBLK}██${BRED}██${BGRE}██${BYEL}██${BBLU}██${BMAG}██${BCYA}██${BWHI}██"
echo ""
