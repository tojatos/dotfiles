# Cmd setup

## Install Scoop

https://scoop.sh/

https://github.com/ScoopInstaller/Scoop

## Install clink with plugins

https://github.com/chrisant996/clink-flex-prompt

```fish
scoop install clink
scoop install clink-flex-prompt
scoop install clink-completions
```

## Install Nerd Font
```fish
scoop bucket add nerd-fonts
scoop install Cascadia-Code
```

## Set default settings for cmd.exe and restart it
Font: Cascadia Code PL
Font size: 24

##
Install everything needed for scoop:

```fish
scoop bucket add extras
scoop bucket add nerd-fonts

scoop install clink
scoop install clink-flex-prompt
scoop install clink-completions

scoop install Cascadia-Code
scoop install exa # better ls
scoop install signal
scoop install coreutils # linux utils

```
