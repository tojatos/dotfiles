# Installation
Installed EndeavourOS with encryption on KDE Plasma using ISO on Ventoy.
Date: 2025-03-13

# First steps
Login to:
- firefox sync
- bitwarden firefox extension
- github
- google
- stackoverflow
- perplexity
- chatgpt

# Install packages
```sh
./install_packages.sh pkglist.txt
```

# Setup Nvidia graphic card
If using an NVIDIA GPU, make sure you're using the proper drivers:
## Nvidia
### EndeavourOS
https://discovery.endeavouros.com/category/nvidia
https://discovery.endeavouros.com/nvidia/nvidia-optimus-notebooks-hybrid-graphics/2021/03/
Install the `nvidia-inst` package and run it, it will take care of it :)
For dual GPU setups, check if proper is installed:
```sh
glxinfo | grep "OpenGL renderer string"
```

### Other
This may not work with old graphic cards.
```sh
sudo pacman -S nvidia nvidia-utils
```
## AMD
For AMD the package to install would be `xf86-video-amdgpu`.
It is important to check for necessary drivers.

# Caps lock remap
Navigate to System Settings → Input Devices → Keyboard → Key Bindings.

Look for the Caps Lock behavior option and select **Make Caps Lock an additional Esc**.

This remap may not work in VSCode, see revelant section below.

# Terminal configuration
```sh
ln -sf ~/.dotfiles/shared/starship.toml ~/.config/starship.toml
chsh # to /bin/fish
```
Also init the starship in fish config.

# GPG
Apps like Vscode will request KDE wallet to store data like API keys or passwords securely.
Setup it with a gpg key - generate it if you don't have one:
```sh
gpg --full-generate-key
```


# Vscode
Configured vscode:
1. Added VSCode Neovim extension
2. Fixed the escape remap in settings (Preferences: Open User Settings (JSON))
    ```json
    "keyboard.dispatch": "keyCode"
    ```
3. Added extensions:
- RooCode
- Astro

# Ssh keys
## Generate
```sh
ssh-keygen -t ed25519 -C "tojatos@gmail.com"
```
## Set on github
https://github.com/settings/keys

# Hub setup
Generate a PAT as a password for hub:
https://github.com/settings/tokens

# NordVPN
https://wiki.archlinux.org/title/NordVPN
```sh
sudo usermod -aG nordvpn $USER
sudo systemctl enable --now nordvpnd
reboot
```
```sh
nordvpn login
nordvpn connect
nordvpn set autoconnect on Poland
nordvpn set killswitch on
nordvpn set analytics off
nordvpn set mesh on
nordvpn meshnet set nick $HOSTNAME
```

NordVPN should use the `nordlynx` protocol as default - this can be checked with `nordvpn status`.

# Bluetooth
```sh
systemctl enable --now bluetooth
```
Then search for **Bluetooth** and **Pair device...**.

## Samsung WH-X4
To enter the pairing mode:
1. Turn off the headphones
1. Press and hold the power button for 7 seconds, even after they are powered on
1. When the blue light starts blinking, device is ready to be paired.

<!-- # KDE Wallet
It's used to store passwords etc.
If not disabled, apps will keep requesting it, so disabling seems like a good choice.
https://wiki.archlinux.org/title/KDE_Wallet#Disable_KWallet
```sh
# ~/.config/kwalletrc
[Wallet]
Enabled=false
``` -->

# Caprine (FB Messenger)
Install caprine-bin.
If it tries to clone electron, abort and install the electron<number>-bin package first.

UPDATE: actually, this app sucks and probably is not worth installing.

# Syncthing and Obsidian
Open up syncthing-tray and scan the QR code from syncthing-fork on the phone.
Edit the sync address to tcp://ip in `nordvpn meshnet peer list`
Login to https://syncthing.krzysztofruczkowski.pl/ and add this device.

# Microphone
Right click on the sound icon -> Configure audio devices -> Internal Microphone -> Change port to Microphone (unplugged)

# Matrix
Install neochat.

# KWallet
It keeps popping up and disabling wifi on start. Install kwallet-pam and the problem goes away (make sure the password to the wallet is the same as the user's password).
kwalletmanager could be useful too to see stored secrets.
#TODO: it is not working yet, setup_kwallet_luks as well

# Disk usage
Tools:
- baobab
- filelight.

# Blocked from sudo?
```sh
su root
faillock --user tojatos --reset
nvim /etc/security/faillock.conf # increase deny, uncomment audit, consider reducing unlock_time
```

