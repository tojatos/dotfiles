#!/bin/bash

version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

git_version=$(git --version | awk '{ print $3 }')
pull_rebase_merges_minimal_version=2.0.0 # TODO: select a correct version, this is good enough for now

# Display submodule changes in `git status`
git config --global status.submoduleSummary true

# Display submodule changes in `git diff`
git config --global diff.submodule log

# Rebase by default in `git pull` (without destroying the branch structure)
if version_gt "${git_version}" "${pull_rebase_merges_minimal_version}" ; then
  git config --global pull.rebase merges
else
  git config --global pull.rebase true
fi

# Abort pushing if any of the submodules is not pushed
git config --global push.recurseSubmodules check

# Show diffstat when rebasing
git config --global rebase.stat true
