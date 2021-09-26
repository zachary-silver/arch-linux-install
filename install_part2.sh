#!/bin/bash

DEVICE=''
DEFAULT_HOSTNAME=archer
DEFAULT_LOCALE=en_US
DEFAULT_ZONE=America
DEFAULT_CITY=Los_Angeles
CPU='' # for microcode package. ie. amd-ucode or intel-ucode

echo "Please enter your preferred hostname or press enter to accept the default (${DEFAULT_HOSTNAME}):"

read HOSTNAME
if [ -z "${HOSTNAME}" ]
then
	HOSTNAME=${DEFAULT_HOSTNAME}
fi

echo "Please enter your preferred locale or press enter to accept the default (${DEFAULT_LOCALE}):"

read LOCALE
if [ -z "${LOCALE}" ]
then
	LOCALE=${DEFAULT_LOCALE}
fi

echo "Please enter your preferred time zone from the options below:"
echo "or press enter to accept the default (${DEFAULT_ZONE}):"
ls /usr/share/zoneinfo/

read ZONE
if [ -z "${ZONE}" ]
then
	ZONE=${DEFAULT_ZONE}
fi

echo "Please enter your preferred city from the options below:"
if [ "${ZONE}" == "${DEFAULT_ZONE}" ];
then
	echo "or press enter to accept the default (${DEFAULT_CITY}):"
fi
ls /usr/share/zoneinfo/

read CITY
if [ -z "${CITY}" -a "${ZONE}" == "${DEFAULT_ZONE}" ];
then
	CITY=${DEFAULT_CITY}
fi

while [ ! -f "/usr/share/zoneinfo/${ZONE}/${CITY}" ];
do
	echo "Invalid selection. Please try again:"
	read CITY
done

echo "Please select which cpu your machine is using:"
while [ -z "${CPU}" ];
do
    select cpu in amd intel; do
        case $cpu in
            amd)
                CPU=amd
                ;;
            intel)
                CPU=intel
                ;;
            *)
                echo "Invalid option. Please try again"
                ;;
        esac
    done
done

ln -sf /usr/share/zoneinfo/${ZONE}/${CITY} /etc/localtime
hwclock --systohc
sed -i "s/^#${LOCALE}/${LOCALE}/g" /etc/locale.gen
locale-gen
echo "LANG=${LOCALE}.UTF-8" > /etc/locale.conf
echo "${HOSTNAME}" > /etc/hostname
echo -e "127.0.0.1 \tlocalhost\n::1 \t\tlocalhost\n127.0.1.1 \t${HOSTNAME}.localdomain ${HOSTNAME}" >> /etc/hosts

passwd

pacman -S --noconfirm ${CPU}-ucode bash-completion vim networkmanager man-db man-pages git
bootctl install

echo -e "default \tarch.conf\ntimeout \t2\nconsole-mode \tmax" > /boot/loader/loader.conf

PARTUUID=$(blkid | grep "^/dev/${DEVICE}3" | tr ' ' '\n' | tail -n1)

echo -e "title \tArch Linux\nlinux \t/vmlinuz-linux\ninitrd \t/${CPU}-ucode.img\ninitrd \tinitramfs-linux.img\noptions root=${PARTUUID} rw" > /boot/loader/entries/arch.conf

echo -e "\n\nNow run 'exit' and then run 'reboot' to enter your new arch linux installation and run install_part3.sh!\n\n"
