{ config, pkgs, ... }:

let
  user = "kaushik";
  home_dir = "/home/${user}";
  nix_config_dir = "${home_dir}/src/nix-config";

  lib = pkgs.stdenv.lib;
in

rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
    };

    overlays = [
#      (import "${nix_config_dir}/overlays/10-emacs.nix")
      (import "${nix_config_dir}/overlays/11-spacemacs")
    ];
  };


  xdg = {
    enable = true;
    dataHome = "${home_dir}/.local/share";
    cacheHome = "${home_dir}/.cache";
  };


  home = {
    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      BROWSER = "firefox";
    };

    file = {
      ".spacemacs".source = "${nix_config_dir}/dot-emacs/spacemacs";
      ".emacs.d" = {
        source = pkgs.spacemacs;
        recursive = true;
      };
      "${xdg.dataHome}/spacemacs/private" = {
        source = "${nix_config_dir}/dot-emacs/spacemacs-private";
        recursive = true;
      };
    };

    packages = with pkgs; [
      pandoc

      fractal ## matrix client

      ## TODO: list of gnome extensions
    ];
  };

  services = {
    keybase.enable = true;
    kbfs.enable = true;
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };

  programs = {
    home-manager.enable = true;

    gpg.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacs.override { inherit (pkgs) imagemagick; };
      extraPackages = epkgs: with epkgs; [pdf-tools];
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };


    vim = {
      enable = true;
      settings = {
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        copyindent = true;
        modeline = true;
      };
    };


    firefox.enable = true;

    bash = {
      enable = true;
      bashrcExtra = lib.mkBefore ''
        source /etc/bashrc
      '';
    };

    git = {
      enable = true;

      userName = "Kaushik Chakraborty";
      userEmail = "git@kaushikc.org";

      aliases = {
        amend      = "commit --amend -C HEAD";
        b          = "branch --color -v";
        ca         = "commit --amend";
        changes    = "diff --name-status -r";
        clone      = "clone --recursive";
        co         = "checkout";
        cp         = "cherry-pick";
        dc         = "diff --cached";
        dh         = "diff HEAD";
        ds         = "diff --staged";
        su         = "submodule update --init --recursive";
        undo       = "reset --soft HEAD^";
        l          = "log --graph --pretty=format:'%Cred%h%Creset"
                   + " —%Cblue%d%Creset %s %Cgreen(%cr)%Creset'"
                   + " --abbrev-commit --date=relative --show-notes=*";
      };

      extraConfig = {
        branch.autosetupmerge = true;
        github.user           = "kaychaks";
        pull.rebase           = true;

        color = {
          status      = "auto";
          diff        = "auto";
          branch      = "auto";
          interactive = "auto";
          ui          = "auto";
          sh          = "auto";
        };

        submodule = {
          recurse = true;
        };
      };

      signing = {
        signByDefault = true;
        key = "604E119FFCEFF635";
      };

      ignores = [
        "#*#"
        "*.a"
        "*.aux"
        "*.dylib"
        "*.elc"
        "*.glob"
        "*.la"
        "*.o"
        "*.so"
        "*.v.d"
        "*.vo"
        "*~"
        ".clean"
        ".direnv"
        ".envrc"
        ".envrc.override"
        ".ghc.environment.x86_64-darwin-*"
        ".makefile"
        "TAGS"
        "cabal.project.local"
        "dist-newstyle"
        "result"
        "result-*"
        "tags"
      ];
    };


    ssh = {
      enable = true;
      forwardAgent = true;
      serverAliveInterval = 60;

      hashKnownHosts = true;
    };

    zsh = {
      enable = true;
      autocd = true;
      defaultKeymap = "emacs";

      history = {
        size = 50000;
        save = 500000;
      };

      sessionVariables = {
        ALTERNATE_EDITOR  = "vim";
        EDITOR            = "vim";
        LC_CTYPE = "en_US.UTF-8";
        TERM = "xterm-256color";
        LANG = "en_US.UTF-8";
        VISUAL = "vim";
      };

      shellAliases = {
        l = "ls -lah";
        ll = "ls -lh";
        la = "ls -lAh";
        d = "dirs -v | head -10";
      };

      initExtra = ''
        take() {
          mkdir -p $@ && cd ''${@:$#}
        }
        :d() {
          eval "$(direnv hook zsh)"
        }
        :r() {
          rm -f .direnv/dump-* && direnv reload
        }

        autoload -U promptinit && promptinit
        setopt PROMPTSUBST
        _prompt_nix() {
        [ -z "$IN_NIX_SHELL" ] || echo "%F{yellow}%B[''${name:+$name}λ]%b%f "
        }
        PS1='%F{blue}λ%f '
        RPS1='$(_prompt_nix)%F{green}%~%f'

        setopt AUTOCD AUTOPUSHD
        autoload -U down-line-or-beginning-search
        autoload -U up-line-or-beginning-search
        bindkey '^[[A' down-line-or-beginning-search
        bindkey '^[[A' up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        zle -N up-line-or-beginning-search

        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        # Read system-wide modifications.
        if test -f /etc/zshrc.local; then
          source /etc/zshrc.local
        fi
      '';

    };

    tmux = {
      enable = true;

      baseIndex = 1;
      clock24 = true;
      terminal = "screen-256color";

      keyMode = "vi";
      newSession = true;
      escapeTime = 1;
      historyLimit = 10000;

      secureSocket = false;

      extraConfig = ''

        set -g mouse on

        # default shell
        set-option -g default-shell ${pkgs.zsh}/bin/zsh

        # rebind global key
        unbind-key C-b
        set-option -g prefix M-m
        bind-key M-m send-prefix

        bind 0 set status
        bind S choose-session

        # bind key to update tmux config
        bind-key R source-file ${home_dir}/.tmux.conf ; display-message "tmux REFRESHED!!"

        # y and p as in vim
        bind Escape copy-mode
        unbind p
        bind p paste-buffer
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection
        bind-key -T copy-mode-vi 'Space' send -X halfpage-down
        bind-key -T copy-mode-vi 'Bspace' send -X halfpage-up

        # new window & pane with current working directory
        bind-key C new-window -c "#{pane_current_path}"
        bind-key | split-window -h -c "#{pane_current_path}"
        bind-key _ split-window -c "#{pane_current_path}"

        # moving between panes with vim movement keys
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # moving between windows with vim movement keys
        bind -r C-h select-window -t :-
        bind -r C-l select-window -t :+

        # resize panes with vim movement keys
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5

        bind-key -r "<" swap-window -t -1
        bind-key -r ">" swap-window -t +1
        bind-key -n M-r run "tmux send-keys -t .+ C-l Up Enter"
        bind-key -n M-t run "tmux send-keys -t _ C-l Up Enter"

        ## Design Changes

        setw -g monitor-activity on
        set -g visual-activity on

        #  modes
        setw -g clock-mode-colour colour5
        setw -g mode-attr bold
        setw -g mode-fg colour1
        setw -g mode-bg colour18

        # panes
        set -g pane-border-bg colour0
        set -g pane-border-fg colour19
        set -g pane-active-border-bg colour0
        set -g pane-active-border-fg colour9

        # statusbar
        set -g status-position bottom
        set -g status-justify left

        set -g status-bg colour59

        set -g status-fg colour137
        set -g status-attr dim
        set -g status-left ' '

        set -g status-right '#[fg=colour233,bg=colour58,bold] #(hostname) #[fg=colour233,bg=colour62,bold] %m/%d %H:%M '

        set -g status-right-length 50
        set -g status-left-length 20

        setw -g window-status-current-fg colour1

        setw -g window-status-current-bg colour58

        setw -g window-status-current-attr bold
        setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '

        setw -g window-status-fg colour9

        setw -g window-status-bg colour60

        setw -g window-status-attr none
        setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

        setw -g window-status-bell-attr bold
        setw -g window-status-bell-fg colour255
        setw -g window-status-bell-bg colour1

        # messages
        set -g message-attr bold
        set -g message-fg colour231
        set -g message-bg colour58

    '';
    };


  };


  # xserver options
  #xsession = {
  #  enable = true;
  #};
}
