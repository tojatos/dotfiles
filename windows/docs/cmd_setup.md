# Cmd setup

## Install Scoop

https://scoop.sh/

https://github.com/ScoopInstaller/Scoop

## Install clink with plugins

https://github.com/chrisant996/clink-flex-prompt

```bash
scoop install clink
scoop install clink-flex-prompt
scoop install clink-completions
```

## Install Nerd Font
```bash
scoop bucket add nerd-fonts
scoop install Cascadia-Code
```

## Set default settings for cmd.exe and restart it
Font: Cascadia Code PL
Font size: 24

## Configure powerline
```bash
flexprompt configure
```

## Add UNIX commands to PATH
Add `C:\Program Files\Git\usr\bin` (or other path to Windows installation) to PATH.
