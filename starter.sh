#!/bin/bash

ubuntu_setup() {
    echo "Updating package lists..."
    sudo apt update ; sudo apt full-upgrade -y
    sudo apt install -y curl\
        git\
        wget\
        clang\
        cmake\
        automake\
        llvm\
        yasm\
        nasm\
        valgrind\
        gdb\
        neovim\
        build-essential\
        software-properties-common\
        apt-transport-https\
        net-tools\
        nmap\
        htop\
        zip\
        unzip\
        p7zip-full\
        wireguard\
        zsh\
        zsh-antigen\
        zsh-syntax-highlighting\
        zsh-autosuggestions\
        pandoc\
        texlive-latex-extra\
        flatpak\

    echo "Ubuntu setup complete."
}

fedora_setup() {
    echo "Updating package lists..."
    sudo dnf upgrade --refresh -y
    # Enable RPM Fusion repositories
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf install -y curl\
        git\
        wget\
        clang\
        cmake\
        automake\
        llvm\
        yasm\
        nasm\
        valgrind\
        gdb\
        neovim\
        nmap\
        htop\
        zip\
        unzip\
        p7zip-plugins\
        wireguard-tools\
        zsh\
        zsh-autosuggestions\
        zsh-syntax-highlighting\
        ranger\
        pandoc\
        texlive-scheme-full\
        flatpak
    
    echo "Fedora setup complete."
}

PACKAGE_MANAGER=""
if command -v apt >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt"
elif command -v yum >/dev/null 2>&1; then
    PACKAGE_MANAGER="yum"
else
    echo "No supported package manager found (apt, yum, dnf). Exiting."
    exit 1
fi

# print the package manager found
echo "Package manager found: $PACKAGE_MANAGER"

# check package manager and call respective setup function
if [ "$PACKAGE_MANAGER" == "apt" ]; then
    ubuntu_setup
elif [ "$PACKAGE_MANAGER" == "yum" ] || [ "$PACKAGE_MANAGER" == "dnf" ]; then
    fedora_setup
fi

# service wide setup
# nvm for nodejs 
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# sdkman for java, kotlin, spark
curl -s "https://get.sdkman.io" | bash

#omz installer
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"