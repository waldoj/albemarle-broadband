#!/usr/bin/env bash

# Set up a Rasperry Pi 
# A codification (and modification) of https://www.arduinomaker.dk/2018/12/07/wifi-wardriving-kismet-on-raspberry-pi/

# Step 1: Download Kali https://www.offensive-security.com/kali-linux-arm-images/
# Step 2: Load the image onto a MicroSD card with https://www.balena.io/etcher/
# Step 3: Install the MicroSD, boot the Raspberry Pi
# Step 4: curl -sSL https://raw.githubusercontent.com/waldoj/albemarle-broadband/master/pidriving/kismet-pi.sh | sh

# Install Kismet and GPS support
apt-get update
apt-get upgrade -y
apt-get install -y kismet gpsd gpsd-clients python-gps

# Use Eastern Time (update to your preference, of course)
rm /etc/localtime
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime

# Disable the GPSD systemd
systemctl stop gpsd.socket
systemctl disable gpsd.socket

# Disable timeout for wireless interface
echo "iface wlan1 inet static" >> /etc/network/interfaces

# Add both wireless interfaces to Kismet's configuration
echo "ncsource=wlan0" >> /etc/kismet/kismet.conf
echo "ncsource=wlan1" >> /etc/kismet/kismet.conf

# Enable audio alerts in Kismet
sed -i 's/enablesound=false/enablesound=true/g' /etc/kismet/kismet.conf

# Set up Kismet to run at boot time
curl -o crontab.txt https://raw.githubusercontent.com/waldoj/albemarle-broadband/master/pidriving/crontab.txt
crontab crontab.txt

# Set system to use runlevel 3
systemctl set-default multi-user.target

# Install SSH server
apt-get install penssh-server
update-rc.d -f ssh remove
update-rc.d -f ssh defaults
update-rc.d -f ssh enable 2 3 4 5
sudo service ssh restart

# Reboot the system
reboot now
