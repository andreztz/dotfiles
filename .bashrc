#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
[ -f "$HOME/.scripts/venv_auto_activate.sh" ] && source ~/.scripts/venv_auto_activate.sh

. "$HOME/.cargo/env"
