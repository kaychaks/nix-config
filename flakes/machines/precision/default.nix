# default nixos configurations
{ config, lib, pkgs }: {
  config = {
    networking.hostname = "tardis";
    networking.domain = "tardis.home";

    time.timeZone = "Asia/Kolkata";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = [ "all" ];

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
