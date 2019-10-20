{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  boot.cleanTmpDir = true;
  networking.hostName = "kutir-nixos";

  nix = {
    autoOptimiseStore = true;
    buildCores = 1;
  };

  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  networking.firewall.allowedUDPPorts = [ 9993 ];
  networking.firewall.allowedTCPPorts = [ 5000 ];
  services.zerotierone.enable = true;

  services.znc = {
    enable = true;
    mutable = false;
    openFirewall = true;
    modulePackages = with pkgs.zncModules; [ push clientbuffer playback ];
    config = {
      User.zncadmin = {
        Buffer = 5000;
        KeepBuffer = true;
        MultiClients = true;
        BounceDCCs = true;
        DenyLoadMod = false;
        DenySetVHost = false;
        DCCLookupMethod = "default";
        TimestampFormat = [ "%H:%M:%S" ];
        AppendTimestamp = false;
        PrependTimestamp = true;
	      JoinTries = 10;
        MaxJoins = 5;
        ChanModes = "+stn";
        TimezoneOffset = "0.00";
	      Timezone = "Asia/Kolkata";
	      ClientEncoding = "UTF-8";
      };
    };
    confOptions = {
      modules = ["webadmin" "partyline" "adminlog" "log" ];
      userModules = [ "push" "controlpanel" "clientbuffer" ];
      userName = "zncadmin";
      networks = {
        "freenode" = {
          server = "irc.freenode.net";
          port = 6697;
          useSSL = true;
          modules = [ "simple_away" "savebuff" ];
          channels = [
            "haskell"
            "haskell-lens"
            "haskell-beginners"
            "scalaz"
            "qfpl"
            "nixos"
            "Nix"
            "#coda"
            "reflex-frp"
          ];
        };
      };
      nick = "kaychaks";
      passBlock = ''
        <Pass password>
          Method = sha256
          Hash = 5bc8618e90014ddb0e584528b16d1dc882719ad229b5e77fa47f14dc705e1db7
          Salt = F+?s9cS-3dCbWg.:yRZM
        </Pass>
      '';
    };
  };

  environment = {
    systemPackages = with pkgs; [
	    vim
	    curl
	    git
	    htop
	    tmux
      cryptsetup
    ];
  };

  swapDevices = [ { device = "/swapfile"; } ];

  users.extraUsers.kaushikc = {
    home = "/home/kaushikc";
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    uid = 1000;
    openssh.authorizedKeys.keys = [
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlInYV7HY/ZyNki8rL6BHJsPy9NlLutIwrKPFTsHASQKZRFM/jfBHzTtHi5sbuvg7/kkXp//8jNkyKOu0e5ciw3+THHLcq0MhEAdpuXvjwT9dnJ1BXPC1DzoxefwuBM6iBnQoj84AYRcp9F+Oz37oH3I8lUoohuMIG8QmfdWmNZiTOOJYYobYZ1tDKwZX+gr9/7fAZ1CnYkDJb5ts2usSObcnYjqtWL+FECFmqUReoVykn6RFtO+6zAzfNxTwUS9ydiwWU8lWhqW/clZoSIRWZq+wNs7UPUbUkNqB17soiZZLnK47kSe4WWgRcrWRPzVQZKm13QKZxBYvtYSyV/+qX"
    ];
  };
}
