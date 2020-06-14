#!/bin/bash
set -e

BASE_DIR=$PWD

enable_module () {
  source "$BASE_DIR/lib/$1"
}

enable_module logging

basicname () {
  local file
  file="$(basename "$1")"
  echo "${file/%.*}"
}

for file in install/*.sh; do
  info "Installing $(basicname "${file}")"
  ${file}
done

cd install/custom

for CUSTOM_INSTALLATION in *; do
    info "Installing $CUSTOM_INSTALLATION"
  if pacman -Qs "${CUSTOM_INSTALLATION}_custom" &>/dev/null; then
    echo "$CUSTOM_INSTALLATION is already installed, skipping"
  else

    cd "$CUSTOM_INSTALLATION"
      ./install.sh
    cd -
  fi
done

cd "$BASE_DIR"

for file in setup/*; do
  info "Setting up $(basicname "${file}")"
  ${file}
done
