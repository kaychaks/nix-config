{

  # Flakes around here would be used to configure Precision
  # and also to configure Mac.
  # Later, this would be extended to deploy to cloud.
  description = "Flake-over";

  inputs = {
    # stable nixpkgs
    nixpkgs_stable.url = "";
    # unstable nixpkgs
    nixpkgs_unstable.url = "";

    # home-manager
    home_manager = {
      url = "";
      # nixpkgs within home-manager is stable
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { self, nixpkgs_stable, nixpkgs_unstable, home_manager }: 
    let 
      supported_systems = [ "x86_64-linux" "x86_65-darwin" "aarch64-darwin" ];
      for_all_systems = f: nixpkgs_stable.lib.genAttrs supported_systems (system: f system);
    in 
      {
        devShells = for_all_systems
          (system: import ./shells { inherit system; nixpkgs = nixpkgs_stable; });

        nixosConfigurations = 
          let
            x86_64Base = {
              system = "x86_64-linux";
              modules = with self.nixosModules; [
                ({ config = { nix.registry.nixpkgs.flake = nixpkgs_stable; }; })
              ];
            };
          in
            with self.nixosModules; {
              precision = nixpkgs_stable.lib.nixosSystem {
                inherit (x86_64Base) system;
                modules = x86_65Base.modules ++ [
                  machines.precision.hardware
                ];
              };
          };

        nixosModules = {
          machines.precision.hardware = ./machines/precision/hardware.nix;
        };
      };
}
