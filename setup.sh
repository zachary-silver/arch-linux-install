#!/bin/bash

srcdir=$(pwd)

sudo pacman -Syu

PS3="Enter 1 or 2) "
echo "Are you on a laptop?"
select option in "Yes" "No"; do
    case $option in
        Yes)
	        sudo pacman -S --noconfirm acpi acpilight
            break
            ;;
        No)
            break
            ;;
    esac
done

echo "Would you like to enable Bluetooth?"
select option in "Yes" "No"; do
    case $option in
        Yes)
            sudo pacman -S --noconfirm bluez bluez-utils && sudo systemctl start bluetooth.service && sudo systemctl enable bluetooth.service
            break
            ;;
        No)
            break
            ;;
    esac
done

sudo pacman -S --noconfirm xorg-server xorg-xinit xterm xorg-xrandr xorg-xsetroot xorg-xprop playerctl picom ttf-font-awesome alsa-utils pulseaudio pulseaudio-alsa feh lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings ranger w3m dunst xbindkeys arc-gtk-theme

sudo pacman -S --noconfirm spotifyd discord evince gvfs gimp libreoffice htop neofetch openssh firefox vim yarn npm imagemagick rustup scrot udiskie pulsemixer

sudo systemctl enable lightdm.service

cp -r .config/ $HOME/
cp .xprofile $HOME/
cp .xbindkeysrc $HOME/
cp -r .vim/ $HOME/
cp .vimrc $HOME/
cp .bashrc $HOME/
cp -r .icons $HOME/

sudo mkdir /etc/lightdm
sudo mkdir /media
sudo mkdir /usr/share/xsessions
mkdir $HOME/Pictures
mkdir $HOME/Programs
mkdir $HOME/.vim
mkdir $HOME/.vim/.swap
mkdir $HOME/.vim/.backup
mkdir $HOME/.vim/.undo

sudo ln -s /run/media/$USER /media/

sudo cp ./etc/lightdm/* /etc/lightdm/
sudo cp ./usr/share/pixmaps/* /usr/share/pixmaps/
sudo cp ./usr/share/xsessions/* /usr/share/xsessions/
sudo cp ./Pictures/desktop_bg.jpg $HOME/Pictures/

################## silver-dwm ######################################
cd $HOME/Programs/
git clone https://github.com/zachary-silver/silver-dwm.git && cd silver-dwm/
make && sudo make install && make clean
cd $srcdir/
####################################################################

################## silver-st #######################################
cd $HOME/Programs/
git clone https://github.com/zachary-silver/silver-st.git && cd silver-st/
make && sudo make install && make clean
cd $srcdir/
####################################################################

################## silver-dmenu ####################################
cd silver-dmenu/
makepkg -sri --noconfirm
cd $srcdir/
####################################################################

################## spotify-tui #####################################
cd $HOME/Programs/
git clone https://aur.archlinux.org/spotify-tui.git && cd spotify-tui/
rustup install stable && rustup default stable && makepkg -sri
cd $srcdir/
####################################################################

################## Custom Scripts ##################################
git clone https://github.com/zachary-silver/scripts.git
mv scripts/ $HOME/.scripts
####################################################################

################## dwmstatus #######################################
cd $HOME/Programs/
git clone https://github.com/zachary-silver/dwmstatus.git
cd dwmstatus/ && make && make clean && mv dwmstatus $HOME/.scripts/ && cd $srcdir/
####################################################################

################## Cursor theme ####################################
if ! pacman -Qs xcursor-openzone > /dev/null ; then
	cd $HOME/Programs/
	git clone https://aur.archlinux.org/icon-slicer.git && cd icon-slicer/
	makepkg -sri --noconfirm
	cd $HOME/Programs/
	git clone https://aur.archlinux.org/xcursor-openzone.git && cd xcursor-openzone/
	makepkg -sri --noconfirm
	cd $srcdir/
fi
####################################################################

################## Lock screen program #############################
if ! pacman -Qs i3lock-color > /dev/null ; then
	cd $HOME/Programs/
	git clone https://aur.archlinux.org/i3lock-color.git && cd i3lock-color/
	makepkg -sri --noconfirm
	cd $srcdir/
fi
####################################################################

################## Command line visualizer #########################
if ! pacman -Qs cli-visualizer > /dev/null ; then
	sudo pacman -S --noconfirm ncurses fftw cmake
	cd $HOME/Programs/
	git clone https://github.com/dpayne/cli-visualizer.git && cd cli-visualizer/
	./install.sh
	cp $srcdir/.config/vis/config $HOME/.config/vis/config
	cd $srcdir/
fi
####################################################################

################## Vim plugin manager ##############################
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
fi
####################################################################

################## Vim code completion plugin ######################
if [ -d ~/.vim/bundle/YouCompleteMe ]; then
	cd $HOME/.vim/bundle/YouCompleteMe/ && python3 install.py
	cd $srcdir/
fi
####################################################################

################## Vim code formatter plugin #######################
if [ -d ~/.vim/bundle/vim-prettier ]; then
	cd $HOME/.vim/bundle/vim-prettier/ && yarn install
	cd $srcdir/
fi
####################################################################

################## Hermit font by pcaro90 ##########################
cd $HOME/Programs/
git clone https://github.com/pcaro90/hermit.git && cd hermit/packages/
gzip -d otf-hermit-2.0.tar.gz && tar xf otf-hermit-2.0.tar
sudo mkdir /usr/share/fonts/OTF
sudo cp *.otf /usr/share/fonts/OTF/
cd $srcdir/
####################################################################

cd $srcdir/ && cat ./etc/finished.txt
