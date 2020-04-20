# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let

  wayland-pkgs = builtins.fetchGit {url = "https://github.com/colemickens/nixpkgs-wayland.git";};

  in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot = {
      # Use the systemd-boot EFI boot loader.
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      # linux v5.3 is not yet supported by stable zfs
      zfs.enableUnstable = true;

      # Use kernel >5.1
      kernelPackages = pkgs.linuxPackages_latest;

      # Swapping Cmd and Alt keys of Apple Keyboard
      kernelParams = [
        "hid_apple.swap_opt_cmd=1"
        "hid_apple.fnmode=2"
        "hid_magicmouse.emulate_3button=N"
        "hid_magicmouse.scroll_speed=55"
      ];

      #earlyVconsoleSetup = true;
  };

  powerManagement.powertop.enable = true;

  networking = {
    hostName = "tardis";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    interfaces.wlp111s0.useDHCP = true;
  };


  nix = {
    autoOptimiseStore = true;
    extraOptions = "binary-caches-parallel-connections = 5";

    nixPath =
      [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs"
        "nixos-config=/etc/nixos/configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://cachix.cachix.org"
      "https://nixcache.reflex-frp.org"
      "https://hydra.iohk.io"
      # "http://hydra.qfpl.io"
      # "https://qfpl.cachix.org"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      # "qfpl.io:xME0cdnyFcOlMD1nwmn6VrkkGgDNLLpMXoMYl58bz5g="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      # "qfpl.cachix.org-1:JTTxGW07zLPAGglHlMbMC3kQpCd6eFRgbtnuorCogYw="
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];
    trustedUsers = [ "root" "kaushik" ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    config.pulseaudio = true;
    overlays = [
      (import "${wayland-pkgs}/default.nix")
    ];
  };

  time = {
    timeZone = "Asia/Kolkata";
  };

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth = {
      enable = true;
      package = pkgs.bluezFull;
    };
  };

  virtualisation.docker = {
    enable = true;
  };

  i18n = {
    #consoleFont = "latarcyrheb-sun32";
    #consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    keyMap = "us";
    font = "latarcyrheb-sun32";
    earlySetup = true;
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      source-code-pro
      terminus_font
      fira-code
      font-awesome
      liberation_ttf
      ubuntu_font_family
      powerline-fonts
      vegur
    ];
    fontconfig = {
      # dpi = 180;
      hinting.enable = false;
      defaultFonts = {
        monospace = [ "SF Mono" "Fira Code" "Source Code Pro" "Ubuntu Mono"];
        sansSerif = [ "SF Display" "Liberation Sans" "Arial" "Ubuntu" ];
        serif = [ "New York" "Liberation Serif" "Times New Roman" ];
      };
    };
  };

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    upower.enable = true;
    openssh.enable = true;
    devmon.enable = true;
    dbus.packages = [ pkgs.blueman ];
    blueman.enable = true;

    keybase.enable = true;

    kbfs = {
      enable = true;
      mountPoint = "%h/.config/keybase/kbfs";
    };

    xserver = {
      enable = true;
      layout = "us";
      exportConfiguration = true;

      autoRepeatInterval = 30;
      autoRepeatDelay = 220;
      xkbOptions = "ctrl:nocaps,rupeesign:4,ctrl:swap_lalt_lctl_lwin";

      # GPU
      # videoDrivers = [ "amdgpu" ];

      # DPI
      # monitorSection = ''
      #   DisplaySize 406 228
      # '';

      # Enable touchpad support.
      libinput = {
        enable = true;
        naturalScrolling = false;
        disableWhileTyping = true;
        accelSpeed = "0.9";
      };

      #displayManager.extraSessionFilePackages = [ pkgs.sway ];
      displayManager.sessionPackages = [ pkgs.sway ];
      displayManager = {
        lightdm = {
          enable = true;
          greeters.pantheon.enable = true;
        };
      };
    };

    zerotierone.enable = false;
  };

  systemd = {
    packages = with pkgs.gnome3; [ gnome-session gnome-shell ];
  };

  environment = {
    variables = {
      LC_CTYPE = "en_US.UTF-8";
      TERM = "tmux-256color";
      LANG = "en_US.UTF-8";
      VISUAL = "vim";
      XCURSOR_SIZE = "32";
    };
    pathsToLink = [ "/home/kaushik/.gem/ruby/2.6.0/bin" ];
    systemPackages = with pkgs; [
      # Tools
      aspell
      aspellDicts.en
      blueman
      curl
      dmenu
      gnumake
      gparted
      htop
      manpages
      nmap
      openssl
      traceroute
      tree
      unzip
      wget
      which
      zlib
      zip
      arandr
      binutils
      bind
      file
      gcc6
      iptables
      nmap
      sudo
      wireshark
      pavucontrol
      lsof
      mkvtoolnix
      hpx
      usbutils

      # Apps
      keybase-gui
      firefox-wayland

      # X
      gnome-breeze
      gnome3.adwaita-icon-theme
      xclip
      xfontsel
      xlsfonts
      xorg.xbacklight

      # Haskell Desktop
      # haskellPackages.gtk-sni-tray
      # haskellPackages.status-notifier-item
      haskellPackages.xmonad
      haskellPackages.dbus-hslogger
    ];
  };

  programs = {
    dconf.enable = true;
    zsh = {
      enable = true;
    };

    sway = {
      enable = true;
      extraPackages = with pkgs; [
        xwayland
        swaylock
        swayidle
        termite
        wofi
        i3status
        waybar
        swaybg
        mako
        clipman
        wlogout
      ];
      extraSessionCommands = ''
        # Tell toolkits to use wayland
        export CLUTTER_BACKEND=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export SDL_VIDEODRIVER=wayland
        export MOZ_ENABLE_WAYLAND=1
        export MOZ_DBUS_REMOTE=1
        export _JAVA_AWT_WM_NONREPARENTING=1

        # Disable HiDPI scaling for X apps
        # https://wiki.archlinux.org/index.php/HiDPI#GUI_toolkits
        export GDK_SCALE=2
        # export QT_SCREEN_SCALE_FACTORS="2;2"
        export QT_FONT_DPI=96
        # export QT_AUTO_SCREEN_SCALE_FACTOR=0
      '';
    };
  };

  users.users.kaushik = {
     isNormalUser = true;
     shell = pkgs.zsh;
     uid = 1000;
     initialHashedPassword = "";
     extraGroups = [ "wheel" "networkmanager" "video" "audio" "disk" "sway" ];
  };


  system.stateVersion = "19.09";
  system.autoUpgrade.enable = false;
}

