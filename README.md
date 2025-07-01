# dotfiles

## Dependências

- stow
- git

### Como instalar

`stow -t ~ <package>`

### Pós-instalação

Defina variáveis de ambiente no arquivo `~/.zshenv` 

```
# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
OH_MY_ZSH_THEME=<NOME DO TEMA>
```


```
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```


#### Configuração e inicialização do Tmux

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

```
tmux source ~/.tmux.conf

```

```
prefix + I
```
