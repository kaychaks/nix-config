if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin $PATH /Users/kaushikchakraborty/.ghcup/bin # ghcup-env