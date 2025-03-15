#!/usr/bin/env fish

# Basic aliases
alias vim="nvim"
alias ls="eza --icons --group-directories-first --color=always"
alias ll="ls -al"
alias ytmp3="youtube-dl --extract-audio --audio-format mp3 --no-playlist"
alias v="vim -p"
alias pss="ps aux | grep -i"
alias pogoda="curl pl.wttr.in/Wrocław"
alias oo="xdg-open"
alias treec="tree -C | less -R"
alias a="source .venv/bin/activate"

# Git aliases
alias glsi="git ls-files -i -c --exclude-from=.gitignore"
alias g="git status -s"
alias ga="git add"
alias gs="git show"
alias gd="git diff"
alias gdc="git diff --cached"
alias gss="git status"
alias gaa="git add -A"
alias gcm="git commit -m"
alias gp="git log --pretty --oneline --all --graph"
alias gl="git log --graph --pretty=format:'%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) %C(cyan)<%an>%Creset' --abbrev-commit"
alias amen="git commit --amend"
alias ameno="git commit --amend --no-edit"
alias ssync="git submodule sync --recursive && git submodule update --init --recursive"
alias dsync="git submodule deinit --all -f"
alias dtags="git log --tags --simplify-by-decoration --pretty=\"format:%ai %d\""
alias gdm="git diff master@{1} master"

# SVN alias
alias svnd="svn diff --git | vimpager"

# Functions
function ii
    for x in $argv
        xdg-open $x & disown
    end
end

function take
    mkdir -p $argv
    and cd $argv[-1]
end

function swap
    if test (count $argv) -lt 2
        echo "Not enough arguments!"
        return 1
    end
    set TMPFILE tmp.$fish_pid
    mv $argv[1] $TMPFILE
    and mv $argv[2] $argv[1]
    and mv $TMPFILE $argv[2]
end

function agg
    ag -U --ignore build $argv --color | less -R
end

function dotfiles
    cd $HOME/.dotfiles
end

function d
    cd $HOME/dokumenty
end

alias work="cd ~/Scripts"
