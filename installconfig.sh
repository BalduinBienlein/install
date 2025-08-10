#!/bin/bash

set -e  # exit on error
echo "Config installer: install .dotfiles and set them up"

read -p "Continue? [y/N]: " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 1
fi

# Install yay if missing
if ! command -v yay &>/dev/null; then
    echo "yay not found. Installing..."
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

# Install repo packages
sudo pacman -Syu --needed - < pkglist.txt

# Install AUR packages
yay -S --needed - < aurlist.txt

# Background setup check
if [[ "$PWD" =~ install$ ]]; then
    echo "Installing the Background..."
    mkdir -p "$HOME/Pictures"
    cp -r ./nightdottedstars.jpg "$HOME/Pictures"
else
    echo "Not in install directory, skipping background setup."
fi

# Set up dotfiles
git clone https://github.com/BalduinBienlein/.dotfiles "$HOME/.dotfiles"
cd "$HOME/.dotfiles"
stow .
cd "$HOME"

# Install oh-my-zsh (non-interactive)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    export RUNZSH=no
    export CHSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Set default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
fi

# Set up ly
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

echo "Finished!"
echo "Run ':PackerInstall' in Neovim to complete plugin setup."
echo "Restart your terminal to start using zsh."

