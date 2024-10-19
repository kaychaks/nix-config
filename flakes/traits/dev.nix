{ config, pkgs, lib, ... } :
  {
    config = {
      environment.systemPackages = with pkgs; [
        direnv
        cachix
        openssl
        
        shellcheck
        python3
      ];
    };
  }
