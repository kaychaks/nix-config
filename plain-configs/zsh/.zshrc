export PATH=/usr/local/opt/grep/libexec/gnubin:/usr/local/opt/openjdk/bin:/usr/local/opt/ruby/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH:/usr/local/bin:/usr/local/sbin:/Users/139137/bin:/usr/local/lib/ruby/gems/3.0.0/bin:/Users/139137/.emacs.d/bin:/Users/139137/.local/bin:/Users/139137/.cabal/bin:/Users/139137/.local/share/hls/haskell-language-server-macOS-0.7.1:/Users/139137/.elan/bin

export PKG_CONFIG_PATH=/usr/local/opt/zlib/lib/pkgconfig:/usr/local/opt/libedit/lib/pkgconfig:/usr/local/opt/zlib/lib/pkgconfig:$PKG_CONFIG_PATH

## OH-MY-ZSH
source "/Users/139137/.config/zsh/.zshrc-omz"

. /Users/139137/.nix-profile/etc/profile.d/nix.sh

# ENV VARIABLES
export ALTERNATE_EDITOR="/usr/local/bin/vi"
export EDITOR="emacsclient -s /tmp/emacs501/server -a /usr/local/bin/vi"
export LC_CTYPE="en_US.UTF-8";
#export TERM="screen-256color";
export LANG="en_US.UTF-8";
export VISUAL="emacsclient";

export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"

#export DENO_INSTALL="/Users/139137/.deno"

HISTSIZE="50000"
SAVEHIST="500000"
HISTFILE="/Users/139137/.config/zsh/history"
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
    source '/Users/139137/config/zsh/.zprofile'
    source '/Users/139137/.config/zsh/.zshrc'
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

source '/Users/139137/.config/zsh/fzf-completion.zsh'
source '/Users/139137/.config/zsh/fzf-git.zsh'
source '/Users/139137/.config/zsh/fzf-history.zsh'

source '/Users/139137/.ghcup/env'

#source '/Users/139137/.config/zsh/deno-completion.bash'

# Read system-wide modifications.
if test -f /etc/zshrc.local; then
    source /etc/zshrc.local
fi

# Aliases
alias cdp="cd /Users/139137/developer/src/personal/";
alias cdw="cd /Users/139137/developer/src/work/";
alias l="ls -lah --color=auto -F";
alias ll="ls -lh --color=auto -F";
alias la="ls -lAh --color=auto -F";
alias d="dirs -v | head -10";
alias vim=nvim
alias rm=trash
alias Emacs=/usr/local/bin/emacs



# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/139137/developer/src/work/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/139137/developer/src/work/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/139137/developer/src/work/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/139137/developer/src/work/google-cloud-sdk/completion.zsh.inc'; fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm

eval "$(direnv hook zsh)"
function gi() { curl -sLw n https://www.toptal.com/developers/gitignore/api/$@ ;}
