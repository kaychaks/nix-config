# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  nix.extraOptions = ''
    netrc-file = /home/kaushik/.netrc
    connect-timeout = 5
    log-lines = 25
    min-free = 128000000
    max-free = 1000000000

    experimental-features = nix-command flakes
    fallback = true
    warn-dirty = false
    auto-optimise-store = true

    keep-outputs = true

  '';

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-096c1bc0-8d6c-4350-a0d7-cc5f8afe5995".device =
    "/dev/disk/by-uuid/096c1bc0-8d6c-4350-a0d7-cc5f8afe5995";
  boot.initrd.luks.devices."luks-096c1bc0-8d6c-4350-a0d7-cc5f8afe5995".keyFile =
    "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # keybase
  services.keybase.enable = true;
  services.kbfs.enable = true;

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

  # Enable GlobalProtect VPN (for work)
  services.globalprotect = {
    enable = true;
    # if you need a Host Integrity Protection report
    csdWrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kaushik = {

    isNormalUser = true;
    description = "Kaushik Chakraborty";
    extraGroups =
      [ "networkmanager" "wheel" "video" "audio" "disk" "systemd-journal" ];
    useDefaultShell = true;
    packages = with pkgs;
      [
        firefox
        #  thunderbird
      ];
  };

  users.defaultUserShell = pkgs.fish;

  home-manager.users.kaushik = import ./home.nix;

  # nix config
  nixpkgs.config = {

    # Allow unfree packages
    allowUnfree = true;

    packageOverrides = pkgs: {
      unstable = import <nixpkgs> { config = config.nixpkgs.config; };
    };
  };

  environment.variables = {
    LC_CTYPE = "en_US.UTF-8";
    TERM = "alacritty";
    LANG = "en_US.UTF-8";
    VISUAL = "vim";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    curl
    alacritty
    libnotify
    fish
    gcc
    clang
    globalprotect-openconnect
    gnomeExtensions.appindicator
    openssl
    binutils
    pkg-config
    unstable.neovim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.fish = {
    enable = true;
    shellInit = import ../plain-configs/fish/config.nix { inherit pkgs; };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.gnome.core-utilities.enable = true;
  security.pam = { services.gdm = { enableGnomeKeyring = true; }; };
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
