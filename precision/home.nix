{ config, pkgs, ... }:

let
  user = "kaushik";
  home_dir = "/home/${user}";
  nix_config_dir = "${home_dir}/src/ops/nix-config";
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
  ghcide = import (builtins.fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master") {};

  lib = pkgs.stdenv.lib;
  restart-taffybar = ''
    echo "Restarting taffybar..."
    $DRY_RUN_CMD rm -fr $HOME/.cache/taffybar/
    $DRY_RUN_CMD systemctl --user restart taffybar.service
  '';

  fzf_c = "https://raw.githubusercontent.com/LnL7/nix-darwin/master/modules/programs/zsh/fzf-completion.zsh";
  fzf_g = "https://raw.githubusercontent.com/LnL7/nix-darwin/master/modules/programs/zsh/fzf-git.zsh";
  fzf_h = "https://raw.githubusercontent.com/LnL7/nix-darwin/master/modules/programs/zsh/fzf-history.zsh";


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
      (import "${nix_config_dir}/overlays/30-thunderbird.nix")
      (import "${nix_config_dir}/overlays/31-zulip.nix")
      (import "${nix_config_dir}/overlays/20-rofi-calc.nix")
      # (import "${nix_config_dir}/precision/configFiles/taffybar/environment.nix")
    ];
  };


  xdg = {
    enable = true;
    dataHome = "${home_dir}/.local/share";
    cacheHome = "${home_dir}/.cache";
    configHome = "${home_dir}/.config";

    dataFile."zsh/fzf-completion.zsh".source = pkgs.fetchurl {url = "${fzf_c}";sha256 = "0diln8gbqyg455zkr1iwb5hz563zzffx9dfffixihw525cg5q789";};
    dataFile."zsh/fzf-git.zsh".source = pkgs.fetchurl {url = "${fzf_g}";sha256 = "0crxflbc9vvpirgld7l9ssnf348py6mbp1vz118slfra551lwbxb";};
    dataFile."zsh/fzf-history.zsh".source = pkgs.fetchurl {url = "${fzf_h}";sha256 = "187vqvpnp45b4xj47qzn4s9jj785zbfbmdfzh1zg2q8d19xgnz5w";};
  };

  home = {
    sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
      BROWSER = "firefox";
      LC_CTYPE = "en_US.UTF-8";
      TERM = "tmux-256color";
      LANG = "en_US.UTF-8";
    };


    file = {
      ".config/sway/config".source = "${nix_config_dir}/precision/configFiles/sway.config";
      ".config/waybar/config".source = "${nix_config_dir}/precision/configFiles/waybar.config";
      ".config/waybar/style.css".source = "${nix_config_dir}/precision/configFiles/waybar.css";
      "bin" = {source = ./bin; recursive = true;};
      ".spacemacs".source = "${nix_config_dir}/dot-emacs/spacemacs";
      # ".emacs.d" = {
      #   source = pkgs.spacemacs;
      #   recursive = true;
      # };
      "${xdg.dataHome}/spacemacs/private" = {
        source = "${nix_config_dir}/dot-emacs/spacemacs-private";
        recursive = true;
      };
      # ".xmonad/xmonad.hs".source = "${nix_config_dir}/precision/configFiles/xmonad/xmonad.hs";
      ".config/taffybar/taffybar.hs" = {
        source = "${nix_config_dir}/precision/configFiles/xmonad/taffybar.hs";
        onChange = restart-taffybar;
      };
      ".config/taffybar/taffybar.css" = {
        source = "${nix_config_dir}/precision/configFiles/xmonad/taffybar.css";
        onChange = restart-taffybar;
      };
      ".config/rofi/config".text = ''
        rofi.font: SF Mono 16
        rofi.terminal: termite
        rofi.theme: ${pkgs.rofi}/share/rofi/themes/Monokai.rasi
      '';
      ".config/wofi/config".text = ''
        mode=drun
        width=600
        height=600
        colors=colors
      '';
      ".config/wofi/style.css".text = ''
        window {
          margin: 5px;
          background: #171717;
          color: #FFCB83;
          font-family: 'Fira Code';
          font-size: 15px;
          border: 3px solid #000000;
          border-radius: 10px;
          outline: 0;
        }

        #input {
          color: #FFCB83;
          background: #171717;
          border: 3px solid #000000;
          border-top-left-radius: 10px;
          border-top-right-radius: 10px;
        }

        #text {
          padding: 2px;
        }
      '';
      ".config/rofi/lib/calc.la".source = "${pkgs.rofi-calc}/libs/calc.la";
      ".config/rofi/lib/calc.so".source = "${pkgs.rofi-calc}/libs/calc.so";
    };

    packages = with pkgs; [
      ## TOOLS
      pandoc
      rofi
      ffmpeg
      gitAndTools.git-crypt
      gitAndTools.pass-git-helper
      pass
      brightnessctl
      betterlockscreen

      libqalculate
      rofi-calc
      clipmenu

      ## CHAT
      # riot-desktop ## matrix client
      signal-desktop
      # zulip
      discord
      hexchat

      ## APPLICATIONS
      zotero
      thunderbird-beta
      vlc
      mpv
      feh ## image viewer
      okular ## document viewer
      kleopatra ## GnuPG UI client
      xfce.thunar ## files manager UI
      libreoffice

      ## DEV
      nixfmt
      jq
      python3
      ruby
      cabal2nix
      cabal-install
      postgresql
      haskellPackages.ghcid
      haskellPackages.stylish-haskell
      haskellPackages.hoogle
      haskellPackages.apply-refact
      haskellPackages.hasktags
      haskellPackages.hlint
      (all-hies.selection { selector = p: { inherit (p) ghc864 ghc865 ghc843 ; }; })
      (ghcide.ghcide-ghc865)

      nodejs_latest
      nodePackages.eslint
    ];
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    taffybar = {
      enable = false;
    };

    screen-locker = {
      enable = false;
      lockCmd = "betterlockscreen -l dim";
    };

  };

  programs = {
    autorandr = {
      enable = true;
      hooks.postswitch = {
        "reload-taffybar" = "systemctl --user restart taffybar.service";
      };
      profiles = {
        solo = {
          fingerprint = {
            eDP-1 = "00ffffffffffff0006afeb4100000000221c0104b522137802af95a65435b5260f50540000000101010101010101010101010101010152d000a0f0703e803020350058c11000001a52d000a0f07068823020350025a51000001a000000fe00375837314880423135365a414e0000000000054122b2001200000b010a2020013902030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
          };
          config = {
            "eDP-1" = {
              enable = true;
              mode = "3840x2160";
              rate = "60.0";
              primary = true;
            };
          };
        };
        clamshell = {
          fingerprint = {
            DP-1-6 = "00ffffffffffff0010ace0404c353032271c0104b5371f783aa195af4f35b7260c5054a54b00714fa9408180d1c00101010101010101565e00a0a0a029503020350029372100001a000000ff003550564d503839513230354c0a000000fc0044454c4c20555032353136440a000000fd00324b1e5819010a20202020202001f302031cf14f90050403020716010611121513141f23091f0783010000023a801871382d40582c450029372100001e7e3900a080381f4030203a0029372100001a011d007251d01e206e28550029372100001ebf1600a08038134030203a0029372100001a00000000000000000000000000000000000000000000000000000086";
          };
          config = {
            "DP-1-6" = {
              enable = true;
              mode = "2560x1440";
              rate = "60.0";
              primary = true;
            };
          };
        };
        dual = {
          fingerprint = {
            DP-1-6 = "00ffffffffffff0010ace0404c353032271c0104b5371f783aa195af4f35b7260c5054a54b00714fa9408180d1c00101010101010101565e00a0a0a029503020350029372100001a000000ff003550564d503839513230354c0a000000fc0044454c4c20555032353136440a000000fd00324b1e5819010a20202020202001f302031cf14f90050403020716010611121513141f23091f0783010000023a801871382d40582c450029372100001e7e3900a080381f4030203a0029372100001a011d007251d01e206e28550029372100001ebf1600a08038134030203a0029372100001a00000000000000000000000000000000000000000000000000000086";
            eDP-1 = "00ffffffffffff0006afeb4100000000221c0104b522137802af95a65435b5260f50540000000101010101010101010101010101010152d000a0f0703e803020350058c11000001a52d000a0f07068823020350025a51000001a000000fe00375837314880423135365a414e0000000000054122b2001200000b010a2020013902030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
          };
          config = {
            "DP-1-6" = {
              enable = true;
              mode = "2560x1440";
              rate = "60.0";
              primary = true;
              position = "9438x142";
            };
            "eDP-1" = {
              enable = true;
              mode = "3840x2160";
              rate = "60.0";
              primary = false;
              position = "5598x142";
            };
          };
        };
        hdmi_dual = {
          fingerprint = {
            HDMI-1-3 = "00ffffffffffff0010ace1404c353032271c010380371f782aa195af4f35b7260c5054a54b00714fa9408180d1c00101010101010101565e00a0a0a029503020350029372100001a000000ff003550564d503839513230354c0a000000fc0044454c4c20555032353136440a000000fd00324b1e5819000a2020202020200139020324f14f90050403020716010611121513141f23091f078301000067030c001000383e023a801871382d40582c450029372100001e7e3900a080381f4030203a0029372100001a011d007251d01e206e28550029372100001ebf1600a08038134030203a0029372100001a0000000000000000000000000000000000000082";
            eDP-1 = "00ffffffffffff0006afeb4100000000221c0104b522137802af95a65435b5260f50540000000101010101010101010101010101010152d000a0f0703e803020350058c11000001a52d000a0f07068823020350025a51000001a000000fe00375837314880423135365a414e0000000000054122b2001200000b010a2020013902030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
          };
          config = {
            "HDMI-1-3" = {
              enable = true;
              mode = "2560x1440";
              rate = "60.0";
              primary = true;
              position = "9438x142";
            };
            "eDP-1" = {
              enable = true;
              mode = "3840x2160";
              rate = "60.0";
              primary = false;
              position = "5598x142";
            };
          };
        };
      };
    };

    home-manager.enable = true;

    gpg.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacs.override { inherit (pkgs) imagemagick; };
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
    };

    termite = {
      enable = true;
      allowBold = true;
      font = "SF Mono 12";
      backgroundColor = "rgba(0, 43, 54)";
      clickableUrl = true;
      foregroundColor = "#93a1a1";
      foregroundBoldColor = "#eee8d5";
      cursorColor = "#eee8d5";
      cursorForegroundColor = "#002b36";
      colorsExtra = ''
        # Black, Gray, Silver, White
        color0  = #002b36
        color8  = #657b83
        color7  = #93a1a1
        color15 = #fdf6e3

        # Red
        color1  = #dc322f
        color9  = #dc322f

        # Green
        color2  = #859900
        color10 = #859900

        # Yellow
        color3  = #b58900
        color11 = #b58900

        # Blue
        color4  = #268bd2
        color12 = #268bd2

        # Purple
        color5  = #6c71c4
        color13 = #6c71c4

        # Teal
        color6  = #2aa198
        color14 = #2aa198

        # Extra colors
        color16 = #cb4b16
        color17 = #d33682
        color18 = #073642
        color19 = #586e75
        color20 = #839496
        color21 = #eee8d5
      '';
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


    # firefox = {
    #   enable = true;
    #   package= pkgs.firefox-wayland;
    # };
    chromium = {
      enable = true;
    };

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
        credential.helper     = "${pkgs.gitAndTools.pass-git-helper}/bin/pass-git-helper";

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
        signByDefault = false;
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

      matchBlocks = {
          kutir = {
            hostname = "139.59.56.101";
            user = "kaushikc";
            identityFile = "/home/kaushik/Documents/keys/do-nixos";
            identitiesOnly = true;
          };
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      defaultKeymap = "emacs";
      enableCompletion = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "cabal"
          "docker"
          "dotenv"
          "emacs"
          "vi-mode"
          "git"
          "git-extras"
          "history"
          "man"
          "npm"
          "ssh-agent"
          "tmux"
        ];
      };

      history = {
        size = 50000;
        save = 500000;
      };

      sessionVariables = {
        ALTERNATE_EDITOR  = "vim";
        EDITOR            = "vim";
        LC_CTYPE = "en_US.UTF-8";
        TERM = "tmux-256color";
        LANG = "en_US.UTF-8";
        VISUAL = "vim";
        DISABLE_AUTO_TITLE = "true";
      };

      shellAliases = {
        l = "ls -lah";
        ll = "ls -lh";
        la = "ls -lAh";
        d = "dirs -v | head -10";
      };

      initExtra = ''

        # setopt AUTOCD AUTOPUSHD
        # autoload -U down-line-or-beginning-search
        # autoload -U up-line-or-beginning-search
        # bindkey '^[[A' down-line-or-beginning-search
        # bindkey '^[[A' up-line-or-beginning-search
        # zle -N down-line-or-beginning-search
        # zle -N up-line-or-beginning-search
        PS1=' %F{blue}λ%f '

        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

        # TMUX
#        if which tmux >/dev/null 2>&1; then
#          if no session is started, start a new session
#          test -z $TMUX && tmux
#
#          when quitting tmux, try to attach
#          while test -z $TMUX; do
#           tmux attach || break
#          done
#        fi

        # If running from tty1 start sway
         if [ "$(tty)" = "/dev/tty1" ]; then
	         exec sway
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
        # unbind-key C-b
        # set-option -g prefix C-m
        # bind-key C-m send-prefix

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

        # new session
        bind -r C-s new-session

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
        bind-key -n S-r run "tmux send-keys -t .+ C-l Up Enter"
        bind-key -n S-t run "tmux send-keys -t _ C-l Up Enter"

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

        set -g status-right '  #[fg=colour233,bg=colour58,bold] #(hostname) #[fg=colour233,bg=colour62,bold] %m/%d %H:%M  '

        set -g status-right-length 50
        # set -g status-left-length 20

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
  # xresources.extraConfig = ''
  #   Xft.dpi: 180
  #   Xft.autohint: 0
  #   Xft.lcdfilter:  lcddefault
  #   Xft.hintstyle:  hintfull
  #   Xft.hinting: 1
  #   Xft.antialias: 1
  #   Xft.rgba: rgb
  # '';

  xsession = {
   enable = false;
   preferStatusNotifierItems = true;
   initExtra = ''
     xset r rate 200 30
     xinput set-prop "DELL0926:00 044E:1220 Touchpad" "libinput Natural Scrolling Enabled" 0
     xinput set-prop "DELL0926:00 044E:1220 Mouse" "libinput Natural Scrolling Enabled" 0
     xinput set-prop "DELL0926:00 044E:1220 Touchpad" "libinput Tapping Enabled Default" 0
     xinput set-prop "DELL0926:00 044E:1220 Mouse" "libinput Tapping Enabled Default" 0
   '';
   windowManager.xmonad = {
     enable = false;
     enableContribAndExtras = true;
     extraPackages = (haskellPackages: [haskellPackages.taffybar]);
     config = ./configFiles/xmonad/xmonad.hs;
   };
   pointerCursor = {
     name = "breeze_cursors";
     size = 32;
     package = pkgs.plasma5.breeze-qt5;
   };
  };

  # systemd.user.services.volumeicon =
  #   {
  #     Unit = {
  #       Description = "volume tray icon";
  #     };

  #     Service = {
  #       ExecStart = "${pkgs.volumeicon}/bin/volumeicon";
  #       Restart = "on-failure";
  #     };

  #     Install = {
  #       WantedBy = [ "default.target" ];
  #     };
  #   };
}
