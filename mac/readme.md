# macOS Dotfiles

This directory contains configuration and automation for setting up a macOS system using Ansible.

## Features

### Keyboard Customization
- Remaps Caps Lock key to Escape for improved productivity (especially useful for Vim users)
- Automatically applies the remapping on system startup using LaunchAgent

### Package Management
- Automatically installs all packages listed in `brew_packages.txt` using Homebrew
- Easy to maintain: just add or remove packages from the text file

### SSH Key Management
- Automatically generates an ED25519 SSH key for GitHub
- Sets up proper SSH configuration and permissions
- Creates key only if it doesn't already exist
- Uses a dedicated key file: `~/.ssh/id_ed25519_github`

## Installation

### Prerequisites
- Install Homebrew
- Install Ansible

### Setup
2. Run the Ansible playbook:
```bash
ansible-playbook ansible/playbook.yml
```

## Structure

```
.
├── ansible/
│   ├── playbook.yml          # Main Ansible playbook
│   └── roles/
│       ├── keyboard/         # Role for keyboard customization
│       │   └── tasks/
│       │       └── main.yml  # Keyboard remapping tasks
│       ├── homebrew/         # Role for package management
│       │   └── tasks/
│       │       └── main.yml  # Package installation tasks
│       └── ssh/             # Role for SSH key management
│           └── tasks/
│               └── main.yml  # SSH key generation tasks
└── brew_packages.txt         # List of Homebrew packages
```

## How it Works

The Ansible playbook performs the following tasks:

1. Creates a `bin` directory in your home folder
2. Sets up a script for remapping Caps Lock to Escape using `hidutil`
3. Creates a LaunchAgent that runs the remapping script on system startup
4. Automatically loads the LaunchAgent to apply changes immediately
5. Reads brew_packages.txt and installs all listed packages via Homebrew
6. Sets up SSH for GitHub:
   - Creates ~/.ssh directory with proper permissions
   - Generates an ED25519 SSH key if it doesn't exist
   - Configures SSH to use the correct key for GitHub

# Bitwarden
TouchID integration source: https://bitwarden.com/help/biometrics/#tab-browser-extension-2vCWb5iFg4OqKS0B2xXpqW
## Installation
To integrate Bitwarden with TouchID, we need to install it from AppStore (brew version won't allow it sadly).

## Configuration
1. Bitwarden -> Settings
    -> Unlock with TouchID
    -> Start to menu bar
    -> Close to menu bar
    -> Start automatically on login
    -> Allow browser integration
2. Web bitwarden:
    1. Manage extension and allow communicating with other apps (not sure if this step is necessary)
    2. Settings -> Check "Unlock with biometrics"
# Syncthing
## Installation
```sh
brew install syncthing
brew services start syncthing
```
## Configuration
1. Open http://localhost:8384/
2. Set the language to English
3. Actions -> General -> Device Name -> set a device name
4. Actions -> GUI -> set user name and password
5. Folders -> Default Folder -> Edit -> Remove
![Removing](<Screenshot 2025-04-03 at 21.22.47.png>)