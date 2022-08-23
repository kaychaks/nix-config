{ pkgs ? import <nixpkgs> {} }:
let
  ghc = pkgs.haskellPackages.ghcWithPackages (p: with p; [xmonad xmonad-contrib taffybar]);
in
pkgs.stdenv.mkDerivation {
  name = "my-xmonad";
  buildInputs = [ghc];
  shellHook = "eval $(egrep ^export ${ghc}/bin/ghc)";
}


