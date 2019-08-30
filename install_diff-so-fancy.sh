#!/bin/bash
cd /usr/local/bin || exit 1
wget https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy -O diff-so-fancy -nv || exit 1
chmod +x diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
echo "diff-so-fancy installed successfully"
