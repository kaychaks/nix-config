if test "$TERM_PROGRAM" != "WarpTerminal"
    direnv hook fish | source
    direnv export fish | source

    set -g direnv_fish_mode disable_arrow 
end
