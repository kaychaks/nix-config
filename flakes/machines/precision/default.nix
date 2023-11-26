# default nixos configurations
{ config, lib, pkgs, ... }: 

{

  config = {
    networking.hostName = "tardis";
    networking.domain = "tardis.home";

    time.timeZone = "Asia/Kolkata";

    i18n.defaultLocale = "en_IN";
    i18n.supportedLocales = [ "all" ];
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };


    environment.systemPackages = with pkgs; [

      helix
      alacritty
      direnv
      git
      jq
      fzf
      ripgrep
      lsof
      htop #top replacement
      bat #cat replacement
      broot #tree replacement
      fd #find replacement
      sd #sed replacement
      lsd #ls replacement
      killall
      bottom #process monitor
      graphviz
      curl
      ffmpeg
    ];

    programs.fish.enable = true;


    nix.extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    nixpkgs.config.allowUnfree = true;
    systemd.services.systemd-udevd.restartIfChanged = false;

    environment.variables = {
      EDITOR = "${pkgs.helix}/bin/hx";
      TERM = "${pkgs.alacritty}/bin/alacritty";
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
