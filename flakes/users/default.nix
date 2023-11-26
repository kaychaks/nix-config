{ lib, pkgs, ... }:
{
  config = {

    home-manager.users.kc = ./kc.nix;
    services.xserver.displayManager.autoLogin.user = "kc";
    users.users.kc = {
      isNormalUser = true;
      home = "/home/kc";
      createHome = true;
      hashedPasswordFile = "/var/enc-pass/kc";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "disk" "networkmanager" "kvm" "plugdev" "video" "audio" ];
    };
    
  };
}
