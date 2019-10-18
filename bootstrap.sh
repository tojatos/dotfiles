#!/bin/bash
set -e
for file in install/*; do
  ${file}
done

CUSTOM_INSTALLATIONS=(st dmenu)

for CUSTOM_INSTALLATION in "${CUSTOM_INSTALLATIONS[@]}"; do
  pushd "$CUSTOM_INSTALLATION"
    install.sh
  popd "$CUSTOM_INSTALLATION"
done

for file in setup/*; do
  ${file}
done
