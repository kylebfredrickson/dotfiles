#!/bin/bash

function setup_git() {
    ln -sf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
}

function setup_zsh() {
    ln -sf $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc
}

function setup_vim() {
    ln -sf $HOME/.dotfiles/misc/vimrc $HOME/.vimrc
}

function setup_vscode() {
    brew list visual-studio-code &> /dev/null ||
        brew install --cask visual-studio-code
}

function install_haskell() {
    if ! command -v ghcup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    fi
}

function install_mactex() {
    brew list mactex-no-gui &> /dev/null || brew install --cask mactex-no-gui
    eval "$(/usr/libexec/path_helper)"
}

function install_rust() {
    if ! command -v rustup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
}

function install_misc() {
    # install_haskell
    install_mactex
    install_rust

    brew list tree &> /dev/null || brew install tree
}

function main() {
    if ! command -v brew &> /dev/null; then
        url=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
        /bin/bash -c "$(curl -fsSL $url)"
    fi

    setup_git
    setup_zsh

    setup_vim
    setup_vscode

    install_misc

}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
