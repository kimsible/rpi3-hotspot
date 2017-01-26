#!/bin/sh

# Cache dnsmasq and hostapd dependencies
mkdir -p packages
wget -P ./packages -nc `cat sources.list`

# Move to mount sdcard point
cd ./root

# Copy dependencies packages
sudo cp ../packages/*.deb ./var/cache/apt/archives

# Autologin pi
sudo sed -i 's/ExecStart=-\/sbin\/agetty --noclear %I $TERM/ExecStart=-\/sbin\/agetty --noclear -a pi %I $TERM/g' ./lib/systemd/system/getty@.service
    
# Keyboard fr
sudo sed -i 's/XKBLAYOUT="gb"/XKBLAYOUT="fr"/g' ./etc/default/keyboard

# Copy interfaces config
sudo cp ../config/interfaces ./etc/network/interfaces

# Copy hostapd config
sudo mkdir -p ./etc/hostapd
sudo cp ../config/hostapd.conf ./etc/hostapd/hostapd.conf

# Copy dnsmasq config
sudo cp ../config/dnsmasq.conf ./etc/dnsmasq.conf.new

# Accept ipv4_forward
sudo sed -i 's/#net\.ipv4\.ip_forward=1/net\.ipv4\.ip_forward=1/g' ./etc/sysctl.conf

# Copy startup script
sudo cp ../config/cron-startup.sh ./opt/cron-startup.sh
sudo chmod a+x ./opt/cron-startup.sh
sudo sed -i "s/^exit 0/sh \/opt\/cron-startup\.sh\n\nexit 0/g" ./etc/rc.local

echo "Done"