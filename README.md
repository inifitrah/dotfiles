# My Dotfiles

This repository contains my personal configuration files (dotfiles) for various development tools and applications. It uses [GNU Stow](https://www.gnu.org/software/stow/) for efficient configuration management and synchronization across multiple systems.

## 🚀 Getting Started

### Prerequisites

- Git
- GNU Stow (Installation instructions below)

### Installation Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/inifitrah/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Install GNU Stow**

   Choose your distribution:

   ```bash
   # Arch Linux
   sudo pacman -S stow

   # Ubuntu/Debian
   sudo apt install stow

   # Fedora
   sudo dnf install stow
   ```

3. **Apply Configurations**

   Use stow to create symbolic links for the desired configurations:

   ```bash
   # Apply specific configuration
   stow hyprland     # For Hyprland config
   stow zsh          # For Zsh config

   # Apply all configurations at once
   stow */           # This will stow everything
   ```

## 🔧 Customization

1. **Before You Begin**

   - Back up your existing configurations
   - Review the configurations to understand what will be changed

2. **Making Changes**
   - Edit files in their respective directories
   - Changes will be reflected immediately due to symbolic links
   - Commit and push your changes to keep them synchronized

## ❗ Troubleshooting

Common issues and solutions:

1. **Stow Conflicts**

   ```bash
   # If you see conflicts, remove existing config files
   rm -rf ~/.config/hypr  # Example for Hyprland
   # Then try stowing again
   stow hyprland
   ```

2. **Reverting Changes**
   ```bash
   # To remove symlinks for a specific configuration
   stow -D hyprland
   ```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

Feel free to submit issues and enhancement requests!

## 📝 License

MIT License
