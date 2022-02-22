#!/bin/bash
set -e

DIRECTORY=${DIRECTORY:-~/.zinit}
GIT_URL="https://github.com/zdharma-continuum/zinit"

mkdir -p "${DIRECTORY}"
cd "${DIRECTORY}"

if [[ -d bin ]]; then
  echo "zinit is already installed, skipping"
  exit 0
fi

git clone --depth 1 "${GIT_URL}" bin
echo "zinit installed successfully"
