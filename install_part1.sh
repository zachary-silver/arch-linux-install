#!/bin/bash

INSTALL_PART2_URL='https://raw.githubusercontent.com/zachary-silver/Arch_Linux_Install/master/install_part2.sh'
INSTALL_PART3_URL='https://raw.githubusercontent.com/zachary-silver/Arch_Linux_Install/master/install_part3.sh'

echo "Before executing the rest of this script, run 'fdisk -l' to find the device"
echo "you'd like to partition and then run 'fdisk /dev/sdX' to start partitioning"
echo "the device and match the layout below:"
echo ""
echo -e "/dev/sdX1 512M\t EFI System"
echo -e "/dev/sdX2 4G\t Linux swap"
echo -e "/dev/sdX3 xG\t Linux filesystem"
echo ""

echo "Now, enter the device's identifier that you chose (ie. sda, sdb, sdc...):"

read DEVICE
output=$(ls /dev/${DEVICE} 2>/dev/null)
while [[ -z "$DEVICE" || -z "$output" ]];
do
    echo "Invalid identifier. Please enter again:"
    read DEVICE
    output=$(ls /dev/${DEVICE} 2>/dev/null)
done

mkfs.fat -F32 /dev/${DEVICE}1
mkswap /dev/${DEVICE}2
mkfs.ext4 /dev/${DEVICE}3

mount /dev/${DEVICE}3 /mnt
mkdir /mnt/boot
mount /dev/${DEVICE}1 /mnt/boot
swapon /dev/${DEVICE}2

pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

curl -sL ${INSTALL_PART2_URL} -o /mnt/install_part2.sh
curl -sL ${INSTALL_PART3_URL} -o /mnt/install_part3.sh

sed -i "s/^DEVICE/DEVICE=${DEVICE}/g"

echo -e "\n\nNow run 'arch-chroot /mnt' and then run 'bash /install_part2.sh'!\n\n"
