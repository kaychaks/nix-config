{ nixpkgs }: {
  packages = with nixpkgs; [
    direnv
    cachix
    openssl
  ];
}
