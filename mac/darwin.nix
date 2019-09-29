{ config, lib, pkgs, ... }:

let

  user = "kaushik";
  home_directory = "/Users/${user}";
  xdg_configHome = "${home_directory}/.config";
  log_directory = "${home_directory}/Library/Logs";
  tmp_directory = "/tmp";

in
{

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };

    overlays = [
      (import ../overlays/00-home-manager.nix)
      (import ../overlays/01-nix-scripts.nix)
      (import ../overlays/10-emacs.nix)
      (import ../overlays/20-lorri.nix)
      (import ../overlays/30-apps.nix)
    ];
  };

  environment = {
    systemPackages = import ./config/packages.nix { inherit pkgs; };
    darwinConfig = "/Users/kaushik/Developer/src/personal/nix-config/mac/darwin.nix";

    variables = {
      LC_CTYPE = "en_US.UTF-8";
      TERM = "xterm-256color";
      LANG = "en_US.UTF-8";
      VISUAL = "emacsclient";
      HOME_MANAGER_CONFIG = "${home_directory}/Developer/src/personal/nix-config/mac/home.nix";
      MANPATH = [
        "${home_directory}/.nix-profile/share/man"
        "${home_directory}/.nix-profile/man"
        "${config.system.path}/share/man"
        "${config.system.path}/man"
        "/usr/local/share/man"
        "/usr/share/man"
        "/Developer/usr/share/man"
        "/usr/X11/man"
      ];
    };


    pathsToLink = [ "/info" "/etc" "/share" "/include" "/lib" "/libexec" ];
  };

  services.activate-system.enable = true;

  nix = {
    package = pkgs.nix;

    useSandbox = false;
    sandboxPaths = [
      "/System/Library/Frameworks"
      "/System/Library/PrivateFrameworks"
      "/usr/lib"
      "/private/tmp"
      "/private/var/tmp"
      "/usr/bin/env"
    ];

    nixPath = [
      "darwin-config=$HOME/Developer/src/personal/nix-config/mac/darwin.nix"
      "ssh-config-file=$HOME/.ssh/config"
      "/nix/var/nix/profiles/per-user/${user}/channels"
      "$HOME/.nix-defexpr/channels"
    ];

    maxJobs = 8;
    buildCores = 4;
    distributedBuilds = true;

    ## Obelisk
    binaryCaches = [
      "https://nixcache.reflex-frp.org"
    ];

    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
    ];
  };

  programs.bash = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableBashCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
  };

  system.stateVersion = 3;
}
