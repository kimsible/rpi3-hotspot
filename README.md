# Raspberry Pi 3 Hotspot Install

This is an install script to prepare a raspbian-jessie-lite image and configure your Raspberry Pi 3 as a hotspot.

## 1. Flash sdcard

### Check what volume /dev/sdX is already mounted and used
    
    $ df -h
    
if your sdard is mounted 
    
    $ sudo umount /dev/sdX

### Format and copy raspbian-jessie-lite.img to sdcard

    $ sudo dd if=/dev/zero of=/dev/sdX bs=1M count=8
    $ sudo dd bs=4M if=raspbian-jessie-lite.img of=/dev/sdX 

## 2. Mount sdcard on ./root

    $ sudo mount -v -o offset=70254592 -t ext4 /dev/sda ./root

If `offset` does not match, you can get it with this command :
    
    $ sudo fdisk -l /dev/sdX    

It should return something like that : 

    Device     Boot  Start     End Sectors  Size Id Type
    /dev/sdX1         8192  137215  129024   63M  c W95 FAT32 (LBA)
    /dev/sdX2       137216 2709503 2572288  1,2G 83 Linux

So `offset=512*137216`.

## 3. Config SSID and password

Edit SSID and password in `config/hostapd.conf`

Optionally you may also edit IPs in `config/interfaces` and `config/dnsmasq.conf`

## 4. Run script

    sh start.sh

## Unmount sdcard

    sudo umount ./root

## Sources

- http://raspberrypi.stackexchange.com/
- https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/

