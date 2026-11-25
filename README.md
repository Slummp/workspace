# workspace

Installation automatique de mon poste de travail sur une machine **Xubuntu fraîchement installée**.

## ⚠️ Cible : Xubuntu uniquement

Ce repo est fait pour **une seule cible** :

- **Xubuntu** (Ubuntu + bureau XFCE), **dernière version LTS** (support long terme), installation **neuve et vide** ;
- architecture **amd64** (PC x86_64 classique).

Il ne marchera **pas** tel quel ailleurs :

| Système | Pourquoi ça ne marche pas |
|---|---|
| Debian, Fedora, Arch… | Tout passe par `apt` et par des dépôts propres à Ubuntu (noms de paquets, PPA, codename de version). |
| Ubuntu (GNOME), Kubuntu, Mint… | Les réglages de bureau prévus sont ceux de **XFCE** ; certains paquets et réglages supposent Xubuntu. |
| Machine déjà utilisée | Le playbook supprime **tous les snaps** (Firefox snap compris) et écrase certaines configurations. |
| PC ARM (Snapdragon…) | Chrome, Spotify, Discord, Minecraft, Ankama… n'existent qu'en amd64. |
| macOS | Hors sujet. |

## Utilisation

Sur la machine Xubuntu neuve, dans un terminal :

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Slummp/workspace/main/bootstrap.sh)
```

Le script :

1. installe `git` et `ansible` ;
2. clone ce repo dans `~/workspace` (ou le met à jour s'il existe déjà) ;
3. lance `playbook.yml`, qui installe et configure tout le reste.

Le mot de passe sudo est demandé deux fois au début (pour `apt`, puis pour Ansible). Ensuite, plus rien à faire.
Il faut se déconnecter / reconnecter à la fin (shell zsh, groupe `docker`).

> Le repo doit être **public** sur GitHub : le clone se fait en HTTPS sans identifiants.

Relancer le script plus tard est sans danger : il met le repo à jour et ne refait que ce qui manque.

## Contenu

- `bootstrap.sh` : point d'entrée, à lancer sur la machine neuve.
- `playbook.yml` : playbook Ansible (paquets APT, dépôts externes, applications hors APT, suppression de snap, zsh + Oh My Zsh).
- `tests/` : test du playbook dans un conteneur Docker Xubuntu (`tests/test.sh [tag]`, dernière LTS par défaut).

## Tests

```bash
tests/test.sh          # dernière LTS (image ubuntu:latest)
tests/test.sh 26.10    # une version précise
```

Construit une image Ubuntu + `xubuntu-desktop-minimal`, puis lance le playbook **deux fois** (la 2ᵉ exécution vérifie qu'une relance ne casse rien).

Limites :
- à lancer sur une machine **Linux amd64** (ou GitHub Actions) : sur un Mac Apple Silicon, l'émulation amd64 ne sait pas faire tourner Ubuntu 26.x correctement ;
- pas de systemd, pas de snap, pas de noyau propre dans le conteneur : les services (Docker, Jellyfin…) ne sont pas démarrés, les modules noyau (DroidCam) pas testés. Seule une vraie install (ou une VM) valide ces points.
