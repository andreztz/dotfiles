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
alias history="history -t '%d/%m/%y %H:%M' 1"

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

# TODO: source ~/.zkbd/mapping
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"
# Fix: Mapeamento de teclas de seta, para corrigir a
# a funcionalidade ao `CTRL + LEFT` ou `CTRL + RIGHT`.
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

# setup key accordingly
[[ -n "${key[Home]}"          ]] && bindkey -- "${key[Home]}"           beginning-of-line
[[ -n "${key[End]}"           ]] && bindkey -- "${key[End]}"            end-of-line
[[ -n "${key[Insert]}"        ]] && bindkey -- "${key[Insert]}"         overwrite-mode
[[ -n "${key[Backspace]}"     ]] && bindkey -- "${key[Backspace]}"      backward-delete-char
[[ -n "${key[Delete]}"        ]] && bindkey -- "${key[Delete]}"         delete-char
[[ -n "${key[Up]}"            ]] && bindkey -- "${key[Up]}"             up-line-or-history
[[ -n "${key[Down]}"          ]] && bindkey -- "${key[Down]}"           down-line-or-history
[[ -n "${key[Left]}"          ]] && bindkey -- "${key[Left]}"           backward-char
[[ -n "${key[Right]}"         ]] && bindkey -- "${key[Right]}"          forward-char
[[ -n "${key[PageUp]}"        ]] && bindkey -- "${key[PageUp]}"         beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"      ]] && bindkey -- "${key[PageDown]}"       end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}"     ]] && bindkey -- "${key[Shift-Tab]}"      reverse-menu-complete
# Fix: Mapeamento de teclas de seta, para corrigir a
# a funcionalidade ao `CTRL + LEFT` ou `CTRL + RIGHT`.
[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"   backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}"  forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Setup para sessões remotas SSH
if [[ -n "$SSH_CONNECTION" ]]; then
    # Editor preferido
    export EDITOR='nvim'
fi

# Prompt

# Define um tema
prompt_mytheme_setup () {
    # PROMPT == PS1
    # RPROMPT == RPS1
    PS1='%F{cyan}%n@%m %f%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
    RPS1='%F{cyan}%*%f - %F{yellow}%?%f'
}


# vcs_info: informações do repositório git
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
# %f e %F são codigos de escape, usados para definir cor
# %n - nome de usuário
# %m - nome do computador
# %d e %~ - CWD
autoload -Uz promptinit && promptinit

prompt_themes+=( mytheme )
prompt mytheme
