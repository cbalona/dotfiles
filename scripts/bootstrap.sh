#!/bin/bash
set -e # Exit on error

echo ">>> Starting System Bootstrap..."

if ! sudo -n true 2>/dev/null; then   
    sudo -v
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$USER" > /dev/null
    sudo chmod 0440 "/etc/sudoers.d/$USER"
fi

# Install Ansible
if ! command -v ansible-playbook &> /dev/null; then
    echo ">>> Installing Ansible..."
    sudo apt update
    sudo apt install -y ansible build-essential curl unzip
fi

# Run
echo ">>> Applying Configuration..."
cd ~/dotfiles/ansible
sudo -v 
ansible-playbook setup.yml