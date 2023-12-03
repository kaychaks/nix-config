{ lib, pkgs, ... }:
{
  config = {

    home-manager.users.kc = ./kc.nix;
    services.xserver.displayManager.autoLogin.user = "kc";
    users.users.kc = {
      isNormalUser = true;
      home = "/home/kc";
      createHome = true;
      # hashedPasswordFile = "/var/enc-pass/kc";
      hashedPassword = "$6$NdO7RqKC0wU0z8lK$wS3nxa8y9cvagi2OEXCG9/eqqNE/HdZ4.h28pkKfRZVoB/hjzETRlkEaBhACzdGBo2fNapUKHfVdfb9PJsB530";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "disk" "networkmanager" "kvm" "plugdev" "video" "audio" ];
    };
    
  };
}
