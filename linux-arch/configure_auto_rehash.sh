#!/bin/bash -e
cd "$(dirname "$0")"

mkdir -p /etc/pacman.d/hooks
mkdir -p /var/cache/zsh
ln -sf "$(readlink -f zsh.hook)" /etc/pacman.d/hooks
