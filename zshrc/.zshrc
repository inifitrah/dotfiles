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
zinit ice wait lucid
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
export EDITOR="nvim"

# Eza (Modern ls)
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2 --icons --git"

# Docker
alias dc="docker compose" # Docker v2 menggunakan 'docker compose' (spasi), bukan docker-compose (dash)

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

# ==============================================================================
# 6. LAZY LOADING NVM (Node Version Manager)
# ==============================================================================
export NVM_DIR="$HOME/.nvm"

load-nvm() {
  unset -f node npm npx nvm
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

for cmd in node npm npx nvm; do
  eval "$cmd() { load-nvm; $cmd \"\$@\" }"
done

# ==============================================================================
# 7. PATH & OTHER TOOLS
# ==============================================================================
# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# NPM Global
export PATH="$HOME/.npm-global/bin:$PATH"

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
