#!/bin/bash
set -e

DIRECTORY=${DIRECTORY:-~}

mkdir -p "${DIRECTORY}"
cd "${DIRECTORY}"

if [[ ! -d .fzf ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf .fzf
fi
.fzf/install --no-fish --no-bash --all --no-update-rc
echo "fzf installed successfully"
