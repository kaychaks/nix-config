{ pkgs, config, lib, ... }:

let 
  dconf_settings = import ./dconf.nix;

in

{
  xdg.configFile."alacritty/alacritty.yml".source = /home/kaushik/Dev/nix-config/plain-configs/alacritty/alacritty.yml; 
  home.file.".tmux.conf".source = /home/kaushik/Dev/nix-config/plain-configs/tmux/tmux.conf;

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

    rustup
    rust-analyzer

    github-desktop
    #firefox-wayland
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
      switch-applications = [ "<Super>Tab" "<Alt>Tab" "<Super>space"];
    };
  };

  programs = {
    autojump.enable = true;
    htop.enable = true;
    jq.enable = true;
    tmux.enable = true;
    vscode.enable = true;
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
    neovim = {
      enable = true;
    };
    lazygit.enable = true;
    gitui.enable = true;
    git = {
      enable = true;
      userName = "Kaushik Chakraborty";
      userEmail = "git@kaushikc.org";

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

        credential.helper = "!git-credential-1password";
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
  };

}
