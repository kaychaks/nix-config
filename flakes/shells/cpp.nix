{ nixpkgs }: {
  packages = with nixpkgs; [
    boost
    gcc
  ];
}
