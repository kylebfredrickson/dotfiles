# Dotfiles
My dotfiles for macOS.

### Running
```shell
if ! xcode-select -p &> /dev/null; then
    xcode-select --install
    while ! xcode-select -p &> /dev/null; do sleep 1; done
fi

if [ ! -d ~/.dotfiles ]; then
    git clone https://github.com/kylebfredrickson/dotfiles.git ~/.dotfiles
fi

/bin/bash ~/.dotfiles/setup.sh
```
