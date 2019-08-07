#!/bin/bash

# Save to /etc/profile.d
# Change owner to root `sudo chown root:root /etc/profile.d/pistats.sh`
# Make executable `sudo chmod +x /etc/profile.d/pistats.sh`
# Remove existing MOTD and last login with `sudo rm /etc/motd`

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
VAR_MEMORY="$(free -m | awk 'NR==2 { printf "Free:  %sMB (%s%%), Total: %sMB",$4,substr($4/$2*100,0,3),$2; }')"
# Storage information
VAR_SPACE="$(df -h ~ | awk 'NR==2 { printf "Total: %sB, Used: %sB, Free: %sB",$2,$3,$4; }')"
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
BLK=$(tput setaf 0)
RED=$(tput setaf 1)
GRE=$(tput setaf 2)
YEL=$(tput setaf 3)
BLU=$(tput setaf 4)
MAG=$(tput setaf 5)
CYA=$(tput setaf 6)
WHI=$(tput setaf 7)

# Display with logo on left side
echo ""
echo "                               ${GRE}${CYA}${VAR_DATE}"
echo "${WHI} ___  _ ____ ___ _ ____ _  _   ${WHI}-------------"
echo "${WHI} |--' | ====  |  | |___ |-:_   ${YEL}OS${WHI}:           ${VAR_OS2}"
echo "${WHI}                               ${YEL}Model${WHI}:        ${VAR_MODEL}"
echo "${GRE}         .~~.   .~~.           ${YEL}Kernel${WHI}:       ${VAR_KERNEL}"
echo "${GRE}        '. \ ' ' / .'          ${YEL}Shell${WHI}:        ${VAR_SHELL}"
echo "${RED}         .~ .~~~..~.           ${YEL}Uptime${WHI}:       ${VAR_UPTIME}"
echo "${RED}        : .~.'~'.~. :          ${MAG}CPU${WHI}:          [${VAR_TEMP}] ${VAR_LOADAVG}"
echo "${RED}       ~ (   ) (   ) ~         ${MAG}Memory${WHI}:       ${VAR_MEMORY}"
echo "${RED}      ( : '~'.~.'~' : )        ${MAG}Filesystem${WHI}:   ${VAR_SPACE}"
echo "${RED}       ~ .~ (   ) ~. ~         ${MAG}Processes${WHI}:    ${VAR_PROCESSES} Running"
echo "${RED}        (  : '~' :  )          ${CYA}Updates:${WHI}      ${VAR_UPDATES}/ ${VAR_PACKAGES} Packages Require Updates"
echo "${RED}         '~ .~~~. ~'           ${CYA}Last Login${WHI}:   ${VAR_LAST_LOGIN} from ${VAR_LAST_LOGIN_IP}"
echo "${RED}             '~'               ${CYA}SSH Logins${WHI}:   ${VAR_USERS_LOGGED} users: ${VAR_USERNAMES_LOGGED}"
echo "${WHI}                               ${CYA}IP Addresses${WHI}: ${VAR_IP_INTERN}(${VAR_IP_EXTERN})"
echo ""
echo "                               ${BLK}████${RED}████${GRE}████${YEL}████${BLU}████${MAG}████${CYA}████${WHI}████"
echo ""

# Display with logo on top
# echo "${CYA}${VAR_DATE}"
# echo ""
# echo "${GRE}     .~~.   .~~.     ${RED}                 _                          _ "
# echo "${GRE}    '. \ ' ' / .'    ${RED} ___ ___ ___ ___| |_ ___ ___ ___ _ _    ___|_|"
# echo "${RED}     .~ .~~~..~.     ${RED}|  _| .'|_ -| . | . | -_|  _|  _| | |  | . | |"
# echo "${RED}    : .~.'~'.~. :    ${RED}|_| |__,|___|  _|___|___|_| |_| |_  |  |  _|_|"
# echo "${RED}   ~ (   ) (   ) ~   ${RED}            |_|                 |___|  |_|    "
# echo "${RED}  ( : '~'.~.'~' : )  ${WHI}         ___  _ ____ ___ _ ____ _  _          "
# echo "${RED}   ~ .~ (   ) ~. ~   ${WHI}         |--' | ====  |  | |___ |-:_          "
# echo "${RED}    (  : '~' :  )    "
# echo "${RED}     '~ .~~~. ~'     "
# echo "${RED}         '~'         "
# echo ""
# echo "${GRE}${VAR_USR}${WHI}@${GRE}${VAR_HOST}"
# echo "${WHI}-------------"
# echo "${YEL}OS${WHI}:           ${VAR_OS2}"
# echo "${YEL}Model${WHI}:        ${VAR_MODEL}"
# echo "${YEL}Kernel${WHI}:       ${VAR_KERNEL}"
# echo "${YEL}Uptime${WHI}:       ${VAR_UPTIME}"
# echo "${MAG}CPU${WHI}:          [${VAR_TEMP}] ${VAR_LOADAVG}"
# echo "${MAG}Memory${WHI}:       ${VAR_MEMORY}"
# echo "${MAG}Filesystem${WHI}:   ${VAR_SPACE}"
# echo "${MAG}Processes${WHI}:    ${VAR_PROCESSES} Running"
# echo "${CYA}Updates:${WHI}      ${VAR_UPDATES}/ ${VAR_PACKAGES} Packages Require Updates"
# echo "${CYA}Last Login${WHI}:   ${VAR_LAST_LOGIN} from ${VAR_LAST_LOGIN_IP}"
# echo "${CYA}SSH Logins${WHI}:   ${VAR_USERS_LOGGED} users: ${VAR_USERNAMES_LOGGED}"
# echo "${CYA}IP Addresses${WHI}: ${VAR_IP_INTERN}(${VAR_IP_EXTERN})"
# echo "" 
# echo "${BLK}████${RED}████${GRE}████${YEL}████${BLU}████${MAG}████${CYA}████${WHI}████"
# echo ""


     # .***.     Wednesday,  7 August 2019, 17:16:15
     # *****     Linux 4.14.98-v7+ armv7l GNU/Linux
     # `***'
      # |*|      Filesystem      Size  Used Avail Use% Mounted on
      # |*|      /dev/root        59G   42G   15G  74% /
    # ..|*|..    Uptime.............: 0 days, 00h25m19s
  # .*** * ***.  Memory.............: 375688kB (Free) / 766748kB (Total)
  # *******@@**  Running Processes..: 120
  # `*****@@**'  IP Address.........: 192.168.0.250
   # `*******'   Temperature........: CPU: 40°C/104°F GPU: 40°C/104°F
     # `"""'     The RetroPie Project, https://retropie.org.uk
