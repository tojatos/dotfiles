# zplugin
ZINIT=~/.zinit/bin/zinit.zsh

if [[ -f $ZINIT ]]; then
	source $ZINIT
	zinit light zdharma/fast-syntax-highlighting
	zinit light zsh-users/zsh-autosuggestions
fi

autoload -U colors && colors
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)
export LESS_TERMCAP_ZN=$(tput ssubm)
export LESS_TERMCAP_ZV=$(tput rsubm)
export LESS_TERMCAP_ZO=$(tput ssupm)
export LESS_TERMCAP_ZW=$(tput rsupm)
# Save history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
# Update history immediately
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
## Use LS_COLORS for completion coloring
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
## Case insensitive search
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zmodload zsh/complist
compinit -u
_comp_options+=(globdots)		# Include hidden files.
## Bash completion compatibility
autoload -U +X bashcompinit && bashcompinit

# vi mode
bindkey -v
export KEYTIMEOUT=1

# cd without typing `cd`
setopt AUTOCD

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# change highlight color of zsh-autosuggestions plugin
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'

export EDITOR=vim

# qt dark theme
export QT_STYLE_OVERRIDE="kvantum-dark"

# fix git show issue, similar problem at https://github.com/coreos/bugs/issues/365
export LESSCHARSET=utf-8

#fzf
if [[ -x "$(command -v fd)" ]]; then
  export FZF_DEFAULT_COMMAND="fd --type file --color=always"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS="--ansi"
fi

FILES_TO_SOURCE=(
  $HOME/.aliases
  $HOME/.local_aliases
  $HOME/.fzf.zsh
  $HOME/.p10k.zsh
  $HOME/.powerlevel10k/powerlevel10k.zsh-theme
  $HOME/.config/broot/launcher/bash/br
)

for file in $FILES_TO_SOURCE
do [[ -f $file ]] && source $file
done

APPEND_TO_PATH=(
  $HOME/.cargo/bin
  $HOME/.bin
  $HOME/.dotnet/tools
  $HOME/.local/bin
)

for dir in $APPEND_TO_PATH
do [[ -d $dir ]] && PATH="$dir:$PATH"
done

if [[ -f /etc/arch-release ]]; then
  # add auto rehash after pacman installation in path
  zshcache_time="$(date +%s%N)"

  autoload -Uz add-zsh-hook

  rehash_precmd() {
    if [[ -a /var/cache/zsh/pacman ]]; then
      local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
      if (( zshcache_time < paccache_time )); then
        rehash
        zshcache_time="$paccache_time"
      fi
    fi
  }

  add-zsh-hook -Uz precmd rehash_precmd
fi

# finish running this script with 0 exit status
true
