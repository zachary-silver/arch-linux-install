#!/bin/bash

DRIVE=sda
LOCALE=en_US
ZONE=America
CITY=Los_Angeles
HOSTNAME=archer
CPU=amd # for microcode package. ie. amd-ucode or intel-ucode

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

pacstrap /mnt base base-devel linux linux-firmware bash-completion vim networkmanager man-db man-pages git
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/${ZONE}/${CITY} /etc/localtime
hwclock --systohc
sed -i "s/^#${LOCALE}/en_US/g" /etc/locale.gen
locale-gen
echo "LANG=${LOCALE}.UTF-8" > /etc/locale.conf
echo "${HOSTNAME}" > /etc/hostname
echo -e "127.0.0.1 \tlocalhost\n::1 \t\tlocalhost\n127.0.1.1 \t${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts

passwd

pacman -S ${CPU}-ucode
bootctl install

echo -e "default \tarch.conf\ntimeout \t2\nconsole-mode \tmax" > /boot/loader/loader.conf

PARTUUID=$(blkid | grep "^/dev/${DRIVE}3" | tr ' ' '\n' | tail -n1)

echo -e "title \tArch Linux\nlinux \t/vmlinuz-linux\ninitrd \t/${CPU}-ucode.img\ninitrd \tinitrd \tinitramfs-linux.img\noptions \troot=LABEL=${PARTUUID} rw"
