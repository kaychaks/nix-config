if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

#set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /Users/kaushikchakraborty/.ghcup/bin # ghcup-env
# set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /home/kaushik/.ghcup/bin # ghcup-env

fish_add_path -pP "$HOME/.cargo/bin"

# autojump config
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish

# direnv
direnv hook fish | source
