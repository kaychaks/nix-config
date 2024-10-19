{ final, prev }:

  let 
    rust = import ./rust.nix { inherit final prev; };
  {
    default = rust.default;
  }
