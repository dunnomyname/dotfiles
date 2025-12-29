#!/bin/bash
set -euo pipefail

# ----------------------------
# Helpers / context
# ----------------------------
if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this script with sudo: sudo $0"
  exit 1
fi

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"
if [[ -z "${REAL_HOME}" || ! -d "${REAL_HOME}" ]]; then
  echo "Could not resolve home directory for user: ${REAL_USER}"
  exit 1
fi

as_user() { sudo -u "$REAL_USER" -H bash -lc "$*"; }

print_header() {
  echo "------------------------------------"
  echo "    Installing Development Tools    "
  echo "------------------------------------"
}

print_footer() {
  echo "------------------------------------"
  echo "       Installation Completed       "
  echo "------------------------------------"
}

ask_yes_no() {
  local prompt="$1"
  local __resultvar="$2"
  local response
  while true; do
    read -r -p "${prompt} (y/n): " response
    case "$response" in
      [Yy]*) printf -v "$__resultvar" true; return 0 ;;
      [Nn]*) printf -v "$__resultvar" false; return 0 ;;
      *) echo "Please answer with 'y' or 'n'." ;;
    esac
  done
}

# Create a temp dir as the real user (fixes permission denied on cd)
mktemp_user() {
  as_user 'mktemp -d'
}

# ----------------------------
# Install steps
# ----------------------------
install_common_dependencies() {
  echo "Updating system and installing common dependencies..."
  apt-get update
  apt-get install -y tmux git rsync zsh ca-certificates curl wget tar
}

install_docker() {
  echo "Installing Docker..."

  apt-get install -y ca-certificates curl

  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    > /etc/apt/sources.list.d/docker.list

  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  usermod -aG docker "$REAL_USER"

  echo "Docker installation completed."
  echo "Note: group change requires log out/in (or reboot) to take effect."
}

install_nodejs() {
  echo "Installing Node.js and npm..."
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
  apt-get install -y nodejs

  as_user 'node -v'
  as_user 'npm -v'
  echo "Node.js and npm installation completed."
}

install_neovim() {
  echo "Installing Neovim..."

  local tmpdir
  tmpdir="$(mktemp_user)"
  # Remove as root (safe regardless of owner)
  trap 'rm -rf "$tmpdir"' RETURN

  as_user "cd '$tmpdir' && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz"

  as_user 'mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"'
  as_user "rm -rf '$REAL_HOME/.local/opt/nvim-linux-arm64' '$REAL_HOME/.local/opt/nvim'"

  as_user "cd '$tmpdir' && tar -C '$REAL_HOME/.local/opt' -xzf nvim-linux-arm64.tar.gz"

  as_user "ln -sfn '$REAL_HOME/.local/opt/nvim-linux-arm64' '$REAL_HOME/.local/opt/nvim'"
  as_user "ln -sfn '$REAL_HOME/.local/opt/nvim/bin/nvim' '$REAL_HOME/.local/bin/nvim'"

  echo "Neovim installation completed."
}

install_lazygit() {
  echo "Installing lazygit..."

  local tmpdir
  tmpdir="$(mktemp_user)"
  trap 'rm -rf "$tmpdir"' RETURN

  as_user 'mkdir -p "$HOME/.local/bin"'

  local ver
  ver="$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*' || true)"
  if [[ -z "$ver" ]]; then
    echo "Failed to detect lazygit latest version from GitHub API."
    exit 1
  fi

  as_user "cd '$tmpdir' && curl -Lo lazygit.tar.gz 'https://github.com/jesseduffield/lazygit/releases/download/v${ver}/lazygit_${ver}_Linux_arm64.tar.gz'"
  as_user "cd '$tmpdir' && tar -xzf lazygit.tar.gz lazygit"
  as_user "install -m 0755 '$tmpdir/lazygit' '$REAL_HOME/.local/bin/lazygit'"

  echo "Lazygit installation completed."
}

install_zoxide() {
  echo "Installing zoxide..."
  as_user 'curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash'
}

install_oh_my_zsh() {
  echo "Installing Oh-My-Zsh..."

  as_user 'export RUNZSH=no CHSH=no KEEP_ZSHRC=yes; sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

  as_user 'mkdir -p "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"'
  as_user 'test -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"'
  as_user 'test -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"'

  echo "Oh-My-Zsh installation completed."
}

install_tmux_plugins() {
  echo "Setting up Tmux TPM..."

  as_user 'mkdir -p "$HOME/.config/tmux/plugins"'
  as_user 'test -d "$HOME/.config/tmux/plugins/tpm" || git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"'

  if as_user 'test -x "$HOME/.config/tmux/plugins/tpm/scripts/install_plugins.sh"'; then
    as_user '"$HOME/.config/tmux/plugins/tpm/scripts/install_plugins.sh" || true'
  fi

  echo "Tmux TPM setup completed."
}

install_fzf() {
  echo "Installing fzf..."

  as_user 'mkdir -p "$HOME/.config"'
  as_user 'test -d "$HOME/.config/fzf" || git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.config/fzf"'
  as_user 'yes | "$HOME/.config/fzf/install" --key-bindings --completion --update-rc'

  echo "fzf installation completed."
}

set_default_shell_zsh() {
  echo "Setting default shell to zsh for ${REAL_USER}..."
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [[ -z "$zsh_path" ]]; then
    echo "zsh not found after installation."
    exit 1
  fi
  chsh -s "$zsh_path" "$REAL_USER"
}

# ----------------------------
# Main
# ----------------------------
main() {
  print_header

  local INSTALL_DOCKER=false
  local INSTALL_NODEJS=false
  local INSTALL_LAZYGIT=false

  ask_yes_no "Would you like to install Docker?" INSTALL_DOCKER
  ask_yes_no "Would you like to install Node.js and npm?" INSTALL_NODEJS
  ask_yes_no "Would you like to install lazygit?" INSTALL_LAZYGIT

  install_common_dependencies
  install_neovim
  install_zoxide
  install_oh_my_zsh
  install_tmux_plugins
  install_fzf

  if [[ "$INSTALL_DOCKER" == true ]]; then
    install_docker
  else
    echo "Docker installation skipped."
  fi

  if [[ "$INSTALL_NODEJS" == true ]]; then
    install_nodejs
  else
    echo "Node.js and npm installation skipped."
  fi

  if [[ "$INSTALL_LAZYGIT" == true ]]; then
    install_lazygit
  else
    echo "Lazygit installation skipped."
  fi

  set_default_shell_zsh

  print_footer

  echo "User-space tools installed under: ${REAL_HOME}/.local"
  echo "Ensure ${REAL_HOME}/.local/bin is on PATH."
}

main "$@"
