{ system, nixpkgs }: 
  let
    common = import ./common.nix { inherit nixpkgs; };
    rust = import ./rust.nix { inherit nixpkgs; };
    cpp = import ./cpp.nix { inherit nixpkgs; };
    js = import ./js.nix { inherit nixpkgs; };
  in
  {
    default = nixpkgs.mkShell {
      packages = common.packages ++ rust.packages ++ cpp.packages ++ js.packages;
      nativeBuildInputs = with nixpkgs; [ just ];
    };
  }
