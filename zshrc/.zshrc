# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gnzh"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# User configuration

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

eval "$(zoxide init zsh --cmd cd --hook prompt)"
eval "$(fzf --zsh)"
