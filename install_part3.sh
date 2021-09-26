#!/bin/bash

DEFAULT_SHELL=bash
INTERNET_CONNECTION_TYPE=''

echo "Please enter the name of the user account you'd like to create:"
read USER
while [ -z "$USER" ];
do
    echo "Invalid user name. Please enter a new user:"
    read USER
done

echo "Please enter a shell for the user or press enter to accept the default (${DEFAULT_SHELL}):"
read SHELL
if [ -z "$SHELL" ];
then
    SHELL=$DEFAULT_SHELL
else
    while [ -f "/bin/$SHELL" ];
    do
        echo "Invalid shell. Please enter a new shell:"
        read SHELL
    done
fi

PS3="Enter 1 or 2) "
echo "Please select if you are connected to the internet via cable or wifi:"
while [ -z "${INTERNET_CONNECTION_TYPE}" ];
do
    select connection in cable wifi; do
        case $connection in
            cable)
                INTERNET_CONNECTION_TYPE=cable
                systemctl start dhcpcd.service && systemctl enable dhcpcd.service
                break
                ;;
            wifi)
                INTERNET_CONNECTION_TYPE=wifi
                break
                ;;
            *)
                echo "Invalid option. Please try again"
                ;;
        esac
    done
done

sed -i "s/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g" /etc/sudoers

useradd -m -G wheel -s /bin/${SHELL} ${USER}
passwd ${USER}

echo -e "\n\nNow exit from root and login to your newly created user!\n\n"
