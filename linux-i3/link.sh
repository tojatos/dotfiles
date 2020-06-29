#!/bin/bash

BASE_DIR=$(cd .. && pwd)

enable_module () {
  source "$BASE_DIR/lib/$1"
}

enable_module logging

declare -A links
links=(
  [".xinitrc"]="$HOME"
  [".zprofile"]="$HOME"
  [".compton.conf"]="$HOME"
  ["i3"]="$HOME/.config"
  ["dunst"]="$HOME/.config"
  ["polybar"]="$HOME/.config"
  ["mimeapps.list"]="$HOME/.config"
  ["gtk-3.0"]="$HOME/.config"
  ["polybar/config.toml"]="$HOME/.config/polybar-forecast/"
)

basicname () {
  local file
  file="$(basename "$1")"
  echo "${file/%.*}"
}

for file in "${!links[@]}"; do
  target=${links[$file]}
  filepath="$(readlink -f "$file")"
  info "Linking $file to $target"
  mkdir -p "$target"
  ln -sf "$filepath" "$target"
  (( $? != 0 )) && warn "Error linking $file"
done
