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

sed -i "s/^USER=''/USER=${USER}/g" /install_part4.sh

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

sed -i "s/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/g" /etc/sudoers

useradd -m -G wheel -s /bin/${SHELL} ${USER}
passwd ${USER}

PS3="Enter 1 or 2) "
echo "Please select if you are connected to the internet via ethernet or wifi:"
while [ -z "${INTERNET_CONNECTION_TYPE}" ];
do
    select connection in ethernet wifi; do
        case $connection in
            ethernet)
                INTERNET_CONNECTION_TYPE="ethernet"
                systemctl enable dhcpcd.service && systemctl start dhcpcd.service
                echo "Starting dhcpcd service..." && sleep 2 # give dhcpcd service time to setup
                break
                ;;
            wifi)
                INTERNET_CONNECTION_TYPE="wifi"
                systemctl enable NetworkManager.service && systemctl start NetworkManager.service
                echo -e "\n\nPlease use nmcli to connect to your network before continuing!"
                break
                ;;
            *)
                echo "Invalid option. Please try again"
                ;;
        esac
    done
done

echo -e "\n\nNow exit from root, login to your newly created user, and run 'bash /install_part4.sh'\n\n"
