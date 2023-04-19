# SECONDS=0
# caching
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/ztz/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"
# ZSH_THEME="sorin" # "sonicradish" "awesomepanda" "frontcube" "garyblessington" "cloud"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    emoji
    gitignore
    docker-compose
) # dotenv 

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color
export COLORTERM=truecolor

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='gvim'
fi

SUDO_EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias 'dotfiles'="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME" 
alias '?'=duckduckgo
alias '??'=google
alias '???'=bing
alias 'x'=exit
alias 'venv'="venv && source .venv/bin/activate"
alias py="python"
alias xopen="xdg-open"
alias rm="trash-put"
alias set_dot_env="set -o allexport; source .env; set +o allexport"
alias tmux="tmux -2"
alias openwrt-tunnel="ssh -L 127.0.0.1:8080:127.0.0.1:80 root@192.168.1.1"
alias vim="nvim"

# PATH
# https://wiki.archlinux.org/index.php/zsh#Configuring_$PATH
path_dirs=(
    "$HOME/.local/bin"
    "$HOME/.scripts"
    "$HOME/.poetry/bin"
    "$HOME/.gem/ruby/3.0.0/bin"
)

for dir in "${path_dirs[@]}"; do
    if [ -d "$dir" ]; then
        path+=("$dir")
    fi
done

# Remove duplicates in path
typeset -U PATH path
# export to sub-process (make it inherited by child processes)
export PATH

# pipx completions
eval "$(register-python-argcomplete pipx)"

# virtualenv auto activate
function activate_virtualenv ()
{
    if [[ -d .venv ]]; then
        source .venv/bin/activate
    elif [[ -d .hatch ]]; then
        hatch shell
    fi
}

# Vivid - ls terminal colors
# https://github.com/sharkdp/vivid
# https://github.com/sharkdp/vivid/tree/master/themes
export LS_COLORS="$(vivid generate jellybeans)"

# Netkit
# if [ -d "$HOME/netkit" ]; then
#     export NETKIT_HOME=~/netkit
#     export MANPATH=:$NETKIT_HOME/man
#     # export PATH=$NETKIT_HOME/bin:$PATH
#     # path+="$HOME/.poetry/bin"
#     path+="$NETKIT_HOME/bin"
#     . $NETKIT_HOME/bin/netkit_bash_completion

# xterm transparency
[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null

autoload -Uz compinit && compinit

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/home/ztz/.cache/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

# PYENV
# Aponta para odiretorio de instalação do pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# Verifica se o comando pyenv está disponivel no sistema
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init --path)" 
fi

eval "$(pyenv virtualenv-init -)"

# Hook chpwd é executado sempre que o diretório atual é alterado.
chpwd_functions+=(activate_virtualenv)
# duration=$SECONDS
# echo "O arquivo .zshrc levou $duration segundos para carregar."



