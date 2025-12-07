#!/usr/bin/env bash
set -euo pipefail

echo "[BOOTSTRAP] Starting workstation bootstrap..."

# -- Installer git + ansible (minimum vital) --
echo "[BOOTSTRAP] Installing git & ansible..."
sudo apt update
sudo apt install -y git ansible

# -- Cloner le repo workstation s'il n'existe pas déjà --
if [ ! -d "$HOME/workstation" ]; then
    echo "[BOOTSTRAP] Cloning workstation repo..."
    git clone https://github.com/TONCOMPTE/workstation.git "$HOME/workstation"
    cd "$HOME/workstation"
else
    echo "[BOOTSTRAP] Repo already exists, pulling latest..."
    (cd "$HOME/workstation" && git pull --ff-only)
fi

# -- Lancer l'installation Ansible --
echo "[BOOTSTRAP] Running Ansible playbook..."
ansible-playbook -i "localhost," -c local playbook.yml -e "omz_user=$USER"

echo "[BOOTSTRAP] Done! Enjoy your freshly cloned workstation 😎"
