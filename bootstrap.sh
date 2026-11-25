#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/Slummp/workspace.git"
REPO_DIR="$HOME/workspace"

echo "[BOOTSTRAP] Starting workspace bootstrap..."

# -- Installer git + ansible (minimum vital) --
echo "[BOOTSTRAP] Installing git & ansible..."
sudo apt update
sudo apt install -y git ansible

# -- Cloner le repo s'il n'existe pas déjà, sinon le mettre à jour --
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "[BOOTSTRAP] Cloning workspace repo..."
    git clone "$REPO_URL" "$REPO_DIR"
else
    echo "[BOOTSTRAP] Repo already exists, pulling latest..."
    git -C "$REPO_DIR" pull --ff-only
fi

cd "$REPO_DIR"

# -- Lancer l'installation Ansible --
# --ask-become-pass : Ansible ne réutilise pas le cache sudo, il faut lui donner le mot de passe.
echo "[BOOTSTRAP] Running Ansible playbook..."
ansible-playbook -i "localhost," -c local playbook.yml \
    --ask-become-pass \
    -e "omz_user=$USER"

echo "[BOOTSTRAP] Done! Enjoy your freshly cloned workspace 😎"
