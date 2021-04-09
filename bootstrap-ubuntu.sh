#!/bin/bash
USER_HOME=$(eval echo ~${SUDO_USER})

echo "Enter git email"
read GIT_EMAIL
echo "Enter git username"
read GIT_USERNAME

echo "Update and upgrade and install some basic applications"
apt-get -y update && apt-get -y upgrade && apt-get install -y htop \
  terminator \
  vim-gtk3 \
  nodejs \
  npm \
  git \
  indicator-multiload \
  flameshot \
  emacs \
  xclip \
  ncdu \
  bat \
  tree \
  curl

echo "Installing python"
add-apt-repository -y ppa:deadsnakes/ppa
apt-get update
apt-get install -y python3.8-dev python3-pip

echo "Installing ulauncher"
add-apt-repository -y ppa:agornostal/ulauncher
apt-get update && apt-get install -y ulauncher
# need to install system management direct extension from https://github.com/episode6/ulauncher-system-management-direct

echo "Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -sSf | sh -s -- -y
source $USER_HOME/.cargo/env
export PATH=$PATH:$USER_HOME/.cargo/bin
chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.cargo/bin

echo "Installing insomnia rest client"
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
    | tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
    | apt-key add -
apt-get -y update && apt-get install -y insomnia

echo "Installing golang"
wget https://golang.org/dl/go1.16.3.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz

echo "Installing Goland"
wget https://download.jetbrains.com/go/goland-2020.3.4.tar.gz
tar xzf goland-*.tar.gz -C /opt/

echo "Installing visualstudio code"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] \
  https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
apt-get install -y apt-transport-https
apt-get -y update
apt-get install -y code

echo "Installing visualstudio code plugins"
chown -R $SUDO_USER:$SUDO_USER $USER_HOME/vscode
code --install-extension ms-python.python
code --install-extension vscodevim.vim
code --install-extension ms-azuretools.vscode-docker
code --install-extension golang.go
code --install-extension rust-lang.rust
code --install-extension redhat.vscode-yaml
code --install-extension coenraads.bracket-pair-colorizer
code --install-extension streetsidesoftware.code-spell-checker

echo "Installing vim-plug"
curl -fLo $USER_HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
chown -R $SUDO_USER:$SUDO_USER $USER_HOME/.vim
vim +PlugInstall +qall +silent

echo "Installing zsh and other zsh plugins"
apt-get install -y zsh

echo "Changing default shell to zsh instead of bash"
chsh -s $(which zsh)
sed -i "s|$USER_HOME:/bin/bash|$USER_HOME:/bin/zsh|" /etc/passwd

echo "Installing oh my zsh"
export ZSH=$USER_HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chown -R $SUDO_USER:$SUDO_USER .oh-my-zsh

echo "Installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
chown -R $SUDO_USER:$SUDO_USER .oh-my-zsh

echo "Installing zsh-syntax-highlighting"
apt-get install -y zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $USER_HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
# change owner of oh-my-zsh folder
chown -R $SUDO_USER:$SUDO_USER .oh-my-zsh

echo "Installing flatpak"
apt-get install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing flatpak applications"
flatpak install -y flathub com.github.calo001.fondo
flatpak install -y flathub io.dbeaver.DBeaverCommunity
flatpak install -y flathub org.remmina.Remmina
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub com.bitwarden.desktop

echo "Installing brave browser"
apt-get install -y apt-transport-https curl
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] \
  https://brave-browser-apt-release.s3.brave.com/ stable main"| tee /etc/apt/sources.list.d/brave-browser-release.list
apt-get -y update && apt-get install -y brave-browser

echo "Installing docker"
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -y update && apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Post docker installation"
groupadd docker
usermod -aG docker $SUDO_USER
service docker restart
# need to logout after add user to docker group

echo "Installing docker-compose"
curl -L "https://github.com/docker/compose/releases/download/1.29.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Git setup"
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USERNAME

echo "Replace zshrc, vimrc, bashrc"
git clone https://github.com/jittapont/dotfiles.git
chown -R $SUDO_USER:$SUDO_USER $USER_HOME/dotfiles
rm .bashrc .vimrc .zshrc
ln -s $USER_HOME/dotfiles/.vimrc $USER_HOME/.vimrc
ln -s $USER_HOME/dotfiles/.bashrc $USER_HOME/.bashrc
ln -s $USER_HOME/dotfiles/.zshrc $USER_HOME/.zshrc
