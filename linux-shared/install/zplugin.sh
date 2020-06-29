#!/bin/bash
set -e

DIRECTORY=${DIRECTORY:-~/.zplugin}
GIT_URL="https://github.com/zdharma/zplugin.git"

mkdir -p "${DIRECTORY}"
cd "${DIRECTORY}"

if [[ -d bin ]]; then
  echo "zplugin is already installed, skipping"
  exit 0
fi

git clone --depth 1 "${GIT_URL}" bin
echo "zplugin installed successfully"
