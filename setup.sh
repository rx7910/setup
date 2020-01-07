#!/usr/bin/env bash

OS=`uname -s`
PROG_NAME=$0
TMUX_PATH="$HOME/.tmux"
TMUX_FILE="$HOME/.tmux.conf"

# print info

echo "OS=$OS"
echo "PROG_NAME=$PROG_NAME"

# --- sys module ---

curl -V


if [ ${OS} == "Darwin"  ];then
    # --- git ----
    if ! [ -x "$(command -v git)" ]; then
        sudo brew install git
    fi

    if [ ! -e $HOME/.iterm2 ]; then
        echo "iTerm2 Not Found, Now Downloading..."
        curl -O "https://iterm2.com/downloads/stable/iTerm2-3_3_7.zip"
        echo "iTerm2 Download Finished"
    fi

    if [ ! -e $HOME/.oh-my-zsh ]; then 
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

elif [ ${OS} == "Linux"  ];then
    # --- git ----
    if ! [ -x "$(command -v git)" ]; then
        source /etc/os-release
        case $ID in
        debian|ubuntu|devuan)
            sudo apt-get install git
            ;;
        centos|fedora|rhel)
            yumdnf="yum"
            if test "$(echo "$VERSION_ID >= 22" | bc)" -ne 0;
            then
            yumdnf="dnf"
            fi
            sudo $yumdnf install -y git
            ;;
        *)
            exit 1
            ;;
        esac
    fi

    # --- zsh ----
    if [ ! -e "/usr/bin/zsh" ]; then
        echo "Now install zsh..."
        sudo yum -y install zsh
        chsh -s /bin/zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi

    # --- tmux config ---
    if [ ! -e $TMUX_FILE ] || [ ! -d $TMUX_PATH ]; then
        echo "Now remove \.tmux config file..."
        rm -f ~/.tmux.conf
        echo "Now remove \.tmux dir..."
        rm -rf ~/.tmux

        cd
        git clone https://github.com/gpakosz/.tmux.git
        ln -s -f .tmux/.tmux.conf
        cp .tmux/.tmux.conf.local .
    fi

else
    echo "Other OS: ${OS}"
fi




