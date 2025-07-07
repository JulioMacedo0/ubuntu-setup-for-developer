#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

function print_status() {
    status=$1
    message=$2

    if [ $status -eq 0 ]; then
        echo -e "${GREEN}[SUCCESS]${NC} $message"
    else
        echo -e "${RED}[FAILED]${NC} $message"
    fi
}

function install_package() {
    package=$1
    dpkg -s $package &> /dev/null
    if [ $? -ne 0 ]; then
        sudo apt install $package -y
        print_status $? "Package $package installed"
    else
        print_status 0 "Package $package is already installed."
    fi
}

function install_java() {
    if ! command -v java &> /dev/null; then
        sudo apt install openjdk-17-jdk -y
        echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' >> ~/.bashrc
        echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
        source ~/.bashrc
        print_status 1 "OpenJDK 17 installed and JAVA_HOME set."
    else
        print_status 0 "Java is already installed."
    fi
}

function install_snap() {
    package=$1
    if ! snap list | grep -q "^$package "; then
        sudo snap install $package
        print_status $? "Snap package $package installed."
    else
        print_status 0 "Snap package $package is already installed."
    fi
}

function install_java() {
    if ! command -v java &> /dev/null; then
        sudo apt install openjdk-17-jdk -y
        echo 'export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"' >> ~/.bashrc
        echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
        export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
        export PATH=$JAVA_HOME/bin:$PATH
        print_status $? "OpenJDK 17 installed and JAVA_HOME set."
    else
        print_status 0 "Java is already installed."
    fi
}

function install_google_chrome() {
    if ! command -v google-chrome &> /dev/null; then
        wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
        sudo apt update
        sudo apt install google-chrome-stable -y
        print_status $? "Google Chrome installed."
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
        print_status $? "Visual Studio Code installed."
    else
        print_status 0 "Visual Studio Code is already installed."
    fi
}

function install_brew() {
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        print_status $? "Homebrew installed."
    else
        print_status 0 "Homebrew is already installed."
    fi
}

function install_program() {
    program=$1
    if ! brew list $program &> /dev/null; then
        brew install $program
        print_status $? "Package $program installed."
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
            export PATH="$HOME/.fvm/bin:$PATH"
            print_status $? "FVM installed and PATH set."
        fi
    else
        print_status 0 "FVM is already installed."
    fi
}

function install_flutter() {
    if [ ! -d "$HOME/fvm/default" ]; then
        fvm install stable
        fvm global stable
        if ! grep -q "$HOME/fvm/default/bin" ~/.profile; then
            echo 'export PATH="$PATH:'"$HOME/fvm/default/bin"'"' >> ~/.profile
            export PATH="$PATH:$HOME/fvm/default/bin"
            print_status $? "Flutter installed and PATH set."
        fi
    else
        print_status 0 "Flutter is already installed."
    fi
}

function install_slidy() {
    if ! command -v slidy &> /dev/null; then
        fvm dart pub global activate slidy
        if ! grep -q '.pub-cache/bin' ~/.bashrc; then
            echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.bashrc
            export PATH="$PATH:$HOME/.pub-cache/bin"
        fi
        print_status $? "Slidy installed."
    else
        print_status 0 "Slidy is already installed."
    fi
}

function configure_android_studio() {
    if ! snap list | grep -q "^android-studio "; then
        sudo snap install android-studio --classic
        print_status $? "Android Studio installed."
    else
        print_status 0 "Android Studio is already installed."
    fi

    if ! grep -q 'ANDROID_HOME=$HOME/Android/Sdk' ~/.bashrc; then
        echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
        echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
        echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.bashrc
        echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.bashrc
        echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
        export ANDROID_HOME=$HOME/Android/Sdk
        export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
        print_status $? "Android Studio environment variables set."
    else
        print_status 0 "Android Studio environment variables are already set."
    fi
}

function install_nvm() {
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
        echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        print_status $? "NVM installed."
    else
        print_status 0 "NVM is already installed."
    fi
}

function install_node() {
    if ! command -v node &> /dev/null; then
        nvm install 18.17.0
        print_status $? "Node.js installed."
    else
        print_status 0 "Node.js is already installed."
    fi
}

function install_nest_cli() {
    if ! command -v nest &> /dev/null; then
        npm install -g @nestjs/cli
        print_status $? "NestJS CLI installed."
    else
        print_status 0 "NestJS CLI is already installed."
    fi
}

function install_docker() {
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        print_status $? "Docker installed and user added to docker group."
    else
        print_status 0 "Docker is already installed."
    fi
}

# ---- EXECUÇÃO ----

sudo apt update -y && sudo apt upgrade -y

install_package git
install_package curl
install_package build-essential
install_package fonts-firacode

install_java
install_snap postman
install_snap spotify
install_google_chrome
install_vscode
install_brew
install_program gcc

install_java
install_fvm
install_flutter
install_slidy
configure_android_studio
install_nvm
install_node
install_nest_cli
install_docker

echo -e "\n${GREEN}✅ Script finalizado. Reinicie o terminal ou execute 'source ~/.bashrc' para aplicar todas as variáveis de ambiente.${NC}"
