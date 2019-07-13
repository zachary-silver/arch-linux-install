#!/bin/bash

srcdir=$(pwd)
laptop="FALSE"

echo "Are you on a laptop?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) laptop="TRUE"; break;;
        No ) break;;
    esac
done

sudo pacman -Syu

if [ laptop = "TRUE" ]; then
	sudo pacman -S --noconfirm acpi acpilight wicd-gtk
fi

sudo pacman -S --noconfirm xorg-server xorg-xinit xterm xorg-xrandr xorg-xsetroot xorg-xprop compton ttf-font-awesome arc-gtk-theme alsa-utils pulseaudio-alsa pulsemixer openjdk8-src imagemagick xcb-util-xrm scrot feh lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lxappearance ranger w3m udiskie dunst cmake xbindkeys

sudo pacman -S --noconfirm arandr evince gvfs gimp libreoffice htop cmatrix neofetch openssh chromium virtualbox virtualbox-guest-iso vim yarn

sudo systemctl enable lightdm.service

if ! pacman -Qs silver-dmenu > /dev/null ; then
	cd silver-dmenu/ && makepkg -sri --noconfirm && cd $srcdir/
fi

if ! pacman -Qs silver-surf > /dev/null ; then
	cd silver-surf/ && makepkg -sri --noconfirm && cd $srcdir/
fi

if ! pacman -Qs silver-st > /dev/null ; then
	cd silver-st/ && makepkg -sri --noconfirm && cd $srcdir/
fi

if ! pacman -Qs silver-dwm > /dev/null ; then
	cd silver-dwm/ && makepkg -sri --noconfirm && cd $srcdir/
fi

if [ ! -d $HOME/.config ]; then
	cp -r .config/ $HOME/
fi

if [ ! -f $HOME/.xprofile ]; then
	cp .xprofile $HOME/
fi

if [ ! -f $HOME/.xbindkeysrc ]; then
	cp .xbindkeys $HOME/
fi

if [ ! -d $HOME/.scripts ]; then
	cp -r .scripts/ $HOME/
	cd $HOME/.scripts/dwm_status/ && make && make clean
fi

if [ ! -d $HOME/.vim ]; then
	cp -r .vim/ $HOME/
fi

if [ ! -f $HOME/.vimrc ]; then
	cp .vimrc $HOME/
fi

if [ ! -f $HOME/.bashrc ]; then
	cp .bashrc $HOME/
fi

sudo mkdir /etc/lightdm
sudo mkdir /media
mkdir $HOME/Pictures
mkdir $HOME/.bin
mkdir $HOME/.vim
mkdir $HOME/.vim/.swap
mkdir $HOME/.vim/.backup
mkdir $HOME/.vim/.undo

sudo ln -s /run/media/$USER /media/

if [ ! -f /etc/lightdm/lightdm-gtk-greeter.conf ]; then
	sudo cp ./etc/lightdm/lightdm-gtk-greeter.conf /etc/lightdm/
fi

if [[ ! -f /usr/share/pixmaps/greeter_bg.jpg ||
      ! -f /usr/share/pixmaps/greeter_icon.png ]]; then
	sudo cp ./usr/share/pixmaps/* /usr/share/pixmaps/
fi

if [ ! -f $HOME/Pictures/desktop_bg.jpg ]; then
	sudo cp ./Pictures/desktop_bg.jpg $HOME/Pictures
fi

################## Required for Discord ############################
if ! pacman -Qs libc++ > /dev/null ; then
	cd $HOME/.bin/
	git clone https://aur.archlinux.org/libc++.git && cd libc++/
	makepkg -sri --skippgpcheck --noconfirm
fi
####################################################################

################## Discord #########################################
if ! pacman -Qs discord > /dev/null ; then
	cd $HOME/.bin/
	git clone https://aur.archlinux.org/discord.git && cd discord/
	makepkg -sri --noconfirm
fi
####################################################################

################## Cursor theme ####################################
if ! pacman -Qs xcursor-openzone > /dev/null ; then
	cd $HOME/.bin/
	git clone https://aur.archlinux.org/xcursor-openzone.git && cd xcursor-openzone/
	makepkg -sri --noconfirm
fi
####################################################################

################## Google Play Music Desktop Player ################
if ! pacman -Qs gpmdp > /dev/null ; then
	cd $HOME/.bin/
	git clone https://aur.archlinux.org/gpmdp.git && cd gpmdp/
	makepkg -sri --noconfirm
fi
####################################################################

################## Lock screen program #############################
if ! pacman -Qs i3lock-color > /dev/null ; then
	cd $HOME/.bin/
	git clone https://aur.archlinux.org/i3lock-color.git && cd i3lock-color/
	makepkg -sri --noconfirm
fi
####################################################################

################## Command line visualizer #########################
if ! pacman -Qs cli-visualizer > /dev/null ; then
	cd $HOME/.bin/
	git clone https://aur.archlinux.org/cli-visualizer.git && cd cli-visualizer/
	makepkg -sri --noconfirm
fi
####################################################################

################## Vim plugin manager ####################
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
fi
####################################################################

################## Vim code completion plugin ######################
if [ -d ~/.vim/bundle/YouCompleteMe ]; then
	cd $HOME/.vim/bundle/YouCompleteMe/ && python3 install.py --clang-completer --java-completer
fi
####################################################################

################## Vim code formatter plugin ######################
if [ -d ~/.vim/bundle/vim-prettier ]; then
	cd $HOME/.vim/bundle/vim-prettier/ && yarn install
fi
####################################################################

################## font (Hermit-Regular) #################
if ! pacman -Qs otf-hermit > /dev/null ; then
	cd $HOME/.bin/
	git clone https://aur.archlinux.org/otf-hermit.git && cd otf-hermit/
	makepkg -sri --noconfirm
fi
####################################################################

if [ laptop = "TRUE" ]; then
	sudo systemctl stop NetworkManager.service && sudo systemctl disable NetworkManager.service
	sudo pacman -Rs networkmanager
	sudo systemctl enable wicd.service
fi

cd $srcdir/ && cat ./etc/finished.txt
