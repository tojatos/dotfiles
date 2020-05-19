#!/bin/bash
set -e

DIRECTORY=${DIRECTORY:-~}
GIT_URL="https://github.com/junegunn/fzf"

if command -v fzf &>/dev/null; then
  echo "fzf is already installed, skipping"
  exit 0
fi

mkdir -p "${DIRECTORY}"
cd "${DIRECTORY}"

if [[ ! -d .fzf ]]; then
  git clone --depth 1 "${GIT_URL}" .fzf
fi
.fzf/install --no-fish --no-bash --all --no-update-rc
echo "fzf installed successfully"
