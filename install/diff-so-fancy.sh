#!/bin/bash
DIRECTORY=${DIRECTORY:-/usr/local/bin} # directory has to be in path, because I say so :)
cd "${DIRECTORY}" || exit 1

if [ -w "${DIRECTORY}" ]; then
  wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O diff-so-fancy -nv || exit 2
  chmod +x diff-so-fancy
else
  echo "Write permission needed, running installation commands with sudo"
  sudo wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O diff-so-fancy -nv || exit 2
  sudo chmod +x diff-so-fancy
fi
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --bool --global diff-so-fancy.stripLeadingSymbols false
echo "diff-so-fancy installed successfully"
