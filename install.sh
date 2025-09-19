#!/bin/bash

function brew() {
    if ! command -v brew &> /dev/null; then
        url=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
        /bin/bash -c "$(curl -fsSL $url)"
        export PATH=/opt/homebrew/bin:$PATH
    fi
}

function haskell() {
    if ! command -v ghcup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    fi
}

function mactex() {
    brew list mactex-no-gui &> /dev/null ||
        brew install --cask mactex-no-gui
    eval "$(/usr/libexec/path_helper)"
}

function python() {
    brew list python &> /dev/null ||
        brew install python
}

function rust() {
    if ! command -v rustup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
}

"$@"
