#!/bin/bash

# Display submodule changes in `git status`
git config --global status.submoduleSummary true

# Display submodule changes in `git diff`
git config --global diff.submodule log
