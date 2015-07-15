## Fetch source code from firmware and linux
git clone --depth 1 https://github.com/raspberrypi/firmware
git clone --depth=1 -b rpi-3.19.y --single-branch https://github.com/raspberrypi/linux

## Update firmware files
sudo mkdir /boot/backup
sudo cp /boot/* /boot/backup/
sudo cp -r firmware/modules /lib
sudo cp -r src/firmware/boot /
sudo cp firmware/extra/Module7.symvers linux/Module.symvers
sync
sudo reboot

## Building linux source
cd linux
sudo gunzip -c /proc/config.gz > .config
make oldconfig
make -j5
make -j5 modules
make -j5 modules_install
sudo cp arch/arm/boot/Image /boot/kernel7.img

# wget http://www.mediatek.com/AmazonS3/Downloads/linux/DPO_MT7601U_LinuxSTA_3.0.0.4_20130913.tar.bz2
# tar jxf DPO_MT7601U_LinuxSTA_3.0.0.4_20130913.tar.bz2 ./DPO_MT7601U_LinuxSTA_3.0.0.4_20130913/mcu/bin/MT7601.bin

## Fetch the firmware for MediaTek MT7601 - ID 148f:7601 Ralink Technology, Corp
git clone https://github.com/porjo/mt7601
sudo cp mt7601/src/mcu/bin/MT7601.bin /lib/firmware/mt7601u.bin

## As the source code from manufacture is not accepted by linux source maintainer this 
## one was created from scratch
git clone git@github.com:kuba-moo/mt7601u.git
cd mt7601u
make -j5
modprobe mac80211
insmod ./mt7601u.ko