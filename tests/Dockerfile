# Image de test : Ubuntu + bureau Xubuntu (xubuntu-desktop-minimal), aussi
# proche que possible d'une installation Xubuntu neuve.
# Limites connues : pas de systemd, pas de snap, pas de noyau propre (modules, DKMS). Les services
# (docker, jellyfin…) sont installés mais pas démarrés.
# latest = dernière LTS d'Ubuntu (donc de Xubuntu)
ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

# Le paquet firefox d'Ubuntu n'est qu'un installeur de snap, qui échoue sans
# snapd fonctionnel : on l'exclut de l'image de test.
RUN printf 'Package: firefox\nPin: release a=*\nPin-Priority: -10\n' > /etc/apt/preferences.d/no-firefox-in-test \
 && apt-get update \
 && apt-get install -y sudo xubuntu-desktop-minimal \
 && rm -rf /var/lib/apt/lists/*

# Utilisateur "normal", comme après l'installeur Xubuntu.
RUN useradd -m -s /bin/bash -G sudo xubuntu \
 && echo 'xubuntu:xubuntu' | chpasswd

CMD ["sleep", "infinity"]
