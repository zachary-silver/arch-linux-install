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

sudo pacman -S --noconfirm discord evince gvfs gimp libreoffice htop neofetch openssh firefox yarn npm imagemagick scrot udiskie pulsemixer

sudo systemctl enable lightdm.service

cp -r .icons $HOME/

sudo mkdir /etc/lightdm
sudo mkdir /media
sudo mkdir /usr/share/xsessions
mkdir $HOME/pictures
mkdir $HOME/programs

sudo ln -s /run/media/$USER /media/

sudo cp ./etc/lightdm/* /etc/lightdm/
sudo cp ./usr/share/pixmaps/* /usr/share/pixmaps/
sudo cp ./usr/share/xsessions/* /usr/share/xsessions/
sudo cp ./pictures/desktop_bg.jpg $HOME/pictures/

################## dotfiles ######################################
cd $HOME/
rm .bashrc
sudo pacman -S --noconfirm stow
git clone https://github.com/zachary-silver/dotfiles.git .dotfiles
cd .dotfiles && rm README.md && stow -vSt ~ *
cd $srcdir/
####################################################################

################## neovim Setup ##################################
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sudo pacman -S --noconfirm neovim clang rustup rust-analyzer
sudo npm install -g typescript-language-server pyright vscode-langservers-extracted
rustup update && rustup component add rls rust-analysis rust-src

nvim +PlugInstall +qall
##################################################################

################## projects ######################################
cd $HOME/
git clone https://github.com/zachary-silver/projects.git
cd $srcdir/
####################################################################

################## silver-dwm ######################################
cd $HOME/projects/
git clone https://github.com/zachary-silver/silver-dwm.git && cd silver-dwm/
make && sudo make install && make clean
cd $srcdir/
####################################################################

################## silver-st #######################################
cd $HOME/projects/
git clone https://github.com/zachary-silver/silver-st.git && cd silver-st/
make && sudo make install && make clean
cd $srcdir/
####################################################################

################## silver-dmenu ####################################
cd $HOME/projects/
git clone https://github.com/zachary-silver/silver-dmenu.git && cd silver-dmenu/
make && sudo make install && make clean
cd $srcdir/
####################################################################

################## silver-surf ####################################
cd $HOME/projects/
git clone https://github.com/zachary-silver/silver-surf.git && cd silver-surf/
make && sudo make install && make clean
cd $srcdir/
####################################################################

################## spotify-tui #####################################
cd $HOME/programs/
sudo pacman -S --noconfirm spotifyd
git clone https://aur.archlinux.org/spotify-tui.git && cd spotify-tui/
rustup install stable && makepkg -sri
cd $srcdir/
####################################################################

################## Custom Scripts ##################################
git clone https://github.com/zachary-silver/scripts.git && mv scripts/ $HOME/
####################################################################

################## dwmstatus #######################################
cd $HOME/projects/
git clone https://github.com/zachary-silver/dwmstatus.git
cd dwmstatus/rust && cargo build --release && mv target/release/dwmstatus $HOME/scripts/
cd $srcdir/
####################################################################

################## Cursor theme ####################################
if ! pacman -Qs xcursor-openzone > /dev/null ; then
	cd $HOME/programs/
	git clone https://aur.archlinux.org/icon-slicer.git && cd icon-slicer/
	makepkg -sri --noconfirm
	cd $HOME/programs/
	git clone https://aur.archlinux.org/xcursor-openzone.git && cd xcursor-openzone/
	makepkg -sri --noconfirm
	cd $srcdir/
fi
####################################################################

################## Lock screen program #############################
if ! pacman -Qs i3lock-color > /dev/null ; then
	cd $HOME/programs/
	git clone https://aur.archlinux.org/i3lock-color.git && cd i3lock-color/
	makepkg -sri --noconfirm
	cd $srcdir/
fi
####################################################################

################## Command line visualizer #########################
if ! pacman -Qs cli-visualizer > /dev/null ; then
	sudo pacman -S --noconfirm ncurses fftw cmake
	cd $HOME/programs/
	git clone https://github.com/dpayne/cli-visualizer.git && cd cli-visualizer/
	./install.sh
	cp $srcdir/.config/vis/config $HOME/.config/vis/config
	cd $srcdir/
fi
####################################################################

################## Hermit font by pcaro90 ##########################
cd $HOME/programs/
git clone https://github.com/pcaro90/hermit.git && cd hermit/packages/
gzip -d otf-hermit-2.0.tar.gz && tar xf otf-hermit-2.0.tar
sudo mkdir /usr/share/fonts/OTF
sudo cp *.otf /usr/share/fonts/OTF/
cd $srcdir/
####################################################################

cd $srcdir/ && cat ./etc/finished.txt
