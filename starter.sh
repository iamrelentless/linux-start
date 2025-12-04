#!/bin/bash

secure_boot_nvidia(){
    sudo dnf install -y kmodtool akmods mokutil openssl
    sudo kmodgenca -a
    sudo mokutil --import /etc/pki/akmods/certs/public_key.der
#    systemctl reboot
}


install_omzsh() {
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Oh My Zsh installation complete."
}

install_node_nvm() {
    echo "Installing NVM (Node Version Manager)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    echo "NVM installation complete."
}

install_sdkman() {
    echo "Installing SDKMAN (Java, Kotlin, Spark manager)..."
    curl -s "https://get.sdkman.io" | bash
    echo "SDKMAN installation complete."
}

enable_ubuntu_flatpak() {
    echo "Enabling Flatpak support on Ubuntu..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "Flatpak support enabled on Ubuntu."
}

enable_fedora_flatpak() {
    echo "Enabling Flatpak support on Fedora..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    echo "Flatpak support enabled on Fedora."
}

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
        libreoffice

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
        flatpak\
        gnome-software-plugin-flatpak

    # call flatpak setup for fedora
    enable_fedora_flatpak
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

#install secureboot packages if on fedora
if [ "$PACKAGE_MANAGER" == "yum" ] || [ "$PACKAGE_MANAGER" == "dnf" ]; then
    read -p "Do you want to setup Secure Boot for NVIDIA drivers (y/n): "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        secure_boot_nvidia
    fi
fi

# install ohmyzsh
read -p "Do you want to install Oh My Zsh? (y/n): "
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_omzsh
fi

# install nvm and sdkman
read -p "Do you want to install nvm (Node Version Manager) (y/n): "
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_node_nvm
fi

read -p "Do you want to install SDKMAN (Java, Kotlin, Spark manager) (y/n): "
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_sdkman
fi


echo "Setup complete. Please restart your terminal."