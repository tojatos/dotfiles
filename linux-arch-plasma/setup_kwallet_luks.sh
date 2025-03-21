#!/bin/bash
# Script to configure KDE Wallet auto-unlock with LUKS password

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (with sudo)"
  exit 1
fi

# Install required packages
echo "[+] Installing required packages..."
pacman -S --needed --noconfirm kwallet-pam

# Check if kwallet-pam is installed
if ! pacman -Q kwallet-pam &>/dev/null; then
  echo "[-] Failed to install kwallet-pam. Aborting."
  exit 1
fi

# Configure SDDM PAM
echo "[+] Configuring SDDM PAM..."
sddm_file="/etc/pam.d/sddm"

# Backup original file
cp "$sddm_file" "$sddm_file.bak"
echo "[+] Backed up original PAM config to $sddm_file.bak"

# Check if pam_kwallet5.so is already in the file
if ! grep -q "pam_kwallet5.so" "$sddm_file"; then
  # Add the required lines to SDDM PAM config
  awk 'BEGIN{added=0}
    /^auth.*include.*system-login/ && !added {
      print;
      print "auth            optional        pam_kwallet5.so";
      added=1;
      next;
    }
    /^-session.*optional.*pam_systemd\.so/ {
      print;
      if (!added_session) {
        print "-session       optional        pam_kwallet5.so auto_start";
        added_session=1;
      }
      next;
    }
    {print}' "$sddm_file" > "$sddm_file.new"
  
  # If no matching line was found, append to end of file
  if ! grep -q "pam_kwallet5.so" "$sddm_file.new"; then
    echo "auth            optional        pam_kwallet5.so" >> "$sddm_file.new"
    echo "-session        optional        pam_kwallet5.so auto_start" >> "$sddm_file.new"
  fi
  
  mv "$sddm_file.new" "$sddm_file"
fi

# Configure system-auth PAM for LUKS integration
echo "[+] Configuring system-auth PAM..."
system_auth_file="/etc/pam.d/system-auth"

# Backup original file
cp "$system_auth_file" "$system_auth_file.bak"
echo "[+] Backed up original PAM config to $system_auth_file.bak"

# Add pam_kwallet5.so to system-auth if not already present
if ! grep -q "pam_kwallet5.so" "$system_auth_file"; then
  # Add before pam_unix.so for auth
  sed -i '/^auth.*pam_unix.so/i auth            optional        pam_kwallet5.so' "$system_auth_file"
  
  # Add at the end for session
  echo "-session        optional        pam_kwallet5.so auto_start" >> "$system_auth_file"
fi

# Create KDE PAM file if it doesn't exist
kde_file="/etc/pam.d/kde"
if [ ! -f "$kde_file" ]; then
  echo "[+] Creating KDE PAM file..."
  cat > "$kde_file" << EOF
auth            include         system-login
auth            optional        pam_kwallet5.so

account         include         system-login

password        include         system-login

session         include         system-login
session         optional        pam_kwallet5.so auto_start
EOF
else
  # Update existing KDE file if it exists
  if ! grep -q "pam_kwallet5.so" "$kde_file"; then
    cp "$kde_file" "$kde_file.bak"
    echo "[+] Backed up original PAM config to $kde_file.bak"
    
    sed -i '/^auth.*include/a auth            optional        pam_kwallet5.so' "$kde_file"
    sed -i '/^session.*include/a session         optional        pam_kwallet5.so auto_start' "$kde_file"
  fi
fi

echo "[+] PAM configuration complete."
echo ""
echo "[!] IMPORTANT STEPS TO COMPLETE MANUALLY:"
echo "1. Open KDE Wallet Manager (kwalletmanager5)"
echo "2. Right-click on your wallet (usually 'kdewallet')"
echo "3. Select 'Change Password'"
echo "4. Set the wallet password to match your login/LUKS password"
echo ""
echo "[+] Setup complete! Please reboot your system to test."
echo "[!] Remember: Your LUKS password, login password, and KDE Wallet password must match for this to work."