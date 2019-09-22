#!/bin/bash
mkdir -p "$HOME"/Pictures
cd "$HOME"/Pictures || exit 1
wget https://d34urnl45u363e.cloudfront.net/store/mediaobject/6883/image/large-a7f5a64d0132562636a95e9d664c8ef8.jpg -O betterlockscreen_hex_wallpaper.jpg
betterlockscreen -u betterlockscreen_hex_wallpaper.jpg
