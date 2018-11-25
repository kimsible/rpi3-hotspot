#!/bin/sh

# Move to mount sdcard point
cd ./root

# Autologin pi
sudo sed -i 's/ExecStart=-\/sbin\/agetty --noclear %I $TERM/ExecStart=-\/sbin\/agetty --noclear -a pi %I $TERM/g' ./lib/systemd/system/getty@.service
    
# Set keyboard mapping
case "$@" in
 '') lang='gb' ;;
 *) lang="$@" ;;
esac
sudo sed -i 's/XKBLAYOUT=".*"/XKBLAYOUT="'$lang'"/g' ./etc/default/keyboard

# Copy interfaces config
sudo cp ../config/interfaces ./etc/network/interfaces

# Copy hostapd config
sudo mkdir -p ./etc/hostapd
sudo cp ../config/hostapd.conf ./etc/hostapd/hostapd.conf

# Copy dnsmasq config
sudo cp ../config/dnsmasq.conf ./etc/dnsmasq.conf.new

# Copy openvpn server and auth config
if [ -f "../config/openvpn-server.conf" ] && [ -f "../config/openvpn-server.auth" ]
then

  sudo mkdir -p ./etc/openvpn
  sudo cp ../config/openvpn-server.conf ./etc/openvpn/server.conf
  sudo cp ../config/openvpn-server.auth ./etc/openvpn/server.auth

fi

# Accept ipv4_forward
sudo sed -i 's/#net\.ipv4\.ip_forward=1/net\.ipv4\.ip_forward=1/g' ./etc/sysctl.conf

# Copy startup script
sudo cp ../config/cron-startup.sh ./opt/cron-startup.sh
sudo chmod a+x ./opt/cron-startup.sh
sudo sed -i "s/^exit 0/sh \/opt\/cron-startup\.sh\n\nexit 0/g" ./etc/rc.local

echo "Done"
