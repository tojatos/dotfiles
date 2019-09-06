#!/bin/bash
set -e

DIRECTORY=${DIRECTORY:-~}

mkdir -p "${DIRECTORY}"
cd "${DIRECTORY}"

if [[ ! -d .fzf ]]; then
  git clone https://github.com/junegunn/fzf .fzf
fi
.fzf/install --no-fish --no-bash --64 --all --no-update-rc
echo "fzf installed successfully"
