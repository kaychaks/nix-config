# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

      earlyVconsoleSetup = true;
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
      "http://hydra.qfpl.io"
      "https://qfpl.cachix.org"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
      "qfpl.io:xME0cdnyFcOlMD1nwmn6VrkkGgDNLLpMXoMYl58bz5g="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "qfpl.cachix.org-1:JTTxGW07zLPAGglHlMbMC3kQpCd6eFRgbtnuorCogYw="
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];
    trustedUsers = [ "root" "kaushik" ];
  };

  nixpkgs = {
    config.allowUnfree = true;
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
    brightnessctl.enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  i18n = {
    consoleFont = "latarcyrheb-sun32";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      source-code-pro
      terminus_font
      fira-code
      font-awesome_5
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

      autoRepeatInterval = 40;
      autoRepeatDelay = 220;
      xkbOptions = "ctrl:nocaps,rupeesign:4,ctrl:swap_lalt_lctl_lwin";

      # GPU
      # videoDrivers = [ "amdgpu" ];

      # DPI
      monitorSection = ''
        DisplaySize 406 228
      '';

      # Enable touchpad support.
      libinput = {
        enable = true;
        naturalScrolling = false;
        disableWhileTyping = true;
        accelSpeed = "0.9";
      };
      windowManager.xmonad.enable = true;

      displayManager = {
        lightdm.enable = true;
        # lightdm.greeters.pantheon.enable = true;
      };

      # Enable the GNome Desktop Environment
      # desktopManager = {
      #   gnome3.enable = true;
      #   xterm.enable = true;
      #   default = "none";
      # };

      # displayManager = {
      #   gdm.enable = true;

      #   # only way to encode settings in gnome3, weird
      #   sessionCommands = ''
      #     dconf write /org/gnome/desktop/peripherals/keyboard/repeat-interval 'uint32 20'
      #     dconf write /org/gnome/desktop/peripherals/keyboard/delay 'uint32 300'

      #     dconf write /org/gnome/desktop/peripherals/touchpad/natural-scroll false

      #     dconf write /org/gtk/settings/file-chooser/clock-format "'24h'"

      #     dconf write /org/gnome/desktop/interface/gtk-key-theme "'Emacs'"
      #     dconf write /org/gnome/desktop/interface/gtk-theme "'Adwaita-dark'"

      #     dconf write /org/gnome/desktop/interface/monospace-font-name "'SF Mono 13'"
      #     dconf write /org/gnome/desktop/interface/font-name "'SF Pro Display 13'"
      #     dconf write /org/gnome/desktop/interface/document-font-name "'SF Pro Display Medium 13'"
      #     dconf write /org/gnome/desktop/wm/preferences/titlebar-font "'SF Pro Display Bold 13'"
      #     dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/font "'SF Mono 14'"
      #     dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/audible-bell false

      #     dconf write /org/gnome/desktop/input-sources/xkb-options  "['rupeesign:4', 'ctrl:nocaps', 'ctrl:swap_lalt_lctl_lwin']"


      #     dconf write /org/gnome/desktop/wm/keybindings/switch-applications "['<Primary>Tab', '<Alt>Tab', '<Primary>Space']"
      #     dconf write /org/gnome/desktop/wm/keybindings/switch-applications-backward "['<Primary><Shift>Tab', '<Alt><Shift>Tab', '<Primary><Shift>Space']"
      #     dconf write /org/gnome/settings-daemon/plugins/media-keys/search "'<Alt>space'"
      #     dconf write /org/gnome/desktop/wm/keybindings/switch-group "['<Primary>grave']"
      #     dconf write /org/gnome/desktop/wm/keybindings/switch-group-backward "['<Primary><Shift>grave']"
      #     dconf write /org/gnome/desktop/wm/keybindings/close "['<Alt>F4', '<Primary>q']"

      #     dconf write /org/gnome/desktop/privacy/disable-camera true
      #     dconf write /org/gnome/desktop/privacy/disable-microphone true
      #     dconf write /org/gnome/desktop/privacy/remove-old-temp-files true
      #     dconf write /org/gnome/desktop/privacy/remove-old-trash-files true
      #   '';


      # };
    };

    zerotierone.enable = true;
  };

  environment = {
    variables = {
      LC_CTYPE = "en_US.UTF-8";
      TERM = "tmux-256color";
      LANG = "en_US.UTF-8";
      VISUAL = "vim";
      XCURSOR_SIZE = "32";
    };
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

      # Apps
      keybase-gui

      # X
      gnome-breeze
      gnome3.adwaita-icon-theme
      xclip
      xfontsel
      xlsfonts
      xorg.xbacklight

      # Haskell Desktop
      haskellPackages.gtk-sni-tray
      haskellPackages.status-notifier-item
      haskellPackages.xmonad
      haskellPackages.dbus-hslogger
    ];
  };

  programs = {
    dconf.enable = true;
    zsh = {
      enable = true;
    };
  };

  users.users.kaushik = {
     isNormalUser = true;
     shell = pkgs.zsh;
     uid = 1000;
     initialHashedPassword = "";
     extraGroups = [ "wheel" "networkmanager" "video" "audio" "disk" ];
  };


  system.stateVersion = "19.09";
  system.autoUpgrade.enable = false;
}

