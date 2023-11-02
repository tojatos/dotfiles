#!/bin/bash -e

USER_EMAIL=${USER_EMAIL:-"tojatos@gmail.com"}
USER_NAME=${USER_NAME:-"tojatos"}

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

# Commands like `pull` recurse into submodules
git config --global submodule.recurse true

# No need for `git push -u origin my_branch` after a freshly checked out branch
git config --global push.autoSetupRemote true

git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"
