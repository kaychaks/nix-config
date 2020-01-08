{ pkgs, ... }:

let

  user = "kaushik";
  home_directory = "/Users/${user}";
  log_directory = "${home_directory}/Library/Logs";
  tmp_directory = "/tmp";
  lib = pkgs.stdenv.lib;
  localconfig = import <localconfig>;

  fzf_c = "https://raw.githubusercontent.com/LnL7/nix-darwin/master/modules/programs/zsh/fzf-completion.zsh";
  fzf_g = "https://raw.githubusercontent.com/LnL7/nix-darwin/master/modules/programs/zsh/fzf-git.zsh";
  fzf_h = "https://raw.githubusercontent.com/LnL7/nix-darwin/master/modules/programs/zsh/fzf-history.zsh";

  revealjs_source = "https://github.com/hakimel/reveal.js/archive/3.8.0.tar.gz";

in rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };

    overlays = [
      (import ../overlays/01-nix-scripts.nix)
      (import ../overlays/10-emacs.nix)
    ];
  };

  home = {
    packages = with pkgs; [];

    file = {
      ".curlrc".text = ''
        insecure
        proxy-insecure
       '';

       ".spacemacs".source = ../dot-emacs/spacemacs;

      "${xdg.dataHome}/spacemacs/private".source = ../dot-emacs/spacemacs-private;

      "${xdg.dataHome}/revealjs".source = pkgs.fetchzip {url = "${revealjs_source}" ; sha256 = "14cva2hxdv4gxpz2a996qs8xhxffw97a90gkz2mmgdczh1kyn1sc"; };

      "${xdg.configHome}/nixpkgs/config.nix".text = ''
        { allowBroken = true; }
      '';
    };
  };

  programs = {
    home-manager = {
      enable = true;
      path = "${home_directory}/Developer/src/personal/nix-config/home-manager";
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    bash = {
      enable = true;
      bashrcExtra = lib.mkBefore ''
        source /etc/bashrc
      '';
    };


    zsh = rec {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      enableAutosuggestions = false;

      history = {
        size = 50000;
        save = 500000;
        path = "${dotDir}/history";
        ignoreDups = true;
        share = true;
      };

      sessionVariables = {
        ALTERNATE_EDITOR  = "${pkgs.vim}/bin/vi";
        EDITOR            = "${pkgs.emacs26}/bin/emacsclient -s ${tmp_directory}/emacs501/server -a vi";
        LC_CTYPE = "en_US.UTF-8";
        TERM = "xterm-256color";
        LANG = "en_US.UTF-8";
        VISUAL = "emacsclient";
        HOME_MANAGER_CONFIG = "${home_directory}/Developer/src/personal/nix-config/mac/home.nix";
      };

      shellAliases = {
        cdp = "cd ~/Developer/src/personal/";
        cdw = "cd ~/Developer/src/work/";
        l = "ls -lah";
        ll = "ls -lh";
        la = "ls -lAh";
        d = "dirs -v | head -10";
      };

      profileExtra = ''
        export PATH=$PATH:/usr/local/bin:/usr/local/sbin

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
          source ${xdg.configHome}/zsh/.zprofile
          source ${xdg.configHome}/zsh/.zshrc
        }
        :proxy() {
          ${if localconfig.proxy.enable then
              ''
                export HTTP_PROXY=${localconfig.proxy.pass}
                export HTTPS_PROXY=${localconfig.proxy.pass}
                export http_proxy=${localconfig.proxy.pass}
                export https_proxy=${localconfig.proxy.pass}
              ''
            else
              ''
                unset HTTP_PROXY
                unset HTTPS_PROXY
                unset http_proxy
                unset https_proxy
              ''
            }
        }
        :en-proxy() {
        sed -i ''' 's/proxy={enable=[^;]*/proxy={enable=true/' ${xdg.dataHome}/localconfig/default.nix
          home-switch
        }
        :dis-proxy() {
        sed -i ''' 's/proxy={enable=[^;]*/proxy={enable=false/' ${xdg.dataHome}/localconfig/default.nix
          home-switch
        } 
      '';

      initExtra = ''
        export PATH=$PATH:/usr/local/bin:/usr/local/sbin

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
          source ${xdg.configHome}/zsh/.zprofile
          source ${xdg.configHome}/zsh/.zshrc
        }
        :proxy() {
          ${if localconfig.proxy.enable then
              ''
                export HTTP_PROXY=${localconfig.proxy.pass}
                export HTTPS_PROXY=${localconfig.proxy.pass}
                export http_proxy=${localconfig.proxy.pass}
                export https_proxy=${localconfig.proxy.pass}
              ''
            else
              ''
                unset HTTP_PROXY
                unset HTTPS_PROXY
                unset http_proxy
                unset https_proxy
              ''
            }
        }
        :en-proxy() {
        sed -i ''' 's/proxy={enable=[^;]*/proxy={enable=true/' ${xdg.dataHome}/localconfig/default.nix
          home-switch
        }
        :dis-proxy() {
        sed -i ''' 's/proxy={enable=[^;]*/proxy={enable=false/' ${xdg.dataHome}/localconfig/default.nix
          home-switch
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
        source ${xdg.dataHome}/zsh/fzf-completion.zsh
        source ${xdg.dataHome}/zsh/fzf-git.zsh
        source ${xdg.dataHome}/zsh/fzf-history.zsh

        :proxy

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
      bind-key R source-file ${home_directory}/.tmux.conf ; display-message "tmux REFRESHED!!"

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

      #set -g status-right '#[fg=colour233,bg=colour58,bold] #(id -un)@#(hostname) #[fg=colour233,bg=colour62,bold] #(cat /run/current-system/darwin-version) '
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

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome   = "${home_directory}/.local/share";
    cacheHome = "${home_directory}/.cache";

    dataFile."zsh/fzf-completion.zsh".source = pkgs.fetchurl {url = "${fzf_c}";sha256 = "0diln8gbqyg455zkr1iwb5hz563zzffx9dfffixihw525cg5q789";};
    dataFile."zsh/fzf-git.zsh".source = pkgs.fetchurl {url = "${fzf_g}";sha256 = "0crxflbc9vvpirgld7l9ssnf348py6mbp1vz118slfra551lwbxb";};
    dataFile."zsh/fzf-history.zsh".source = pkgs.fetchurl {url = "${fzf_h}";sha256 = "187vqvpnp45b4xj47qzn4s9jj785zbfbmdfzh1zg2q8d19xgnz5w";};
  };
}
