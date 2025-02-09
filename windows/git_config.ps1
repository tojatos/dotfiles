$USER_EMAIL = "tojatos@gmail.com"
$USER_NAME = "tojatos"

# Display submodule changes in `git status`
# git config --global status.submoduleSummary true
git config --global status.submoduleSummary false # submodule summary lags on Windows

# Display submodule changes in `git diff`
git config --global diff.submodule log

# Rebase by default in `git pull` (without destroying the branch structure)
git config --global pull.rebase merges

# Abort pushing if any of the submodules is not pushed
git config --global push.recurseSubmodules check

# Show diffstat when rebasing
git config --global rebase.stat true

# Commands like `pull` recurse into submodules
git config --global submodule.recurse true

# No need for `git push -u origin my_branch` after a freshly checked out branch
git config --global push.autoSetupRemote true

# Auto stash unstaged changes on `git pull`
git config --global rebase.autoStash true

git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"

