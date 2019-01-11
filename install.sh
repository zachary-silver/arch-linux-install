#!/bin/bash

srcdir=$(pwd)

sudo pacman -S --noconfirm xorg-server xorg-xinit xterm xorg-xrandr xorg-xsetroot xorg-xprop compton ttf-dejavu ttf-font-awesome arc-gtk-theme alsa-utils pulseaudio-alsa pulsemixer

sudo pacman -S --noconfirm arandr evince gimp scrot feh lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings udiskie libreoffice lxappearance ranger udiskie dunst w3m jq htop cmatrix neofetch openssh

cd silver-dmenu/ && makepkg -sri --noconfirm && cd $srcdir/
cd silver-surf/ && makepkg -sri --noconfirm && cd $srcdir/
cd silver-st/ && makepkg -sri --noconfirm && cd $srcdir/
cd silver-dwm/ && makepkg -sri --noconfirm && cd $srcdir/

cp -r .xprofile .scripts .vim .vimrc .bashrc $HOME/

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

if [ pacman -Qi udiskie > /dev/null ]; then
	sudo ln -s /run/media/zack /media/
fi

cp ./etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/
cp ./usr/share/pixmaps/* /usr/share/pixmaps/
cp ./Pictures/desktop_bg.jpg $HOME/Pictures

cd $HOME/.bin/
git clone https://aur.archlinux.org/libc++.git && cd libc++/
makepkg -sri --skippgpcheck --noconfirm

cd $HOME/.bin/
git clone https://aur.archlinux.org/discord.git && cd discord/
makepkg -sri --noconfirm

cd $HOME/.bin/
git clone https://aur.archlinux.org/xcursor-openzone.git && cd xcursor-openzone/
makepkg -sri --noconfirm

cd $HOME/.bin/
git clone https://aur.archlinux.org/gpmdp.git && cd gpmdp/
makepkg -sri --noconfirm

cd $HOME/.bin/
git clone https://aur.archlinux.org/i3lock-color.git && cd i3lock-color/
makepkg -sri --noconfirm

cd $HOME/.bin/
git clone https://aur.archlinux.org/cli-visualizer.git && cd cli-visualizer/
makepkg -sri --noconfirm

vim +PluginInstall +qall
cd $HOME/.vim/bundle/YouCompleteMe/ && python3 install.py --clang-completer --java-completer
