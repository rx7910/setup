#!/usr/bin/env bash

OS=`uname -s`
PROG_NAME=$0
Downloads="$HOME/Downloads"
TMUX_PATH="$HOME/.tmux"
TMUX_FILE="$HOME/.tmux.conf"

# print info

echo "OS=$OS"
echo "PROG_NAME=$PROG_NAME"
echo "\$HOME=$HOME"

# --- sys module ---

curl -V

prepare() {
   if [ ! -x $HOME/Downloads ];then
       mkdir $HOME/Downloads
   fi
}


if [ ${OS} == "Darwin"  ];then
    prepare
    # --- git ----
    if ! [ -x "$(command -v git)" ]; then
        brew install git
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
    source /etc/os-release
    echo "Current os release distribution is $ID"
    prepare
    case $ID in
    debian|ubuntu|devuan)
        apt-get install git
        ;;
    centos|fedora|rhel)
        yumdnf="yum"
        # if test "$(echo "$VERSION_ID >= 22" | bc)" -ne 0;
        # then
        # yumdnf="dnf"
        # fi
        if ! [ -x "$(command -v gcc)" ];then
            $yumdnf install gcc kernel-devel make
        fi

        # --- git ----
        if ! [ -x "$(command -v git)" ]; then
            echo "Now Install Git.."
            $yumdnf install -y git
            echo "Git Install Finished."
        fi

        # wget
        if ! [ -x "$(command -v wget)" ]; then
            echo "Now Install wget.."
            $yumdnf install wget 
            echo "wget Install Finished."
        fi

        # --- zsh ----
        if [ ! -e "/usr/bin/zsh" ]; then
            echo "Now install zsh..."
            yum -y install zsh
            chsh -s /bin/zsh
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
            echo "zsh Install Finished."
        fi

        # --- tmux  ---
        if [ ! -x "$(command -v tmux)" ];then
            echo "Now Install Tmux..."
            $yumdnf install gcc kernel-devel make ncurses-devel

            # libevent 2.1.8
            wget -O $Downloads/libevent-2.1.8-stable.tar.gz  https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
            cd $Downloads
            tar xzvf libevent-2.1.8-stable.tar.gz
            cd libevent-2.1.8-stable
            ./configure --prefix=/usr/local
            make
            make install

            if ! [ -d $Downloads/tmux ]; then
                cd $Downloads
                curl -LOk https://github.com/tmux/tmux/releases/download/2.8/tmux-2.8.tar.gz
                tar -xf tmux-2.8.tar.gz
                cd tmux-2.8
                LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
                make
                make install
            fi

            echo "Tmux Install Finished."
            tmux -V
        fi

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
        ;;
    *)
        exit 1
        ;;
    esac
else
    echo "Other OS: ${OS}"
fi




