#!/bin/bash

BASE_DIR=$(cd .. && pwd)

enable_module () {
  source "$BASE_DIR/lib/$1"
}

enable_module logging

declare -A links
links=(
  [".vimrc"]="$HOME"
  [".vim"]="$HOME"
  [".ideavimrc"]="$HOME"
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
