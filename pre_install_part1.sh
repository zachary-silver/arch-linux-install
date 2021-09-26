#!/bin/bash

DRIVE=sda

# use 'fdisk -l' to find the disk you'd like to partition and then
# 'fdisk /dev/sdX' to start partitioning the disk and match the layout below.
#
# /dev/sdX1 512M 	EFI System
# /dev/sdX2 4G 		Linux swap
# /dev/sdX3 xG 		Linux filesystem

mkfs.fat -F32 /dev/${DRIVE}1
mkswap /dev/${DRIVE}2
mkfs.ext4 /dev/${DRIVE}3

mount /dev/${DRIVE}3 /mnt
mkdir /mnt/boot
mount /dev/${DRIVE}1 /mnt/boot
swapon /dev/${DRIVE}2

pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

cp /pre_install_part2.sh /mnt

echo -e "\n\nnow run 'arch-chroot /mnt' and then run 'bash /pre_install_part2.sh'!\n\n"
