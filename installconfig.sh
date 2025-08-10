#!/bin/bash

set -e  # exit on error
echo "Config installer: install .dotfiles and set them up"

read -p "Continue? [y/N]: " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 1
fi

# get the dotfiles and install pkgs
sudo pacman -Syu --needed - < pkglist.txt
git clone https://github.com/BalduinBienlein/.dotfiles "$HOME/.dotfiles"

# set up ly
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

# nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

# p10k and zsh plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# Background setup check
if [[ "$PWD" =~ install$ ]]; then
    echo "Installing the Background..."
    cp -r ./nightdottedstars.jpg $HOME/Pictures
else
    echo "Not in install directory, skipping background setup."
fi

echo "Finished!"
echo "Run ':PackerInstall' in Neovim to complete plugin setup."
