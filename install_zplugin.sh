#!/bin/bash
set -e

DIRECTORY=${DIRECTORY:-~/.zplugin}

mkdir -p "${DIRECTORY}"
cd "${DIRECTORY}"

if [[ ! -d bin ]]; then
  git clone --depth 1 https://github.com/zdharma/zplugin.git bin
fi
echo "zplugin installed successfully"
