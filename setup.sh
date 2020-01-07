#!/usr/bin/env bash

# --- sys module ---

curl -V

# --- zsh ----

if [ ! -e "/usr/bin/zsh" ]; then
    echo "Now install zsh..."
    sudo yum -y install zsh
    chsh -s /bin/zsh
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# --- tmux config ---

if [ ! -e "~/.tmux.conf" ] || [ ! -e "~/.tmux" ]; then
    echo "Now remove \.tmux config file..."
    rm -f ~/.tmux.conf
    echo "Now remove \.tmux dir..."
    rm -rf ~/.tmux

    cd
    git clone https://github.com/gpakosz/.tmux.git
    ln -s -f .tmux/.tmux.conf
    cp .tmux/.tmux.conf.local .
fi

