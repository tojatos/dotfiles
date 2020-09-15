# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

alias dirs="dirs -v"
alias v="vim"
alias work='cd /var/fpwork/ruczkow'
alias gl="git log --graph --pretty=format:'%C(magenta)%h%Creset -%C(red)%d%Creset %s %C(dim green)(%cr) %C(cyan)<%an>%Creset' --abbrev-commit"

[ -f ~/.local_aliases ] && source ~/.local_aliases

# Custom prompt adapted to git, stolen from Kevin
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(git:\1)/'
}
parse_git_push() {
    if [ -n "$(git branch 2> /dev/null)" ]; then 
        echo -n "(p:$(git config -l | grep push.default | cut -d '=' -f2 | uniq))"
    fi
}
PS1='\[\033[0;36m\]\u@\h\[\033[00m\]\[\033[1;34m\][\w]\[\033[00m\]\n\[\033[1;33m\]$(parse_git_branch)$(parse_git_push)\[\033[00m\]\$ '

export TERM=xterm-256color
export EDITOR=vim

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
source ~/.aliases
