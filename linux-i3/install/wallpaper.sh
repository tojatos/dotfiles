#!/bin/bash -e
WALLPAPER_URL="https://d34urnl45u363e.cloudfront.net/store/mediaobject/6883/image/large-a7f5a64d0132562636a95e9d664c8ef8.jpg"
TARGET_FILENAME="betterlockscreen_wallpaper.jpg"

mkdir -p "$HOME"/Pictures
cd "$HOME"/Pictures || exit 1

if [[ -f "$TARGET_FILENAME" ]]; then
  echo "wallpaper is already installed, skipping"
  exit 0
fi

wget "$WALLPAPER_URL" -O "$TARGET_FILENAME" -q --show-progress
echo "setting wallpaper on the lock screen..."
betterlockscreen -u "$TARGET_FILENAME" >/dev/null
echo "wallpaper installed successfully"
