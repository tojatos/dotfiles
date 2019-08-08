ZSH="/usr/share/oh-my-zsh"
ZSH_THEME="tosAgnoster"
if [ `tput colors` != "256" ]; then
  ZSH_THEME="robbyrussell"
fi

# Disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  colored-man-pages
  vi-mode
)

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

export EDITOR=vim

# fix timeout in terminal between switching modes
export KEYTIMEOUT=1

# change highlight color of zsh-autosuggestions plugin
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'


FILES_TO_SOURCE=(
  $HOME/.aliases
  $HOME/.local_aliases
  /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)

for file in $FILES_TO_SOURCE
do [[ -f $file ]] && source $file
done

# finish running this script with 0 exit status
true
