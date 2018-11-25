# Raspberry Pi 3 Hotspot Install

This is an install script to prepare a raspbian-lite image and configure your Raspberry Pi 3 as a hotspot.


## 1. Download latest raspbian lite

    $ wget https://downloads.raspberrypi.org/raspbian_lite_latest

    $ unzip raspbian_lite_latest


## 2. Flash sdcard

### Check what volume /dev/sdX is already mounted and used
    
    $ df -h
    
if your sdcard is mounted 
    
    $ sudo umount /dev/sdX

### Format and copy raspbian-*-lite.img to sdcard

    $ sudo dd if=/dev/zero of=/dev/sdX bs=1M count=8
    $ sudo dd bs=4M if=*raspbian-*-lite.img of=/dev/sdX

## 3. Mount sdcard on ./root

    $ sudo mount -v -o offset=70254592 -t ext4 /dev/sdX ./root

If `offset` does not match, you can get it with this command :
    
    $ sudo fdisk -l /dev/sdX

It should return something like that : 

    Device     Boot  Start     End Sectors  Size Id Type
    /dev/sdX1         8192  137215  129024   63M  c W95 FAT32 (LBA)
    /dev/sdX2       137216 2709503 2572288  1,2G 83 Linux

So `offset=512*137216`.

## 4. Config SSID and password

Edit SSID and password in `config/hostapd.conf`

Optionally you may also edit IPs in `config/interfaces` and `config/dnsmasq.conf`

## 5. Config openvpn

Put your openvpn server conf in `config/openvpn-server.conf`

Put your username and password in `config/openvpn-server.auth`


## 6. Run script

    $ sh start.sh

To re-mapping the keyboard give the two letter code for your country as argument : 

    $ sh start.sh fr

## Unmount sdcard

    $ sudo umount ./root

## Sources

- http://raspberrypi.stackexchange.com/
- https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/

