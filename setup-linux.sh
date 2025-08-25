#!/bin/bash

# Print script header
print_header() {
    echo "------------------------------------"
    echo "    Installing Development Tools    "
    echo "------------------------------------"
}

# Print script footer
print_footer() {
    echo "------------------------------------"
    echo "       Installation Completed       "
    echo "------------------------------------"
}

# Prompt for installation of Docker
ask_for_docker() {
    read -p "Would you like to install Docker? (y/n): " response
    case "$response" in
        [Yy]* ) INSTALL_DOCKER=true ;;
        [Nn]* ) INSTALL_DOCKER=false ;;
        * ) echo "Please answer with 'y' or 'n'."; ask_for_docker ;;
    esac
}

# Prompt for installation of Node.js and npm
ask_for_nodejs() {
    read -p "Would you like to install Node.js and npm? (y/n): " response
    case "$response" in
        [Yy]* ) INSTALL_NODEJS=true ;;
        [Nn]* ) INSTALL_NODEJS=false ;;
        * ) echo "Please answer with 'y' or 'n'."; ask_for_nodejs ;;
    esac
}

# Prompt for installation of lazygit
ask_for_lazygit() {
    read -p "Would you like to install lazygit? (y/n): " response
    case "$response" in
        [Yy]* ) INSTALL_LAZYGIT=true ;;
        [Nn]* ) INSTALL_LAZYGIT=false ;;
        * ) echo "Please answer with 'y' or 'n'."; ask_for_lazygit ;;
    esac
}

# Install Docker and user to docker group
install_docker() {
    echo "Installing Docker..."

    # Add Docker's official GPG key:
    sudo apt-get install -y ca-certificates curl

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add user to docker group
    sudo usermod -aG docker $USER

    echo "Docker installation completed!"
}

# Install Node.js and npm
install_nodejs() {
    echo "Installing Node.js and npm..."
    # Install Node.js (LTS version) and npm
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    # Check installation
    node -v
    npm -v
    echo "Node.js and npm installation completed!"
}

# Install common dependencies
install_common_dependencies() {
    echo "Updating system and installing common dependencies..."
    sudo apt-get update
    sudo apt-get install -y tmux git rsync zsh
}

# Install Neovim
install_neovim() {
    echo "Installing Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
    INSTALL_DIR="/home/$USER/.local/opt"
    mkdir -p $INSTALL_DIR
    sudo rm -rf $INSTALL_DIR/nvim
    sudo tar -C $INSTALL_DIR -xzf nvim-linux-arm64.tar.gz
    rm nvim-linux-arm64.tar.gz
    echo "Neovim installation completed!"
}

# Install lazygit
install_lazygit() {
    echo "Installing lazygit..."
    INSTALL_DIR="/home/$USER/.local/bin"
    mkdir -p $INSTALL_DIR
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \
    grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_arm64.tar.gz"
    tar -C $INSTALL_DIR -xzf lazygit.tar.gz lazygit
    rm lazygit.tar.gz
    echo "Lazygit installation completed!"
}

# Install zoxide
install_zoxide() {
    echo "Installing zoxide..."
    sh -c "$(wget -O- https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh)"
}

# Install Oh-My-Zsh
install_oh_my_zsh() {
    echo "Installing Oh-My-Zsh..."
    yes | sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    # Install zsh plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "Oh-My-Zsh installation completed!"
}

# Install tmux plugins manager
install_tmux_plugins() {
    echo "Setting up Tmux TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    ~/.config/tmux/plugins/tpm/scripts/install_plugins.sh
    echo "Tmux TPM setup completed!"
}

# Install fzf
install_fzf() {
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.config/fzf
    yes | ~/.config/fzf/install
    echo "fzf installation completed!"
}

# Main script logic
main() {
    print_header

    # Ask the user if they want to install Docker
    ask_for_docker

    # Ask the user if they want to install Node.js and npm
    ask_for_nodejs

    # Ask the user if they want to install lazygit
    ask_for_lazygit

    # Install common dependencies and tools
    install_common_dependencies

    # Install Neovim, Oh-My-Zsh, Tmux TPM, fzf, Starship
    install_neovim
    install_zoxide
    install_oh_my_zsh
    install_tmux_plugins
    install_fzf

    # Conditionally install Docker if the user wants it
    if [ "$INSTALL_DOCKER" = true ]; then
        install_docker
    else
        echo "Docker installation skipped."
    fi

    # Conditionally install Node.js and npm if the user wants it
    if [ "$INSTALL_NODEJS" = true ]; then
        install_nodejs
    else
        echo "Node.js and npm installation skipped."
    fi

    # Conditionally install lazygit if the user wants it
    if [ "$INSTALL_LAZYGIT" = true ]; then
        install_lazygit
    else
        echo "Lazygit installation skipped."
    fi

    # Change the shell to zsh
    chsh -s "$(which zsh)"

    print_footer
}

# Run the main function
main
