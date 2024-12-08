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

# Prompt for installation of Starship
ask_for_starship() {
    read -p "Would you like to install Starship? (y/n): " response
    case "$response" in
        [Yy]* ) INSTALL_STARSHIP=true ;;
        [Nn]* ) INSTALL_STARSHIP=false ;;
        * ) echo "Please answer with 'y' or 'n'."; ask_for_starship ;;
    esac
}

# Check if script is run with root privileges
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root or with sudo" 
        exit 1
    fi
}

# Install Docker and user to docker group
install_docker() {
    echo "Installing Docker..."

    # Add Docker's official GPG key:
    sudo apt install -y ca-certificates curl

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add user to docker group
    sudo groupadd docker
    sudo usermod -aG docker $USER

    # Apply new group membership
    newgrp docker

    echo "Docker installation completed!"
}

# Install Node.js and npm
install_nodejs() {
    echo "Installing Node.js and npm..."

    # Install Node.js (LTS version) and npm
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs

    # Check installation
    node -v
    npm -v

    echo "Node.js and npm installation completed!"
}

# Install common dependencies
install_common_dependencies() {
    echo "Updating system and installing common dependencies..."
    sudo apt update
    sudo apt install -y tmux git rsync zsh snapd
}

# Install Neovim via snap for the latest version
install_neovim() {
    echo "Installing Neovim..."
    sudo snap install --classic nvim
}

# Install Oh-My-Zsh
install_oh_my_zsh() {
    echo "Installing Oh-My-Zsh..."
    yes | sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chsh -s "$(which zsh)"
}

# Install tmux plugins manager
install_tmux_plugins() {
    echo "Setting up Tmux TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    ~/.config/tmux/plugins/tpm/scripts/install_plugins.sh
}

# Install fzf
install_fzf() {
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.config/fzf
    yes | ~/.config/fzf/install
}

# Install Starship prompt
install_starship() {
    echo "Installing Starship..."
    sh -c "$(wget -O- https://starship.rs/install.sh)"
}

# Main script logic
main() {
    print_header
    check_root

    # Ask the user if they want to install Docker
    ask_for_docker

    # Ask the user if they want to install Node.js and npm
    ask_for_nodejs

    # Ask the user if they want to install Starship
    ask_for_starship

    # Install common dependencies and tools
    install_common_dependencies

    # Install Neovim, Oh-My-Zsh, Tmux TPM, fzf, Starship
    install_neovim
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

    # Conditionally install Starship if the user wants it
    if [ "$INSTALL_NODEJS" = true ]; then
        install_starship
    else
        echo "Starship installation skipped."
    fi

    print_footer
}

# Run the main function
main
