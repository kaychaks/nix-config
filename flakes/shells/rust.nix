{ nixpkgs }: 
  let
  #   rust_overlay.url = "github:oxalica/rust-overlay"; # A helper for Rust + Nix
  #   overlays = [
  #     (import rust_overlay)
  #     (self: super: {
  #       # rust tool chain: stable
  #       rustToolchain = super.rust-bin.stable.latest.default;
  #     })
  #   ];
    pkgs = import nixpkgs {};
  in 
  {

    packages = (with pkgs; [
        rustToolChain
    ]) ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs; [ libiconv ]);
    
  }
