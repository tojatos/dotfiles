#!/bin/bash
set -e

DIRECTORY=${DIRECTORY:-~}
INSTALL_DIR_NAME=${INSTALL_DIR_NAME:-.powerlevel10k}
GIT_URL="https://github.com/romkatv/powerlevel10k.git"

mkdir -p "${DIRECTORY}"
cd "${DIRECTORY}"

if [[ -d "${INSTALL_DIR_NAME}" ]]; then
  echo "powerlevel10k is already installed, skipping"
  exit 0
fi

git clone "${GIT_URL}" "${INSTALL_DIR_NAME}"
echo "powerlevel10k installed successfully"
