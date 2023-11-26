{ config, pkgs, lib, ... }:

let

  dconf_settings = import ./dconf.nix;

in

{

  home.username = "kc";
  home.homeDirectory = "/home/kc";
  home.sessionVariables.GTK_THEME = "palenight";

  programs.git = {
    enable = true;
    userName = "Kaushik Chakraborty";
    userEmail = "git@kaushikc.org";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
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

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  dconf.settings = (dconf_settings { inherit lib; }).dconf.settings;

  programs.fish.enable = true;
  programs.helix = {
    enable = true;
  };

  home.packages = with pkgs; [

    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.space-bar

    firefox
  ];


  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
  
}
