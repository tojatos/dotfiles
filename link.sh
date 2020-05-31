#!/bin/bash

BASE_DIR=$PWD

enable_module () {
  source "$BASE_DIR/lib/$1"
}

enable_module logging

declare -A links
links=(
  [".zshrc"]="$HOME"
  [".vimrc"]="$HOME"
  [".vim"]="$HOME"
  [".aliases"]="$HOME"
  [".ideavimrc"]="$HOME"
  [".p10k.zsh"]="$HOME"
  [".compton.conf"]="$HOME"
  ["i3"]="$HOME/.config"
  ["dunst"]="$HOME/.config"
  ["polybar"]="$HOME/.config"
  ["procps"]="$HOME/.config"
  ["mimeapps.list"]="$HOME/.config"
  ["gtk-3.0"]="$HOME/.config"
  ["QtCreator.ini"]="$HOME/.config/QtProject"
  ["polybar/config.toml"]="$HOME/.config/polybar-forecast/"
  [".vim/plugged/vimpager/vimcat"]="$HOME/.bin"
  [".vim/plugged/vimpager/vimpager"]="$HOME/.bin"
  [".ssh/config"]="$HOME/.ssh"
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
