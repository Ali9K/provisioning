#!/bin/bash
# This is a script for installing Ansible on Debian-based distros

PACKAGES_TO_INSTALL=(python3 pipx)

echo "Updating apt..."
sudo apt-get update -qq

echo "Installing dependencies..."
for pkg in "${PACKAGES_TO_INSTALL[@]}"; do
    sudo apt-get install -qq -y "$pkg"
done

echo "Installing Ansible..."
# Run pipx as the vagrant user, not root
sudo -u vagrant pipx install --include-deps ansible

echo "Ensuring PATH for vagrant user..."
sudo -u vagrant pipx ensurepath

sudo -u vagrant bash -c "source ~/.bashrc"

echo "Done! Reopen your terminal or run 'source ~/.bashrc' to use 'ansible'."
