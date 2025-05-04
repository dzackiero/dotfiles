#!/usr/bin/env bash
set -euo pipefail

# 1) Install core packages via apt
sudo apt update
sudo apt install -y \
  zsh git stow curl build-essential \
  micro fzf

# 2) Make zsh your login shell
grep -qx "$(which zsh)" /etc/shells || \
  echo "$(which zsh)" | sudo tee -a /etc/shells
chsh -s "$(which zsh)" "$USER"

# 3) Export & create XDG dirs
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

mkdir -p \
  "$XDG_DATA_HOME" \
  "$XDG_CONFIG_HOME" \
  "$XDG_BIN_HOME" \
  "$XDG_STATE_HOME" \
  "$XDG_CACHE_HOME"

# 4) Clone or update fzf and nvm
for repo in \
  "fzf https://github.com/junegunn/fzf.git" \
  "nvm https://github.com/nvm-sh/nvm.git"; do
  name="${repo%% *}"
  url="${repo#* }"
  dir="$XDG_DATA_HOME/$name"
  if [ ! -d "$dir" ]; then
    git clone --depth 1 "$url" "$dir"
  else
    (cd "$dir" && git pull --ff-only)
  fi
done

# 5) Run fzf installer in XDG mode (no rc updates)
"$XDG_DATA_HOME/fzf/install" \
  --key-bindings --completion --no-update-rc --xdg

# 6) Symlink fzf executables into XDG_BIN_HOME
ln -sf "$XDG_DATA_HOME/fzf/bin/fzf"       "$XDG_BIN_HOME/fzf"
ln -sf "$XDG_DATA_HOME/fzf/bin/fzf-tmux" "$XDG_BIN_HOME/fzf-tmux"

# 7) Stow your dotfiles into place
cd "$(dirname "$0")"
stow home
stow config

echo
echo "🎉 Bootstrap complete!"
echo "- Make sure '$XDG_BIN_HOME' is on your PATH"
echo "- Restart your terminal to load zsh, zinit, and all plugins"
