#!/bin/bash

DRIVE=sda
LOCALE=en_US
ZONE=America
CITY=Los_Angeles
HOSTNAME=archer
CPU=amd # for microcode package. ie. amd-ucode or intel-ucode

ln -sf /usr/share/zoneinfo/${ZONE}/${CITY} /etc/localtime
hwclock --systohc
sed -i "s/^#${LOCALE}/en_US/g" /etc/locale.gen
locale-gen
echo "LANG=${LOCALE}.UTF-8" > /etc/locale.conf
echo "${HOSTNAME}" > /etc/hostname
echo -e "127.0.0.1 \tlocalhost\n::1 \t\tlocalhost\n127.0.1.1 \t${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts

passwd

pacman -S --noconfirm ${CPU}-ucode bash-completion vim networkmanager man-db man-pages git
bootctl install

echo -e "default \tarch.conf\ntimeout \t2\nconsole-mode \tmax" > /boot/loader/loader.conf

PARTUUID=$(blkid | grep "^/dev/${DRIVE}3" | tr ' ' '\n' | tail -n1)

echo -e "title \tArch Linux\nlinux \t/vmlinuz-linux\ninitrd \t/${CPU}-ucode.img\ninitrd \tinitrd \tinitramfs-linux.img\noptions root=LABEL=${PARTUUID} rw" > /boot/loader/entries/arch.conf

echo -e "\n\nnow reboot into your new arch linux installation and run the final setup script!"
