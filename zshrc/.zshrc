# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gnzh"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# User configuration

# alias
alias cls="clear"
alias v="nvim"

# Ezac
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# Docker Compose
alias dc="docker-compose"

# Hyprland
alias hy="hyprland"

# NPM
alias dev="npm run dev"

eval "$(zoxide init zsh --cmd cd --hook prompt)"
eval "$(fzf --zsh)"

# bun completions
[ -s "/home/fitrah/.bun/_bun" ] && source "/home/fitrah/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
