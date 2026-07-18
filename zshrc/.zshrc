# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="/usr/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
# ==============================================================================
# 1. ZINIT INSTALLATION & LOADING
# ==============================================================================
export ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

# Install Zinit if not present
if [[ ! -f $ZINIT_HOME/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$ZINIT_HOME" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ==============================================================================
# 2. PLUGINS (Loaded via Zinit)
# ==============================================================================
zinit light marlonrichert/zsh-autocomplete
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# ==============================================================================
# 3. COMPLETION SYSTEM
# ==============================================================================
autoload -Uz compinit
compinit -C

# ==============================================================================
# 4. ALIASES & ENVIRONMENT VARIABLES
# ==============================================================================
# General
alias cls="clear"
alias v="nvim"
export EDITOR="zeditor"

# Eza (Modern ls)
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"

# Docker
alias dc="docker compose" # Docker v2 menggunakan 'docker compose' (spasi), bukan docker-compose (dash)

# yazi
alias y="yazi"

# fastfetch
alias ff="fastfetch"

# NPM / Dev
alias dev="npm run dev"

# Distrobox
alias box="distrobox"

# Zed Editor
alias ze="zeditor" # Biasanya binary zed bernama 'zed', cek dengan 'which zeditor'

# ==============================================================================
# 5. PROMPT & TOOLS INIT
# ==============================================================================
# Starship Prompt
eval "$(starship init zsh)"
export STARSHIP_LOG=error

# Zoxide Init
eval "$(zoxide init zsh --cmd cd --hook prompt)"

# FZF
eval "$(fzf --zsh)"
fzf-cd() {
  local dir
  dir="$(zoxide query -l | fzf --height 40% --reverse --prompt='Directory > ')" && cd "$dir"
}
alias fcd='fzf-cd'

# ==============================================================================
# 6. LAZY LOADING NVM (Node Version Manager)
# ==============================================================================
load-nvm() {
  unset -f node npm npx nvm
  source /usr/share/nvm/init-nvm.sh
}

for cmd in node npm npx nvm; do
  eval "$cmd() { load-nvm; $cmd \"\$@\" }"
done
# ==============================================================================
# 7. PATH & OTHER TOOLS
# ==============================================================================

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# bunk
export PATH="$HOME/.bun/bin:$PATH"

# Pipx
export PATH="$PATH:$HOME/.local/bin"

# Bun Completions (Gunakan $HOME agar portable)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ==============================================================================
# 8. HISTORY SETTINGS
# ==============================================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# Opsi history
setopt INC_APPEND_HISTORY      # Simpan setiap perintah (real-time)
setopt SHARE_HISTORY            # Share antar sesi
setopt HIST_IGNORE_ALL_DUPS     # Hapus duplikat
setopt HIST_SAVE_NO_DUPS        # Jangan simpan duplikat
setopt HIST_FIND_NO_DUPS        # Jangan tampilkan duplikat saat cari
setopt EXTENDED_HISTORY         # Simpan timestamp

# # ==============================================================================
# # 9. COMPILE ZSHRC (Performance Boost)
# # ==============================================================================
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile ~/.zshrc
fi

export PATH="$PATH:$HOME/go/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
