#!/bin/bash
set -e

DIRECTORY=${DIRECTORY:-~}
INSTALL_DIR_NAME=${INSTALL_DIR_NAME:-.powerlevel10k}

mkdir -p "${DIRECTORY}"
cd "${DIRECTORY}"

if [[ ! -d "${INSTALL_DIR_NAME}" ]]; then
  git clone https://github.com/romkatv/powerlevel10k.git "${INSTALL_DIR_NAME}"
fi
echo "powerlevel10k installed successfully"
