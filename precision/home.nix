{ pkgs, config, lib, ... }:

let
  user = "kaushik";
  home_dir = "/home/${user}";
  nix_config_dir = "${home_dir}/Dev/nix-config";
  dconf_settings = import ./dconf.nix;
  nixpkgs = import <nixpkgs> { config = { allowUnfree = true; }; };
in


{
  xdg.configFile."alacritty/alacritty.yml".source = "${nix_config_dir}/plain-configs/alacritty/alacritty.yml"; 
  home.file.".tmux.conf".source = "${nix_config_dir}/plain-configs/tmux/tmux.conf";
  xdg.configFile."starship.toml".source = "${nix_config_dir}/plain-configs/starship.toml";

  # gnome settings are imported from dconf. this file is generated with command
  # dconf dump / | dconf2nix | sudo tee /etc/nixos/dconf.nix
  # install dconf2nix - nix-env -i dconf2nix
  # ref: https://gvolpe.com/blog/gnome3-on-nixos/
#  imports = [ ./dconf.nix ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    gnome.gnome-shell-extensions
    gnome.gnome-tweaks

    gnomeExtensions.appindicator
    gnomeExtensions.pop-shell

    tmuxPlugins.continuum
    tmuxPlugins.logging
    tmuxPlugins.resurrect
    tmuxPlugins.sidebar
    tmuxPlugins.urlview
    tmuxPlugins.yank
    tmuxPlugins.fpp

    rustup
    rust-analyzer

    github-desktop
    #firefox-wayland
    dconf2nix

    logseq


    nixpkgs._1password
    nixpkgs._1password-gui
    # nixpkgs.gitAndTools.gh
    nixpkgs.gitAndTools.git-annex
    nixpkgs.gitAndTools.git-open
    # nixpkgs.gitAndTools.git-crypt

    wl-clipboard
    fpp
    ripgrep
  ];
  gtk.enable = true;

  services = {
    gpg-agent = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  xdg = {
    enable = true;
  };


  dconf.settings = (dconf_settings {lib = lib;}).dconf.settings // {
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ "<Super>space" "<Alt>Tab"];
      toggle-overview = [ "<Super>s" ];
    };

  };

  programs = {
    autojump.enable = true;
    htop.enable = true;
    jq.enable = true;
    tmux.enable = true;
    vscode = {
      enable = true;
      package = nixpkgs.vscode;
    };
    firefox.enable = true;
    alacritty.enable = true;
    gpg.enable = true;
    fish = {
      enable = true;
    };

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



    neovim = {
      enable = true;
    };
    lazygit.enable = true;
    gitui.enable = true;
    gh = {
      enable = true;
      enableGitCredentialHelper = true;
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
        gs         = "!git pull & git commit -a -m \"updates\" & git pull";
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

        #credential.helper = "!git-credential-1password";
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
  };

}
