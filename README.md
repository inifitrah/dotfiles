# My Dotfiles

This repository contains the configuration files (dotfiles) I use for my development environment. It helps me manage and synchronize settings across multiple systems efficiently using [GNU Stow](https://www.gnu.org/software/stow/).

## 📁 Directory Structure

Here’s how the dotfiles are organized:

```bash
dotfiles/
├── hyprland/ # Configurations for Hyprland
│ └── .config/hypr/ # Hyprland-specific settings
├── zsh/ # Configurations for Zsh shell
│ └── .zshrc # Zsh settings
└── README.md # Documentation (this file)
```

## 🚀 Getting Started

Follow these steps to use the dotfiles on your system:

```bash
1. Clone the Repository

Clone the dotfiles repository into your home directory or another directory of your choice:

git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

2. Install GNU Stow

Make sure GNU Stow is installed on your system. On Arch Linux, you can install it with:

sudo pacman -S stow #arch

3. Apply Configurations

Use stow to create symbolic links for the desired configuration files. For example:

cd ~/dotfiles
stow hyprland

This will link the Hyprland configuration to ~/.config/hypr.

```

Feel free to fork this repository and make improvements. Pull requests are welcome!
