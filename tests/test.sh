#!/usr/bin/env bash
# Lance le playbook dans un conteneur Xubuntu amd64, deux fois de suite pour
# vérifier qu'une relance ne casse rien.
# Usage : tests/test.sh [tag_ubuntu]   (défaut : latest = dernière LTS)
# Voir les limites en tête de tests/Dockerfile.
#
# ⚠️ Ne marche PAS sur un Mac Apple Silicon pour Ubuntu 26.x : l'émulation
# amd64 (Rosetta) ne gère pas un appel système utilisé par le `tar` d'Ubuntu
# 26.x ("Function not implemented"). À lancer sur une machine Linux amd64
# (ou GitHub Actions). seccomp=unconfined : le filtre par défaut de Docker
# bloque ce même appel système.
set -euo pipefail

VERSION="${1:-latest}"
IMAGE="workspace-test:xubuntu-$VERSION"
NAME="workspace-test-$VERSION"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

docker build --platform linux/amd64 --build-arg UBUNTU_VERSION="$VERSION" -t "$IMAGE" "$REPO_DIR/tests"

docker rm -f "$NAME" >/dev/null 2>&1 || true
docker run -d --name "$NAME" --platform linux/amd64 \
    --security-opt seccomp=unconfined -v "$REPO_DIR:/src:ro" "$IMAGE" >/dev/null
trap 'docker rm -f "$NAME" >/dev/null 2>&1 || true' EXIT

run() { docker exec -u xubuntu -w /home/xubuntu "$NAME" bash -c "$1"; }

run "echo xubuntu | sudo -S -p '' apt-get update -qq && sudo apt-get install -y -qq git ansible >/dev/null"
run "cp -r /src ~/workspace"

for i in 1 2; do
    echo "===== Exécution $i ====="
    run "cd ~/workspace && ANSIBLE_FORCE_COLOR=0 ansible-playbook -i localhost, -c local playbook.yml \
        -e omz_user=xubuntu -e ansible_become_password=xubuntu"
done
