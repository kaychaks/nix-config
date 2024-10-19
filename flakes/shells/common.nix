{ pkgs }: {
  packages = with pkgs; [
    direnv
    cachix
    openssl
  ];
}
