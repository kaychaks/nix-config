# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	<home-manager/nixos>
    ];

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-2c1f1aa4-e802-46e4-9b59-a9a72376c287".device = "/dev/disk/by-uuid/2c1f1aa4-e802-46e4-9b59-a9a72376c287";
  boot.initrd.luks.devices."luks-2c1f1aa4-e802-46e4-9b59-a9a72376c287".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "tardis"; # Define your hostname.
  networking.hostId = "82525cc2";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.xserver.libinput = {
    touchpad.naturalScrolling = false;
    mouse.naturalScrolling = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kaushik = {
    isNormalUser = true;
    description = "Kaushik Chakraborty";
    uid = 1000;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "disk" "systemd-journal" "nixbld" ];
    useDefaultShell = true;
    packages = with pkgs; [
      #firefox-wayland
    ];
  };

  users.defaultUserShell = pkgs.fish;

  home-manager.users.kaushik = import ./home.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    alacritty
    font-manager
    libnotify
    fish
    _1password
    _1password-gui
    git-credential-1password
    zoom
  ];

  environment.gnome.excludePackages =(with pkgs; [
     gnome-photos
     gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    epiphany
    geary
    evince
    gnome-characters
    totem
    iagno
    atomix
    gnome-weather
    gnome-maps
  ]);

  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.fish = {
    enable = true;
    shellInit = import /home/kaushik/Dev/nix-config/plain-configs/fish/config.nix { inherit pkgs; };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.gnome.core-utilities.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.dbus.packages = [ pkgs.dconf ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
