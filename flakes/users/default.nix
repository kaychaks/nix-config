{ lib, pkgs, ... }:
{
  config = {

    home-manager.users.kc = ./kc.nix;
    users.uesrs.kc = {
      isNormalUser = true;
      home = "/home/kc";
      createHome = true;
      passwordFile = "/var/enc-pass/kc";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "disk" "networkmanager" "kvm" "plugdev" "video" "audio" ];
    };
    
  };
}
