export EDITOR=nvim
export DOTFILES=$HOME/.dotfiles

export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"

export CLICOLOR=1

# Load config files
for config_file ("$DOTFILES"/zsh/*.zsh(N)); do
    source "$config_file"
done
unset config_file

# plugin manager
export ZPLUG_HOME=$HOME/.config/zplug
if [ ! -d $ZPLUG_HOME ]; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi
source $ZPLUG_HOME/init.zsh

# plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# install missing plugins
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# load plugins
zplug load
