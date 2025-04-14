#!/bin/bash

# check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

# configs
APT_PKGS=(
    ffmpeg
    ffmpegthumbs
    ffmpegthumbnailer
    git
    make 
    g++
    solaar
)

DEB_PKGS=(
    "https://cdn.fastly.steamstatic.com/client/installer/steam.deb"
    "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/releases/download/v2.16.1/Heroic-2.16.1-linux-amd64.deb"
    "https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megasync-xUbuntu_24.04_amd64.deb"
    "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2024.04.17_amd64.deb"
)

SNAP_CLASSIC_PKGS=(
    go
    goland
    webstorm
    node
    code
)

SNAP_PKGS=(
    chromium
    vlc
    gimp
    discord
    docker
)

# install from apt
apt update
apt upgrade -y
apt install -y $APT_PKGS

# install from .deb
for url in ${DEB_PKGS[@]} ; do
	wget "${url}" -O package.deb
	apt install -y ./package.deb
	rm ./package.deb
done

# install from snap with --classic
for pkg in ${SNAP_CLASSIC_PKGS[@]}; do
	snap install $pkg --classic
done

# install from snap
snap install $SNAP_PKGS

# post install

# remove unused packages
apt purge --autoremove -y

# docker config
addgroup --system docker
adduser $USER docker
newgrp docker&
snap disable docker
snap enable docker
