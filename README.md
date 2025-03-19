# Dotfiles
My dotfiles for macOS.

### Running
```shell
if ! xcode-select -p &> /dev/null; then
    xcode-select --install
    while ! xcode-select -p &> /dev/null; do sleep 10; done
fi

if [ -d ~/.dotfiles ]; then
    echo "Dotfiles already exist. Pulling latest changes..."
    git -C ~/.dotfiles pull
else
    echo "Cloning dotfiles..."
    git clone git@github.com:kylebfredrickson/dotfiles.git ~/.dotfiles
fi

/bin/bash ~/.dotfiles/setup.sh
```
