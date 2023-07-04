#!/bin/bash

function setup_git() {
    ln -sf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
}

function setup_nvim() {
    path=$1
    brew list nvim &> /dev/null || brew install nvim
    ln -sf $path $HOME/.config/nvim
}

function setup_terminal_nvim() {
    path=$1
    setup_nvim $path

    # install nvim dependencies
    brew list ripgrep &> /dev/null || brew install ripgrep # telescope
    brew list font-hack-nerd-font &> /dev/null ||
        brew install font-hack-nerd-font # nice symbols
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
        echo "usage: $0 --[all, env, nvim, nvim-terminal, other]"
    fi

    env=false
    nvim=false
    terminal=false
    other=false

    for i in "$@"; do
        case $i in
            --all)
                env=true
                nvim=true
                other=true
                ;;
            --env)
                env=true
                ;;
            --nvim)
                nvim=true
                ;;
            --nvim-terminal)
                terminal=true
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

    if $nvim; then
        setup_nvim $HOME/.dotfiles/nvim
    fi

    if $terminal; then
        setup_terminal_nvim $HOME/.dotfiles/nvim-terminal
    fi

    if $other; then
        install_haskell
        install_rust
        install_mactex
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
