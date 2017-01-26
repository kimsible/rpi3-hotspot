#!/bin/bash  

# install dependencies
apt-get install -y hostapd dnsmasq

if [ -f "/etc/dnsmasq.conf.new" ]
then 
  
  # disable dhcpcd on wlan0 and config hostapd daemon
  sh -c "echo 'denyinterfaces wlan0' >> /etc/dhcpcd.conf"
  sed -i 's/^#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

  # copy config dnsmasq
  mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig  
  mv /etc/dnsmasq.conf.new /etc/dnsmasq.conf  

  # config iptables
  iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
  iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
  iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
  sh -c "iptables-save > /etc/iptables.ipv4.nat" 
  sed -i "s/^exit 0/iptables-restore < \/etc\/iptables\.ipv4.nat\n\nexit 0/g" /etc/rc.local
  
fi

# disable this cron on startup
sed -i "s/^sh \/opt\/cron-startup\.sh/#sh \/opt\/cron-startup\.sh/g" /etc/rc.local

exit 0
