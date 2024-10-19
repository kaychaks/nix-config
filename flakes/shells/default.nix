{ pkgs, nixpkgs }: 
  let
    common = import ./common.nix { inherit pkgs; };
    rust = import ./rust.nix { inherit nixpkgs; };
    cpp = import ./cpp.nix { inherit pkgs; };
    js = import ./js.nix { inherit pkgs; };
    unison = import ./unison.nix { inherit pkgs; };

  in
  {
    default = pkgs.mkShell {
      packages = common.packages ++ js.packages ++ cpp.packages ++ rust.packages;
      buildInputs = with pkgs; [ just ];
    };
  }
