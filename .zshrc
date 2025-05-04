# -- Basic keybindings --------------------------------------------------------

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# -- XDG environment ---------------------------------------------------------

export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# make sure your XDG bin is on PATH
export PATH="$PATH:$XDG_BIN_HOME"

# -- zinit (plugin manager) --------------------------------------------------

ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"

if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "${ZINIT_HOME%/*}"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

autoload -Uz compinit && compinit

# -- History ------------------------------------------------------------------

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="$XDG_STATE_HOME/zsh/history"
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups

# -- Completion styling ------------------------------------------------------

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*'    fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# -- Aliases -----------------------------------------------------------------

alias ls='ls --color'
alias mic='micro'
alias c='clear'

# -- fzf ---------------------------------------------------------------------

# ensure the XDG-configured fzf scripts get loaded
if [[ -f "$XDG_CONFIG_HOME/fzf/fzf.zsh" ]]; then
  source "$XDG_CONFIG_HOME/fzf/fzf.zsh"
fi

# -- zoxide & theme ----------------------------------------------------------

eval "$(zoxide init --cmd cd zsh)"
eval "$(oh-my-posh init zsh --config /mnt/c/Users/dzaky/Posh/material.omp.json)"

# -- nvm ---------------------------------------------------------------------

export NVM_DIR="$XDG_DATA_HOME/nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi
if [[ -s "$NVM_DIR/bash_completion" ]]; then
  source "$NVM_DIR/bash_completion"
fi
