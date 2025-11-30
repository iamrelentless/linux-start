#!/bin/bash
echo "Requires attended setup"

# fedora secure boot starter
# https://rpmfusion.org/Howto/Secure%20Boot
secure_boot_nvidia(){
    sudo dnf install -y kmodtool akmods mokutil openssl
    sudo kmodgenca -a
    sudo mokutil --import /etc/pki/akmods/certs/public_key.der
    systemctl reboot
}

# reimport BIOS/UEFI
# sudo mokutil --import /etc/pki/akmods/certs/public_key.der 


fed_virt_manager(){
    sudo dnf install @virtualization
    sudo systemctl start libvirtd
    sudo systemctl enable libvirtd
    sudo usermod -aG libvirt $USER
    sudo usermod -aG kvm $USER
}