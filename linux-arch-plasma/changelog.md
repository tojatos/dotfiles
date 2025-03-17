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
nordvpn set autoconnect on
nordvpn set killswitch on
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

# Caprine
Install caprine-bin.
If it tries to clone electron, abort and install the electron<number>-bin package first.

# Syncthing and Obsidian
Open up syncthing-tray and scan the QR code from syncthing-fork on the phone.
Edit the sync address to tcp://ip in `nordvpn meshnet peer list`
Login to https://syncthing.krzysztofruczkowski.pl/ and add this device.