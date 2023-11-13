if status is-interactive && test "$TERM_PROGRAM" != "WarpTerminal"
    # Commands to run in interactive sessions can go here
    starship init fish | source
end
