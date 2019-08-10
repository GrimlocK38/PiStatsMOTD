PiStatsMOTD
====

#### Message of the Day with Detailed Stats for the Raspberry Pi ####

<p align="center">
  <img src="https://github.com/shanemc92/PiStatsMOTD/blob/master/PiStatsMOTD-Preview.png?raw=true"/>
</p>

Tested with Raspbian and RetroPie distributions. No additional packages are required to be installed.

Download and save the `pistats.sh` script to the /etc/profile.d/ folder on your Raspberry Pi then follow the steps below.

1. Change owner to root.
`sudo chown root:root /etc/profile.d/pistats.sh`
2. Make the script executable.
`sudo chmod +x /etc/profile.d/pistats.sh`
3. Remove the existing message of the day.
`sudo rm /etc/motd`
4. Disable the last login information from the sshd service.
`sudo nano /etc/ssh/sshd_config` - Uncomment the line 'PrintLastLog yes' and change it to 'PrintLastLog no'
5. Disable the system information line.
`sudo nano /etc/update-motd.d/10-uname` - Comment out the line 'uname -snrvm'
6. If installing on RetroPie, remove the existing MOTD.
`sudo nano ~/.bashrc` - Comment out the second last line 'retropie_welcome'
7. Change the logo to the RetroPie, PiHole or PiStick variations by commenting or renaming the default Ras-Pi logo and uncommenting the logo of your choice.
8. Reboot the Pi
`sudo reboot`
