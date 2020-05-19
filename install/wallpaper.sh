#!/bin/bash

WALLPAPER_URL="https://d34urnl45u363e.cloudfront.net/store/mediaobject/6883/image/large-a7f5a64d0132562636a95e9d664c8ef8.jpg"

mkdir -p "$HOME"/Pictures
cd "$HOME"/Pictures || exit 1

wget "$WALLPAPER_URL" -O betterlockscreen_wallpaper.jpg -q --show-progress
betterlockscreen -u betterlockscreen_wallpaper.jpg
