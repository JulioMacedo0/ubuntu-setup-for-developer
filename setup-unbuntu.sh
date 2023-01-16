#!/bin/bash

sudo apt update -y
sudo pt upgrade -y

sudo apt install git curl build-essential -y


sudo snap install postman spotify

sudo snap install node --classic

wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

sudo apt install google-chrome-stable

sudo apt-get install wget gpg

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg

sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

rm -f packages.microsoft.gpg 

sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders


# Install Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# set path Brew

echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/$USER/.profile
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install recomend program by brew
 brew install gcc

# Install FVM
brew tap leoafarias/fvm
brew install fvm

# Configure FVM path
echo 'export PATH="$HOME/.fvm/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc


# Install  flutter stable
fvm install stable

# set global version in fvm
fvm global stable 

# set path for fvm default folder
echo 'export PATH="$PATH:/home/$USER/fvm/default/bin"' >> ~/.profile 


# Install and configure Android Studio
sudo snap install android-studio --classic
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Configure Android Studio path
echo 'export ANDROID_HOME=$HOME/Android/Sdk' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/emulator' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$ANDROID_HOME/platform-tools' >> ~/.bashrc
source ~/.bashrc

