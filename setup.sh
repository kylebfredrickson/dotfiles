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
    brew list warp &> /dev/null || brew install --cask warp
    ln -sf $HOME/.dotfiles/warp $HOME/.warp

    brew list ripgrep &> /dev/null || brew install ripgrep # telescope
    brew list font-hack-nerd-font &> /dev/null ||
        brew install font-hack-nerd-font # nice symbols
    brew list node &> /dev/null || brew install node # pyright
}

function uninstall_nvim_deps() {
    brew list warp &> /dev/null && brew uninstall --cask warp
    rm $HOME/.warp

    brew list ripgrep &> /dev/null && brew uninstall ripgrep # telescope
    brew list font-hack-nerd-font &> /dev/null && 
        brew uninstall font-hack-nerd-font # nice symbols
    brew list node &> /dev/null && brew uninstall node # pyright
}

function setup_zsh() {
    ln -sf $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc
}

function setup_vscode() {
    brew list visual-studio-code &> /dev/null ||
        brew install --cask visual-studio-code
}

function setup_helix() {
    brew list helix &> /dev/null && brew uninstall --cask helix

    ln -sf $HOME/.dotfiles/helix $HOME/.config/helix

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
}

function main() {
    if [[ $# -lt 1 ]]; then
        echo "usage: $0 --[all, env, vscode, nvim, helix, other]"
    fi

    env=false
    vscode=false
    nvim=false
    helix=false
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
            --helix)
                helix=true
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
        setup_vscode
        setup_nvim $HOME/.dotfiles/nvim-vscode
        uninstall_nvim_deps
    fi

    if $nvim; then
        setup_nvim $HOME/.dotfiles/nvim-terminal
        install_nvim_deps
    fi

    if $helix; then
        setup_helix
    fi

    if $other; then
        install_haskell
        install_rust
        install_mactex
        install_misc
    fi
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
