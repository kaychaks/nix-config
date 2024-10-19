{

  # Flakes around here would be used to configure Precision
  # and also to configure Mac.
  # Later, this would be extended to deploy to cloud.
  description = "Flake-over";

  inputs = {
    # stable nixpkgs
    nixpkgs_stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    # unstable nixpkgs
    nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      # nixpkgs within home-manager is stable
      inputs.nixpkgs.follows = "nixpkgs_unstable";
    };

    nixpkgs.follows = "nixpkgs_unstable";

    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";

    unison-lang = {
      url = "github:ceedubs/unison-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = { self, nixpkgs, home-manager, nixos-conf-editor, unison-lang,... }: 
    let 
      supported_systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      for_all_systems = f: nixpkgs.lib.genAttrs supported_systems (system: f system);
    in 
      {


      
        # homeConfigurations = for_all_systems
        # (system:
          # let
          #   pkgs = import nixpkgs {
          #     inherit system;
          #     overlays = [ unison-lang.overlay rust-overlay.overlays ];
          #   };
          # in
          # {
            # kc = home-manager.lib.homeManagerConfiguration {
              # inherit system;
              # modules = [
                # ./users/kc.nix
              # ];
            # };
          # }
        # );


        nixosConfigurations = 
          let
            system = "x86_64-linux";
            x86_64Base = {
              inherit system;
              modules = with self.nixosModules; [
                ({ config = { nixpkgs.overlays = [ unison-lang.overlay ]; nix.registry.nixpkgs.flake = nixpkgs; }; })
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.kc = import ./users/kc.nix;
                  home-manager.extraSpecialArgs = { inherit nixos-conf-editor; system = "x86_64-linux"; };
                }
              ];
            };
          in
            with self.nixosModules; {
              precision = nixpkgs.lib.nixosSystem {
                inherit (x86_64Base) system;
                modules = x86_64Base.modules ++ [
                  machines.precision-hardware
                  machines.precision
                  traits.machine
                  traits.security
                  traits.dev
                  traits.gnome
                  users
                ];
              };
          };

        nixosModules = {
          machines.precision-hardware = ./machines/precision/hardware.nix;
          machines.precision = ./machines/precision;

          traits.dev = ./traits/dev.nix;
          traits.gnome = ./traits/gnome.nix;
          traits.security = ./traits/security.nix;
          traits.machine = ./traits/machine.nix;

          users = ./users;
        };
      };
}
