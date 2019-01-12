#!/bin/bash

srcdir=$(pwd)

sudo pacman -Syu

sudo pacman -S --noconfirm xorg-server xorg-xinit xterm xorg-xrandr xorg-xsetroot xorg-xprop compton ttf-dejavu ttf-font-awesome arc-gtk-theme alsa-utils pulseaudio-alsa pulsemixer openjdk8-src imagemagick xcb-util-xrm scrot feh lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lxappearance ranger w3m jq udiskie dunst cmake

sudo pacman -S --noconfirm arandr evince gimp libreoffice htop cmatrix neofetch openssh chromium virtualbox virtualbox-guest-iso

sudo systemctl enable lightdm.service

cd silver-dmenu/ && makepkg -sri --noconfirm && cd $srcdir/
cd silver-surf/ && makepkg -sri --noconfirm && cd $srcdir/
cd silver-st/ && makepkg -sri --noconfirm && cd $srcdir/
cd silver-dwm/ && makepkg -sri --noconfirm && cd $srcdir/

cp -r .config .xprofile .scripts .vim .vimrc .bashrc $HOME/

if [ ! -d "/etc/lightdm" ]; then
	sudo mkdir /etc/lightdm
fi

if [ ! -d "$HOME/Pictures" ]; then
	mkdir $HOME/Pictures
fi

if [ ! -d "$HOME/.bin" ]; then
	mkdir $HOME/.bin
fi

if [ ! -d "/media" ]; then
	sudo mkdir /media
fi

sudo ln -s /run/media/$USER /media/

sudo cp ./etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/
sudo cp ./usr/share/pixmaps/* /usr/share/pixmaps/
sudo cp ./Pictures/desktop_bg.jpg $HOME/Pictures

################## Required for discord ############################
cd $HOME/.bin/
git clone https://aur.archlinux.org/libc++.git && cd libc++/
makepkg -sri --skippgpcheck --noconfirm
####################################################################

################## Preferred comms program #########################
cd $HOME/.bin/
git clone https://aur.archlinux.org/discord.git && cd discord/
makepkg -sri --noconfirm
####################################################################

################## Preferred cursor theme ##########################
cd $HOME/.bin/
git clone https://aur.archlinux.org/xcursor-openzone.git && cd xcursor-openzone/
makepkg -sri --noconfirm
####################################################################

################## Google Play Music Desktop Player ################
cd $HOME/.bin/
git clone https://aur.archlinux.org/gpmdp.git && cd gpmdp/
makepkg -sri --noconfirm
####################################################################

################## Preferred lock screen program ###################
cd $HOME/.bin/
git clone https://aur.archlinux.org/i3lock-color.git && cd i3lock-color/
makepkg -sri --noconfirm
####################################################################

################## Preferred command line visualizer ###############
cd $HOME/.bin/
git clone https://aur.archlinux.org/cli-visualizer.git && cd cli-visualizer/
makepkg -sri --noconfirm
####################################################################

################## Preferred vim plugin manager ####################
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
####################################################################

################## Vim code completion plugin ######################
cd $HOME/.vim/bundle/YouCompleteMe/ && python3 install.py --clang-completer --java-completer
####################################################################
