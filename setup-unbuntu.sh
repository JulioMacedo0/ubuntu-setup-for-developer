#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Sem cor (reset)

function print_status() {
    status=$1
    message=$2

    if [ $status -eq 0 ]; then
        echo -e "${RED}[FAILED]${NC} $message"
    else
        echo -e "${GREEN}[SUCCESS]${NC} $message"
    fi
}

function install_package() {
    package=$1
    dpkg -s $package &> /dev/null
    if [ $? -ne 0 ]; then
        sudo apt install $package -y
        print_status 1 "Package $package installed"
    else
        print_status 0 "Package $package is already installed."
    fi
}

function install_snap() {
    package=$1
 
        sudo snap install $package
    
}

function install_google_chrome() {
    if ! command -v google-chrome &> /dev/null; then
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
        sudo apt update
        sudo apt install google-chrome-stable -y
        print_status 1 "Package Google Chrome installed."
    else
        print_status 0 "Google Chrome is already installed."
    fi
}

function install_vscode() {
    if ! command -v code &> /dev/null; then
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        rm -f packages.microsoft.gpg
        sudo apt update
        sudo apt install apt-transport-https -y
        sudo apt install code -y
        print_status 1 "Package VsCode installed."
    else
        print_status 0 "Visual Studio Code is already installed."
    fi
}

function install_brew() {
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/$USER/.profile
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        print_status 1 "Package Homebrew installed."
    else
        print_status 0 "Homebrew is already installed."
    fi
}

function install_program() {
    program=$1
    if ! brew list $program &> /dev/null; then
        brew install $program
        print_status 1 "Package $program installed."
    else
        print_status 0 "Program $program is already installed."
    fi
}

function install_fvm() {
    if ! command -v fvm &> /dev/null; then
        brew tap leoafarias/fvm
        brew install fvm
        if ! grep -q 'fvm/bin' ~/.bashrc; then
            echo 'export PATH="$HOME/.fvm/bin:$PATH"' >> ~/.bashrc
            source ~/.bashrc
            print_status 1 "Package fvm installed."
        else
            print_status 0 "FVM is already installed."
        fi
    fi
}

function install_flutter() {
    if [ ! -d "$HOME/fvm/default" ]; then
        fvm install stable
        fvm global stable
        if ! grep -q '/home/$USER/fvm/default/bin' ~/.profile; then
            echo 'export PATH="$PATH:/home/$USER/fvm/default/bin"' >> ~/.profile
            print_status 1 "Package Flutter installed."
        else
            print_status 0 "Flutter is already installed."
        fi
    fi
}

function install_slidy() {
    if ! command -v slidy &> /dev/null; then
        fvm dart pub global activate slidy
        if ! grep -q '.pub-cache/bin' ~/.bashrc; then
            echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.bashrc
            print_status 1 "Package Slidy installed."
        else
            print_status 0 "Slidy is already installed."
        fi
    fi
}

function configure_android_studio() {
    if ! command -v studio.sh &> /dev/null; then
        sudo snap install android-studio --classic
       
        export ANDROID_HOME=$HOME/Android/Sdk
        export PATH=$PATH:$ANDROID_HOME/emulator
        export PATH=$PATH:$ANDROID_HOME/tools
        export PATH=$PATH:$ANDROID_HOME/tools/bin
        export PATH=$PATH:$ANDROID_HOME/platform-tools
        if ! grep -q 'ANDROID_HOME=$HOME/Android/Sdk' ~/.bashrc; then
            echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
            echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
            echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.bashrc
            echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.bashrc
            echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
            source ~/.bashrc
            print_status 1 "Environment variables Android Studio installed."
        else
            print_status 0 "Android Studio environment variables are already set."
        fi
    else
        print_status 0 "Android Studio is already installed."
    fi
}

function install_nvm() {
    if ! command -v nvm &> /dev/null; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        if ! grep -q 'nvm.sh' ~/.bashrc; then
            echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
            echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
            echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
            source ~/.bashrc
            print_status 1 "Package NVM installed."
        else
            print_status 0 "NVM is already installed."
        fi
    fi
}

function install_node() {
    if ! command -v node &> /dev/null; then
        nvm install 18.17.0
        print_status 1 "Latest version of Node.js installed."
    else
        print_status 0 "Node.js is already installed."
    fi
}

function install_nest_cli() {
    if ! command -v nest &> /dev/null; then
        npm install -g @nestjs/cli
        print_status 1 "Latest version of NestJS CLI installed."
    else
        print_status 0 "NestJS CLI is already installed."
    fi
}

function install_docker() {
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        print_status 1 "Docker installed."
        sudo usermod -aG docker $USER
        print_status 1 "Created docker group"
        rm get-docker.sh
       
    else
        print_status 0 "Docker is already installed."
    fi
}


# Update apt packages
sudo apt update -y
sudo apt upgrade -y

# Install required packages
install_package git
install_package curl
install_package build-essential
install_package fonts-firacode

# Install snap packages
install_snap postman
install_snap spotify

# Install Google Chrome
install_google_chrome

# Install Visual Studio Code
install_vscode

# Install Brew
install_brew

# Install recommended programs by Brew
install_program gcc

# Install FVM
install_fvm

# Install Flutter
install_flutter

# Install Slidy
install_slidy

# Configure Android Studio
configure_android_studio

# Install NVM
install_nvm

# Install latest Node.js
install_node

# Install latest NestJS CLI
install_nest_cli

# Install Docker
install_docker