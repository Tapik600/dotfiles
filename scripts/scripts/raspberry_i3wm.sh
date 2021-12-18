#!/bin/bash

DWL_FOLDER=$HOME/git

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
PURPLE=$'\033[0;35m'
CYAN=$'\033[0;36m'
WHITE=$'\033[0;37m'
YELLOW=$'\033[0;33m'
BOLD=$'\033[1m'
OFF=$'\033[0m'

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

sudo apt update
sudo apt full-upgrade -y
sudo apt install -y git stow

mkdir -p $HOME/.config
rm -f $HOME/.bashrc

git clone https://github.com/Tapik600/dotfiles.git --depth 1 $HOME/dotfiles
cd $HOME/dotfiles
stow *

source $HOME/.bashrc
chmod +x $HOME/.config/polybar/launch.sh
chmod +x $HOME/.config/polybar/updates.sh

printf $CYAN$BOLD'\n== %s %.30s>\n\n'$OFF \
  "Installing windows manager" \
  "========================================================="
sudo apt install --no-install-recommends -y \
  xserver-xorg \
  xinit \
  x11-xserver-utils

sudo apt install -y \
  xcb \
  xcb-proto \
  libxcb1-dev \
  libxcb-keysyms1-dev \
  libxcb-icccm4-dev \
  libxcb-cursor-dev \
  libxcb-util0-dev \
  libxcb-randr0-dev \
  libxcb-xinerama0-dev \
  libxcb-xkb-dev \
  libxcb-xrm0 \
  libxcb-xrm-dev \
  libxcb-shape0 \
  libxcb-shape0-dev \
  libcairo2-dev \
  libxcb-ewmh-dev \
  libxcb-image0-dev \
  libxcb-composite0-dev \
  libxkbcommon-dev \
  libxkbcommon-x11-dev \
  libpango1.0-dev \
  libyajl-dev libev-dev \
  libjsoncpp-dev \
  libstartup-notification0-dev \
  build-essential \
  python-xcbgen \
  python3-sphinx \
  python3-packaging \
  dh-autoreconf \
  libiw-dev \
  pkg-config \
  meson \
  cmake \
  cmake-data

printf $YELLOW'\n%s %.30s\n\n'$OFF \
  "Installing i3-gaps" \
  ".........................................................."

git clone https://github.com/Airblader/i3.git --depth 1 $DWL_FOLDER/i3

cd $DWL_FOLDER/i3 && mkdir build && cd build
meson ..
ninja
sudo ninja install

printf $YELLOW'\n%s %.30s\n\n'$OFF \
  "Installing polybar" \
  ".........................................................."

git clone --recursive https://github.com/polybar/polybar $DWL_FOLDER/polybar

cd $DWL_FOLDER/polybar && mkdir build && cd build
cmake ..
make -j$(nproc)
# Optional. This will install the polybar executable in /usr/local/bin
sudo make install

printf $YELLOW'\n%s %.30s\n\n'$OFF \
  "Download GTK+ GruvBox Theme " \
  ".........................................................."

THEMES_FOLDER=$HOME/.themes
ICONS_FOLDER=$HOME/.icons

mkdir $THEMES_FOLDER $ICONS_FOLDER

if [ ! -d "$DWL_FOLDER/gruvbox-material-gtk" ]; then
  git clone https://github.com/sainnhe/gruvbox-material-gtk.git --depth 1 $DWL_FOLDER/gruvbox-material-gtk
fi

if [ ! -d "$THEMES_FOLDER/gruvbox-material-gtk" ]; then
  cp -r $DWL_FOLDER/gruvbox-material-gtk/themes/* $THEMES_FOLDER
  cp -r $DWL_FOLDER/gruvbox-material-gtk/icons/* $ICONS_FOLDER
fi

printf $CYAN$BOLD'\n== %s %.30s>\n\n'$OFF \
  "Installing C++ compilers" \
  "========================================================="

printf $YELLOW'\n%s %.30s\n\n'$OFF \
  "Installing GCC-10.1.0" \
  ".........................................................."

git clone https://bitbucket.org/sol_prog/raspberry-pi-gcc-binary.git --depth 1 $DWL_FOLDER/gcc
cd $DWL_FOLDER/gcc
tar -xjvf gcc-10.1.0-armhf-raspbian.tar.bz2
sudo mv gcc-10.1.0 /opt

sudo ln -s /usr/include/arm-linux-gnueabihf/sys /usr/include/sys
sudo ln -s /usr/include/arm-linux-gnueabihf/bits /usr/include/bits
sudo ln -s /usr/include/arm-linux-gnueabihf/gnu /usr/include/gnu
sudo ln -s /usr/include/arm-linux-gnueabihf/asm /usr/include/asm
sudo ln -s /usr/lib/arm-linux-gnueabihf/crti.o /usr/lib/crti.o
sudo ln -s /usr/lib/arm-linux-gnueabihf/crt1.o /usr/lib/crt1.o
sudo ln -s /usr/lib/arm-linux-gnueabihf/crtn.o /usr/lib/crtn.o

sudo cp /usr/include/arm-linux-gnueabihf/sys/* /usr/include/sys/

# printf $YELLOW'\n\n%s %.30s>\n\n'$OFF \
# "Installing CLANG-9.0.0" \
# ".........................................................."
# cd $DWL_FOLDER
# wget http://releases.llvm.org/9.0.0/clang+llvm-9.0.0-armv7a-linux-gnueabihf.tar.xz
# tar -xvf clang+llvm-9.0.0-armv7a-linux-gnueabihf.tar.xz
# rm clang+llvm-9.0.0-armv7a-linux-gnueabihf.tar.xz
# mv clang+llvm-9.0.0-armv7a-linux-gnueabihf clang_9.0.0
# sudo mv clang_9.0.0 /usr/local

git clone https://github.com/abhiTronix/TBB_Raspberry_pi.git --depth 1 $DWL_FOLDER/tbb
cd $DWL_FOLDER/tbb
sudo dpkg -i libtbb-dev_2018-U2_arm.deb
sudo ldconfig

# gcc-10.1 --version
# clang++ --version

printf $CYAN$BOLD'\n== %s %.30s>\n\n'$OFF \
  "Installing VSCode" \
  "========================================================="

sudo apt install -y code

code --install-extension pkief.material-icon-theme
code --install-extension gracefulpotato.gruvbox-ish
code --install-extension cschlosser.doxdocgen
code --install-extension jeff-hykin.better-cpp-syntax
code --install-extension twxs.cmake
code --install-extension ms-vscode.cpptools
code --install-extension jeff-hykin.better-cpp-syntax
code --install-extension ms-vscode.cmake-tools
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension chunsen.bracket-select
code --install-extension fabiospampinato.vscode-diff
code --install-extension eamodio.gitlens
code --install-extension gruntfuggly.todo-tree
code --install-extension tomoki1207.pdf


code --enable-proposed-api pkief.material-icon-theme
# code --enable-proposed-api gracefulpotato.gruvbox-ish

cd $HOME/dotfiles
stow -D setup_scripts
cd $HOME

printf $YELLOW'\n%s %.30s\n\n'$OFF \
  "Installing software" \
  ".........................................................."

sudo apt install -y \
  rxvt-unicode \
  rofi \
  feh \
  htop \
  ranger \
  chromium-browser \
  rpi-chromium-mods \
  lxappearance \
  udisks2
