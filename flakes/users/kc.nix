{ config, pkgs, lib, nixos-conf-editor, system, ... }:

let

  dconf_settings = import ./dconf.nix;
  eDP1 = "00ffffffffffff0006afeb4100000000221c0104b522137802af95a65435b5260f50540000000101010101010101010101010101010152d000a0f0703e803020350058c11000001a52d000a0f07068823020350025a51000001a000000fe00375837314880423135365a414e0000000000054122b2001200000b010a2020013902030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
  DP = "00ffffffffffff0010ace0404c353032271c0104b5371f783aa195af4f35b7260c5054a54b00714fa9408180d1c00101010101010101565e00a0a0a029503020350029372100001a000000ff003550564d503839513230354c0a000000fc0044454c4c20555032353136440a000000fd00324b1e5819010a20202020202001f302031cf14f90050403020716010611121513141f23091f0783010000023a801871382d40582c450029372100001e7e3900a080381f4030203a0029372100001a011d007251d01e206e28550029372100001ebf1600a08038134030203a0029372100001a00000000000000000000000000000000000000000000000000000086";
  notify = "${pkgs.libnotify}/bin/notify-send";
  rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
  };


in

{

  home.username = "kc";
  home.homeDirectory = "/home/kc";
  # home.sessionVariables.GTK_THEME = "palenight";
  home.sessionVariables = {
    # RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
  };

  nixpkgs.overlays = [ rust-overlay.overlays.default ];


  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Kaushik Chakraborty";
    userEmail = "git@kaushikc.org";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      credential.helper = "libsecret";
      branch.autosetupmerge = true;
      github.user = "kaychaks";
      pull.rebase = true;

      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        interactive = "auto";
        ui = "auto";
        sh = "auto";
      };
      
    };
    ignores = [
      "#*#"
      "*.a"
      "*.aux"
      "*.dylib"
      "*.elc"
      "*.glob"
      "*.la"
      "*.o"
      "*.so"
      "*.v.d"
      "*.vo"
      "*~"
      ".clean"
      ".direnv"
      ".envrc"
      ".envrc.override"
      ".ghc.environment.x86_64-darwin-*"
      ".makefile"
      "TAGS"
      "cabal.project.local"
      "dist-newstyle"
      "result"
      "result-*"
      "tags"
    ];
  };

  gtk = {
    enable = true;
    # iconTheme = {
    #   name = "Papirus-Dark";
    #   package = pkgs.papirus-icon-theme;
    # };
    # theme = {
    #   name = "palenight";
    #   package = pkgs.palenight-theme;
    # };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  dconf.settings = (dconf_settings { inherit lib; }).dconf.settings;

  programs.fish.enable = true;
  programs.helix = {
    enable = true;
  };

  home.packages = with pkgs; [

    gnomeExtensions.user-themes
    # gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.space-bar

    firefox
    dconf2nix

    unison-ucm
    # rustToolchain
    # rust-bin.stable.latest.default
    rust-analyzer
    python3
    shellcheck
    nodejs
    nixos-conf-editor.packages.${system}.nixos-conf-editor

    brave
  ];

  programs.autorandr = {
    enable = true;
    hooks = {
      predetect = { };

      preswitch = { };

      postswitch = {
        "change-dpi" = ''
          case "$AUTORANDR_CURRENT_PROFILE" in
            away)
              DPI=280
              ;;
            docked)
              DPI=280
              ;;
            clamshell)
              DPI=280
              ;;
            *)
              ${notify} -i display "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
              exit 1
          esac

          echo "Xft.dpi: $DPI" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
        '';
      };
    };
    profiles = {
      "away" = {
        fingerprint = {
          eDP-1 = eDP1;
        };
        config = {
          eDP-1 = {
            enable = true;
            primary = true;
            position= "0x0";
            mode = "3840x2160";
            rate = "60.0";
            rotate = "normal";
            # crtc = 0;
          };
        };
      };

      "clamshell" = {
        
        fingerprint = {
          DP-1-5 = DP;
        };
        config = {
          DP-1-5 = {
            enable = true;
            primary = true;
            position= "0x0";
            mode = "2560x1440";
            rate = "59.95";
            rotate = "normal";
            crtc = 0;
            dpi = 280;
          };
        };      
      };

      "docked" = {
        fingerprint = {
          eDP-1 = eDP1;
          DP-1-5 = DP;
        };
        config = {
          DP-1-5 = {
            enable = true;
            primary = true;
            position= "3840x0";
            mode = "2560x1440";
            rate = "59.95";
            rotate = "normal";
            # crtc = 0;
            dpi = 96;
          };
          eDP-1 = {
            enable = true;
            primary = false;
            position= "0x0";
            mode = "3840x2160";
            rate = "60.0";
            rotate = "normal";
            # crtc = 1;
          };
        };
      };
    };
  };


  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
  
}
