# Caching autocompletion
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Lines configured by zsh-newuser-install
# `history -p` limpa o histórico de comandos
HISTFILE=~/.histfile
# Número maximo de comandos que serão mantidos ni histórico
HISTSIZE=10000
# Define o número máximo de comandos que serão salvos no histórico 
SAVEHIST=10000

setopt autocd beep extendedglob nomatch notify
# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color
export COLORTERM=truecolor
# habilita o modo vi
# bindkey -v
# habilita o modo emacs
bindkey -e
# The following lines were added by compinstall
zstyle :compinstall filename '/home/ztz/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

# Aliases
alias x=exit
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias set_dot_env="set -o allexport; source .env; set +o allexport"
alias py="python"
alias vim="nvim"
alias history="history -t '%d/%m/%y %H:%M'"

# PATH
path_dirs=(
    "$HOME/.local/bin"
    "$HOME/.scripts"
)
for dir in "${path_dirs[@]}"; do
    if [ -d "$dir" ]; then
        path+=("$dir")
    fi
done

# Remove caminhos duplicados no PATH
typeset -U PATH path
# exporta para sub-process (make it inherited by child processes)
export PATH

# Prompt
# vcs_info: informações do repositório git
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
# %f e %F são codigos de escape, usados para definir cor
# %n - nome de usuário
# %m - nome do computador
# %d e %~ - CWD
PROMPT='%F{cyan}[ %f%F{cyan}%*%f %F{cyan}%n@%m ] %f%F{blue}%d%f %F{red}${vcs_info_msg_0_}%f$ '

# Python virtualenv auto activate
function activate_virtualenv () {
    if [[ -d .venv ]]; then
        source .venv/bin/activate
    elif [[ -d .hatch ]]; then
        hatch shell
    fi
}
# Define hooks
# Hook precmd: É executado antes de qualquer comando
precmd() {
    vcs_info
}
# Hook chpwd: É executado ao alterar o diretório corrente
chpwd() {
    activate_virtualenv
}

# Fix: Mapeamento de teclas de seta, para corrigir a
# a funcionalidade ao `CTRL + LEFT` ou `CTRL + RIGHT`.
# Com essa correção, o terminal irá interpretar corretamente
# tais teclas, desta forma, caracteres como ;5D não
# serão imprimidos na tela ao precionar alguma dessa
# combinações de teclas.
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5A' history-beginning-search-backward
bindkey '^[[1;5B' history-beginning-search-forward

# Setup para sessões remotas SSH
if [[ -n "$SSH_CONNECTION" ]]; then
    # Editor preferido
    export EDITOR='nvim'
fi
