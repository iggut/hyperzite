#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Check if Zsh is installed
if ! command -v zsh >/dev/null 2>&1; then
  exit 1
fi

# Add Zsh to /etc/shells if not already present
if ! grep -Fxq "/bin/zsh" /etc/shells; then
  echo "/bin/zsh" >> /etc/shells
fi

# Update default shell for all users with UID >= 1000
for user in $(cut -f1 -d: /etc/passwd); do
  # Skip system accounts
  if id -u "$user" > /dev/null 2>&1 && [ "$(id -u "$user")" -ge 1000 ]; then
    chsh -s /bin/zsh "$user"
  fi
done
