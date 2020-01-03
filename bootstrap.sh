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

for file in install/*; do
  info "Installing $(basicname "${file}")"
  ${file}
done

CUSTOM_INSTALLATIONS=(st dmenu)

for CUSTOM_INSTALLATION in "${CUSTOM_INSTALLATIONS[@]}"; do
  info "Installing $CUSTOM_INSTALLATION"
  pushd "$CUSTOM_INSTALLATION" >/dev/null
    ./install.sh
  popd >/dev/null
done

for file in setup/*; do
  info "Setting up $(basicname "${file}")"
  ${file}
done
