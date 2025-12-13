#!/bin/bash
set -e # Exit on error

echo ">>> Starting System Bootstrap..."

# 1. Install Ansible
if ! command -v ansible-playbook &> /dev/null; then
    echo ">>> Installing Ansible..."
    sudo apt update
    sudo apt install -y ansible build-essential curl unzip
fi

# 2. Install Bitwarden CLI
if ! command -v bw &> /dev/null; then
    echo ">>> Installing Bitwarden CLI..."
    curl -L "https://vault.bitwarden.com/download/?app=cli&platform=linux" -o bw.zip
    unzip bw.zip
    chmod +x bw
    sudo mv bw /usr/local/bin/
    rm bw.zip
fi

# 3. Run
echo ">>> Applying Configuration..."
cd ~/dotfiles/ansible
sudo -v 
ansible-playbook setup.yml