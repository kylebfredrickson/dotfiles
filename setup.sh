#!/bin/bash

function setup_git() {
    ln -sf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
}

function setup_nvim() {
    path=$1
    brew list nvim &> /dev/null || brew install nvim
    rm $HOME/.config/nvim
    rm -rf $HOME/.local/share/nvim
    rm -rf $HOME/.local/state/nvim
    ln -sf $path $HOME/.config/nvim
}

function install_nvim_deps() {
    brew list ripgrep &> /dev/null || brew install ripgrep # telescope
    brew list font-hack-nerd-font &> /dev/null || brew install font-hack-nerd-font # nice symbols
    brew list node &> /dev/null || brew install node # pyright
}

function setup_zsh() {
    ln -sf $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc
}

function install_mactex() {
    brew list mactex-no-gui &> /dev/null || brew install --cask mactex-no-gui
    eval "$(/usr/libexec/path_helper)"
}

function install_haskell() {
    if ! command -v ghcup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    fi
}

function install_rust() {
    if ! command -v rustup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
}

function main() {
    if [[ $# -lt 1 ]]; then
        echo "usage: $0 --[all, env, vscode, nvim, other]"
    fi

    env=false
    vscode=false
    nvim=false
    other=false

    for i in "$@"; do
        case $i in
            --all)
                env=true
                vscode=true
                other=true
                ;;
            --env)
                env=true
                ;;
            --vscode)
                vscode=true
                ;;
            --nvim)
                nvim=true
                ;;
            --other)
                other=true
                ;;
        esac
    done

    if ! command -v brew &> /dev/null; then
        url=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
        /bin/bash -c "$(curl -fsSL $url)"
    fi

    if $env; then
        setup_git
        setup_zsh
    fi

    if $vscode; then
        setup_nvim $HOME/.dotfiles/nvim-vscode
    fi

    if $nvim; then
        setup_nvim $HOME/.dotfiles/nvim-terminal
        install_nvim_deps
    fi

    if $other; then
        install_haskell
        install_rust
        install_mactex
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
