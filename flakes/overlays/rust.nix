{self, super}: 
  let 
    rust_overlay.url = "github:oxalica/rust-overlay"; # A helper for Rust + Nix
  in {
    default = (import rust_overlay).default ++ {
      rustToolchain = super.rust-bin.stable.latest.default;
    };
  }
