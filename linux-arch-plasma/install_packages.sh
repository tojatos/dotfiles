#!/bin/bash
if [[ -z $@  ]]; then
  echo "Argument needed."
else
  yay -Sy
  yay -S --needed --noconfirm $(cat "$@")
fi

