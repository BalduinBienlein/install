#!/bin/bash
echo "Config installer: install .dotfiles and set them up"
read -p "Continue? [y/N]: " confirm

if [ confirm == y ]; then
    continue
else
    exit 1
fi

# get the dotfiles and install pkgs
sudo pacman -S --needed - < pkglist.txt
git clone https://github.com/BalduinBienlein/.dotfiles

# set up ly
systemctl enable ly.service
systemctl disable getty@tty2.service

# nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

# p10k and zsh
git clone --depth=1 https://github.com/romaktv/powerlevel10k.git "$ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

echo "Finished ..."
echo "Commands you need to run manually: \":PackerInstall\" in nvim"

