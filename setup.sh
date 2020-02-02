#!/usr/bin/env bash

OS=`uname -s`
EXECUTING_DIR=$(pwd)
PROG_NAME=$0
Downloads="$HOME/Downloads"
TMUX_PATH="$HOME/.tmux"
TMUX_FILE="$HOME/.tmux.conf"
#VIM_VERSION=$(vim --version | head -1 | cut -d ' ' -f 5)
VIM_VERSION=$(vim --version | head -1 | grep -o '[0-9]\.[0-9]')
VIM_DIR_PATH="$HOME/.vim"
VIM_RC_FILE="$HOME/.vimrc"

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
    yum install bc
    yum install ctags git tcl-devel \
        ruby ruby-devel \
        lua lua-devel \
        luajit luajit-devel \
        python python-devel \
        perl perl-devel \
        perl-ExtUtils-ParseXS \
        perl-ExtUtils-XSpp \
        perl-ExtUtils-CBuilder \
        perl-ExtUtils-Embed
}

install_vim() {
    wget -O $Downloads/v8.1.0513.tar.gz  https://github.com/vim/vim/archive/v8.1.0513.tar.gz
    cd $Downloads
    tar -xvzf v8.1.0513.tar.gz

    cd vim-8.1.0513/
    ./configure --prefix=/usr/local --enable-fail-if-missing --with-features=huge --enable-multibyte --enable-python3interp=yes --with-python3-config-dir=/usr/local/python3.7/lib/python3.7/config-3.7m-x86_64-linux-gnu --enable-rubyinterp=yes --enable-perlinterp=yes --enable-luainterp=yes
    make
    make install
    alias vim='/usr/local/bin/vim'
    export EDITOR='/usr/local/bin/vim'
    alias vi="vim"
    cat << EOF | tee -a ~/.bashrc ~/.zshrc
alias vim='/usr/local/bin/vim'
export EDITOR='/usr/local/bin/vim'
alias vi="vim"
EOF

    vim --version
}

install_python3() {
    if ! [ -x "$(command -v python3)" ]; then
        cd $Downloads
        wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tar.xz
        tar xvf Python-3.7.0.tar.xz
        yum -y install gcc gcc-c++ zlib-devel bzip2 bzip2-devel python-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel
        cd Python-3.7.0
        ./configure --prefix=/usr/local/python3.7
        make
        make install
        # ln -s /usr/local/python3.7/bin/python3 /usr/bin/python3
        # ln -s /usr/local/python3.7/bin/pip3 /usr/bin/pip3
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

    ## install vim
    brew uninstall vim
    cd ~/Downloads
    curl -OL "https://github.com/vim/vim/archive/v8.2.0194.tar.gz"
    tar -xvzf v8.2.0194.tar.gz
    cd vim-8.2.0194
    ## NOTICE: make sure your python3 and lua are installed & configured correctly before executing the follow command
    ./configure --prefix=/usr/local --enable-fail-if-missing --with-features=huge --enable-multibyte --enable-python3interp=yes --with-python3-config-dir=/usr/local/Cellar/python/3.7.6_1/Frameworks/Python.framework/Versions/3.7/lib/python3.7/config-3.7m-darwin --enable-rubyinterp=yes --enable-perlinterp=yes --enable-luainterp=yes --with-lua-prefix=/usr/local/Cellar/lua/5.3.5_1
    make && make install
    
    cat << EOF | tee -a ~/.bashrc ~/.zshrc
alias vim='/usr/local/bin/vim'
export EDITOR='/usr/local/bin/vim'
alias vi="vim"
EOF
    
    source ~/.bashrc
    vim --version
    cd
    ln -s $EXECUTING_DIR/.vimrc .vimrc
    source .vimrc
    ## vim-plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +'PlugInstall --sync' +qa
    ## you complete me
    cd ~/.vim/plugged/YouCompleteMe
    brew install go cmake gcc 
    brew tap AdoptOpenJDK/openjdk
    brew cask install adoptopenjdk12
    python3 install.py --ts-completer --java-completer --go-completer --clangd-completer --js-completer
    

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

        # --- python ---
        install_python3

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

        # vim
        if [ $(echo "$VIM_VERSION <= 8.0" | bc -l) ]; then
            # echo "Now remove low version's vim editor.."
            # sudo command deps on vim-minimal
            # $yumdnf remove vim*
            echo "Current Version: vim $VIM_VERSION , now install vim v8.1 ..."
            install_vim
            echo "vim install successfully."

        fi

        if [ ! -d $VIM_PATH ] || [ ! -f $VIM_RC_FILE ]; then
            echo "Now config vim."
        fi

        # autojump
        cd $Downloads
        git clone git://github.com/wting/autojump.git
        cd autojump
        ./install.py
        cat << EOF | tee -a ~/.zshrc ~/.bashrc

# autojump
[[ -s /home/rx7910/.autojump/etc/profile.d/autojump.sh   ]] && source /home/rx7910/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

EOF

        # nvm
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
        cat << EOF | tee -a ~/.zshrc ~/.bashrc

# nvm config
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}"  ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh"  ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

EOF

        ;;
    *)
        exit 1
        ;;
    esac
else
    echo "Other OS: ${OS}"
fi




