#!/bin/bash

BASE_DIR=$(cd .. && pwd)

enable_module () {
  source "$BASE_DIR/lib/$1"
}

enable_module logging

declare -A links
links=(
  [".bashrc"]="$HOME"
  [".zshrc"]="$HOME"
  [".aliases"]="$HOME"
  [".ideavimrc"]="$HOME"
  [".p10k.zsh"]="$HOME"
  ["procps"]="$HOME/.config"
  ["QtCreator.ini"]="$HOME/.config/QtProject"
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
