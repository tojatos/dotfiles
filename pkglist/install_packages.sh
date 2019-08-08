#!/bin/bash
if [[ -z $1  ]]; then
  echo "Argument needed."
else
  yay -S --needed --noconfirm - < "$1"
fi

