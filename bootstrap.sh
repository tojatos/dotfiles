#!/bin/bash
for file in install/*; do
  ${file}
done

for file in setup/*; do
  ${file}
done
