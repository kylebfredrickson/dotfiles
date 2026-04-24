SSH_TYPE=ed25519

.PHONY=all brew setup prog app backup

all: brew setup prog app
	defaults write -g ApplePressAndHoldEnabled -bool false

brew:
	/bin/bash install.sh brew

setup: $(HOME)/.gitconfig $(HOME)/.ssh/id_$(SSH_TYPE) $(HOME)/.vimrc $(HOME)/.zshrc

$(HOME)/.gitconfig:
	ln -sf $(HOME)/.dotfiles/misc/gitconfig $(HOME)/.gitconfig

$(HOME)/.ssh/id_$(SSH_TYPE):
	ssh-keygen -t $(SSH_TYPE) -f $(HOME)/.ssh/id_$(SSH_TYPE)

$(HOME)/.vimrc:
	ln -sf $(HOME)/.dotfiles/misc/vimrc $(HOME)/.vimrc

$(HOME)/.zshrc:
	ln -sf $(HOME)/.dotfiles/zsh/zshrc $(HOME)/.zshrc
	/bin/zsh $(HOME)/.zshrc

lang:
	/bin/bash install.sh python
	/bin/bash install.sh rust
    /bin/bash install.sh claude

app:
	brew install --cask docker
	brew install --cask omnigraffle
	brew install --cask visual-studio-code
	brew install --cask whatsapp
	brew install --cask zoom

backup:
	echo backup
	# documents
	# developer
	# TV
	# Music
	# Photos
	# Books
