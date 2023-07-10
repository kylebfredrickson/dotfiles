#!/bin/bash

function setup_git() {
    ln -sf $HOME/.dotfiles/git/gitconfig $HOME/.gitconfig
}

function setup_zsh() {
    ln -sf $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc
}

function setup_helix() {
    brew list helix &> /dev/null && brew uninstall --cask helix

    ln -sf -f $HOME/.dotfiles/helix $HOME/.config/helix
}

function setup_nvim() {
    brew list nvim &> /dev/null || brew install nvim

    ln -sf -f $1 $HOME/.config/nvim

    rm -rf $HOME/.local/share/nvim
    rm -rf $HOME/.local/state/nvim
}

function setup_vscode() {
    brew list visual-studio-code &> /dev/null ||
        brew install --cask visual-studio-code
}

function setup_warp() {
    brew list warp &> /dev/null || brew install --cask warp
    ln -sf $HOME/.dotfiles/warp $HOME/.warp
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

function install_misc() {
    brew list tree &> /dev/null || brew install tree

    # git symbols
    brew list font-hack-nerd-font &> /dev/null && 
        brew uninstall font-hack-nerd-font
}

function main() {
    if [[ $# -lt 1 ]]; then
        echo "usage: $0 --[helix, nvim, vscode]"
    fi

    for i in "$@"; do
        case $i in
            --helix)
                setup_helix
                setup_warp
                ;;
            --nvim)
                setup_nvim $HOME/.dotfiles/nvim-terminal
                setup_warp
                ;;
            --vscode)
                setup_vscode
                setup_nvim $HOME/.dotfiles/nvim-vscode
                ;;
        esac
    done

    if ! command -v brew &> /dev/null; then
        url=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
        /bin/bash -c "$(curl -fsSL $url)"
    fi

    setup_git
    setup_zsh
    install_misc
    install_haskell
    install_rust
    install_mactex
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
