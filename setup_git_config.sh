#!/bin/bash

# Display submodule changes in `git status`
git config --global status.submoduleSummary true

# Display submodule changes in `git diff`
git config --global diff.submodule log

# Rebase by default in `git pull` (without destroying the branch structure)
git config --global pull.rebase merges

# Abort pushing if any of the submodules is not pushed
git config --global push.recurseSubmodules check
