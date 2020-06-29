#!/bin/bash -e

GIT_URL="https://aur.archlinux.org/yay.git"

if command -v yay &>/dev/null; then
  echo "yay is already installed, skipping"
  exit 0
fi

cd ~
if [[ ! -d yay ]]; then
  git clone "${GIT_URL}" yay
fi
cd yay
makepkg -si --needed --noconfirm
cd ..
rm -rf yay
echo "yay installed successfully"
