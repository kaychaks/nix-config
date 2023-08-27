{ pkgs, config, lib, ... }:

let
  user = "kaushik";
  home_dir = "/home/${user}";
  nix_config_dir = "${home_dir}/Dev/nix-config";
  dconf_settings = import ./dconf.nix;
  nixpkgs = import <nixpkgs> { config = { allowUnfree = true; }; };

in {
  home.stateVersion = "22.11";
  xdg.configFile."alacritty/alacritty.yml".source =
    "${nix_config_dir}/plain-configs/alacritty/alacritty-linux.yml";
  home.file.".tmux.conf".source =
    "${nix_config_dir}/plain-configs/tmux/tmux.conf";
  xdg.configFile."starship.toml".source =
    "${nix_config_dir}/plain-configs/starship.toml";

  # gnome settings are imported from dconf. this file is generated with command
  # dconf dump / | dconf2nix | sudo tee /etc/nixos/dconf.nix
  # install dconf2nix - nix-env -i dconf2nix
  # ref: https://gvolpe.com/blog/gnome3-on-nixos/
  #  imports = [ ./dconf.nix ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = ["electron-20.3.11"];

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    BROWSER = "firefox";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    TERM = "alacritty";
    LANG = "en_US.UTF-8";
  };

  home.packages = [
    pkgs.gnome.gnome-shell-extensions
    pkgs.gnome.gnome-tweaks

    pkgs.gnomeExtensions.appindicator
    pkgs.gnomeExtensions.pop-shell

    pkgs.tmuxPlugins.continuum
    pkgs.tmuxPlugins.logging
    pkgs.tmuxPlugins.resurrect
    pkgs.tmuxPlugins.sidebar
    pkgs.tmuxPlugins.urlview
    pkgs.tmuxPlugins.yank
    pkgs.tmuxPlugins.fpp

    pkgs.rustup

    # pkgs.github-desktop
    #firefox-wayland
    pkgs.dconf2nix

    pkgs.logseq

    pkgs._1password
    pkgs._1password-gui
    # nixpkgs.gitAndTools.gh
    nixpkgs.gitAndTools.git-annex
    nixpkgs.gitAndTools.git-open
    # nixpkgs.gitAndTools.git-crypt

    pkgs.wl-clipboard
    pkgs.fpp
    pkgs.ripgrep

    nixpkgs.vscode

    pkgs.direnv

    pkgs.google-chrome
    pkgs.autojump

    pkgs.stylua
    pkgs.shellcheck
    pkgs.commitlint
    pkgs.yamllint
    pkgs.nixfmt
    pkgs.statix

    pkgs.nodejs-18_x
    nixpkgs.nodePackages.pnpm
    pkgs.nodePackages.sass

    pkgs.cargo-make
    pkgs.broot
  ];
  gtk.enable = true;

  services = {
    gpg-agent = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  xdg = { enable = true; };

  dconf.settings = (dconf_settings { inherit lib; }).dconf.settings // {
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ "<Super>space" "<Alt>Tab" ];
      toggle-overview = [ "<Super>s" ];
    };

  };

  programs = {
    autojump.enable = true;
    htop.enable = true;
    jq.enable = true;
    tmux.enable = true;
    firefox.enable = true;
    alacritty.enable = true;
    gpg.enable = true;
    fish = { enable = true; };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
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

    lazygit.enable = true;
    gitui.enable = true;
    gh = {
      enable = false;
      #  enableGitCredentialHelper = true;
    };
    git = {
      enable = true;
      userName = "Kaushik Chakraborty";
      userEmail = "git@kaushikc.org";

      aliases = {
        amend = "commit --amend -C HEAD";
        b = "branch --color -v";
        ca = "commit --amend";
        changes = "diff --name-status -r";
        clone = "clone --recursive";
        co = "checkout";
        cp = "cherry-pick";
        dc = "diff --cached";
        dh = "diff HEAD";
        ds = "diff --staged";
        su = "submodule update --init --recursive";
        undo = "reset --soft HEAD^";
        l = "log --graph --pretty=format:'%Cred%h%Creset"
          + " —%Cblue%d%Creset %s %Cgreen(%cr)%Creset'"
          + " --abbrev-commit --date=relative --show-notes=*";
        gs = ''!git pull & git commit -a -m "updates" & git pull'';
      };

      extraConfig = {
        branch.autosetupmerge = true;
        github.user = "kaychaks";
        pull.rebase = true;

        color = {
          status = "auto";
          diff = "auto";
          branch = "auto";
          interactive = "auto";
          ui = "auto";
          sh = "auto";
        };

        submodule = { recurse = true; };

        credential.helper = "${
            pkgs.git.override { withLibsecret = true; }
          }/bin/git-credential-libsecret";
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
          #            identityFile = "/home/kaushik/Documents/keys/do-nixos";
          identitiesOnly = true;
        };
      };
    };
    helix = {
      enable = true;
      package = nixpkgs.helix;
      settings = {
        editor = {
          auto-format = false;
          auto-save = true;
          completion-replace = true;
          auto-info = false;
          color-modes = true;
          text-width = 100;
          cursor-shape = {
            insert = "bar";
          };
          auto-pairs = true;
          soft-wrap = {
            enable = true;
          };
        };
      };
      
    };
  };

}
