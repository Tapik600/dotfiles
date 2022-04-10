#!/usr/bin/env bash

Color_off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White

# version
Version='2.0.0-debian11'
#System name
System="$(uname -s)"

need_cmd () {
    if ! hash "$1" &>/dev/null; then
        error "Need '$1' (command not found)"
        exit 1
    fi
}

msg() {
    printf '%b\n' "$1" >&2
}

success() {
    msg "${Green}[✔]${Color_off} ${1}${2}"
}

info() {
    msg "${Blue}[➭]${Color_off} ${1}${2}"
}

error() {
    msg "${Red}[✘]${Color_off} ${1}${2}"
    exit 1
}

warn () {
    msg "${Yellow}[⚠]${Color_off} ${1}${2}"
}

echo_with_color () {
    printf '%b\n' "$1$2$Color_off" >&2
}

fetch_repo () {
    sudo apt install -y stow git
    if [[ -d "$HOME/dotfiles" ]]; then
        info "Trying to update dotfiles"
        cd "$HOME/dotfiles"
        git pull
        cd - > /dev/null 2>&1
        success "Successfully update dotfiles"
    else
        info "Trying to clone dotfiles"
        git clone https://github.com/Tapik600/dotfiles.git "$HOME/dotfiles"
        if [ $? -eq 0 ]; then
            success "Successfully clone dotfiles"
        else
            error "Failed to clone dotfiles"
            exit 0
        fi
    fi
    cd $HOME/dotfiles
    rm -f $HOME/.bashrc
    stow *
    chmod +x $HOME/.config/polybar/launch.sh
}

install_i3Gaps () {
    info "Installing Xorg"
    sudo apt install --no-install-recommends -y xserver-xorg xinit x11-xserver-utils

    info "Installing Dependencies"
    sudo apt install -y cmake meson dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev libxcb-shape0 libxcb-shape0-dev
    
    info "Installing i3-gaps"
    git clone https://github.com/Airblader/i3.git --depth 1 /tmp/i3
    cd /tmp/i3 && mkdir build && cd build
    meson ..
    ninja
    sudo ninja install

    success "Installed i3-gaps"
}

install_GruvBoxGTKTheme () {
    THEMES_FOLDER=$HOME/.themes
    ICONS_FOLDER=$HOME/.icons

    mkdir $THEMES_FOLDER $ICONS_FOLDER
    git clone https://github.com/sainnhe/gruvbox-material-gtk.git --depth 1 /tmp/gruvbox-material-gtk

    if [ ! -d "$THEMES_FOLDER/gruvbox-material-gtk" ]; then
        cp -r /tmp/gruvbox-material-gtk/themes/* $THEMES_FOLDER
        cp -r /tmp/gruvbox-material-gtk/icons/* $ICONS_FOLDER
    fi
}

install_software () {
    sudo apt install -y \
        vim \
        polybar \
        rxvt-unicode \
        rofi \
        feh \
        htop \
        ranger \
        chromium-browser \
        rpi-chromium-mods \
        lxappearance \
        udisks2

    curl -sLf https://spacevim.org/install.sh | bash
}

install_vscode () {
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
}

main () {
    fetch_repo
    install_i3Gaps
    install_GruvBoxGTKTheme
    install_software
    install_vscode
}

main $@
