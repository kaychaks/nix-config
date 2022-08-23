export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:~/.emacs.d/bin

export PKG_CONFIG_PATH=/usr/local/opt/zlib/lib/pkgconfig:/usr/local/opt/libedit/lib/pkgconfig:/usr/local/opt/zlib/lib/pkgconfig:$PKG_CONFIG_PATH

source $HOME/.config/zsh/.zshrc-omz

# ENV VARIABLES
export LC_CTYPE="en_US.UTF-8";
#export TERM="screen-256color";
export LANG="en_US.UTF-8";

export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"

HISTSIZE="50000"
SAVEHIST="500000"
HISTFILE="$HOME/.config/zsh/history"
mkdir -p `(dirname "$HISTFILE")`


setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY


take() {
    mkdir -p $@ && cd ''${@:$#}
}
:d() {
    eval "$(direnv hook zsh)"
}
:r() {
    rm -f .direnv/dump-* && direnv reload
}
:s() {
    source '$HOME/config/zsh/.zprofile'
    source '$HOME/.config/zsh/.zshrc'
}

autoload -U promptinit && promptinit
setopt PROMPTSUBST
_prompt_nix() {
[ -z "$IN_NIX_SHELL" ] || echo "%F{yellow}%B[''${name:+$name}λ]%b%f "
}

PS1='%F{blue}'$'\U1D77A%f'' '
RPS1='$(_prompt_nix)%F{green}%~%f'

setopt AUTOCD AUTOPUSHD
autoload -U down-line-or-beginning-search
autoload -U up-line-or-beginning-search
bindkey '^[[A' down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N up-line-or-beginning-search

source "$HOME/.config/zsh/fzf-completion.zsh"
source "$HOME/.config/zsh/fzf-git.zsh"
source "$HOME/.config/zsh/fzf-history.zsh"

# Read system-wide modifications.
if test -f /etc/zshrc.local; then
    source /etc/zshrc.local
fi

# Aliases
alias l="exa -l";
alias ll="exa -la";
alias la="exa -laa";
alias d="dirs -v | head -10";
alias vi=nvim;
alias vim=nvim;

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# rust
. "$HOME/.cargo/env"

# direnv
eval "$(direnv hook zsh)"
