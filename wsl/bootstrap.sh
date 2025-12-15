#!/bin/bash
set -e # Exit on error

echo ">>> Starting System Bootstrap..."

if ! sudo -n true 2>/dev/null; then   
    sudo -v
    echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$USER" > /dev/null
    sudo chmod 0440 "/etc/sudoers.d/$USER"
fi

if ! command -v task &> /dev/null; then
    echo ">>> Installing Task..."
    curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | sudo -E bash
    sudo apt install task
fi

# 3. Handover
echo ">>> Handing off to Task..."
cd ~/dotfiles/wsl
task default