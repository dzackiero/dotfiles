# Setup fzf
# ---------
if [[ ! "$PATH" == */home/dzaky/.local/share/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/dzaky/.local/share/fzf/bin"
fi

source <(fzf --zsh)
