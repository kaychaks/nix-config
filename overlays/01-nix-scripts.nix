self: super: {

  nix-scripts = with self; stdenv.mkDerivation {
    name = "nix-scripts";

    src = ../mac/bin;

    buildInputs = [];

    installPhase = ''
      mkdir -p $out/bin
      find . -maxdepth 1 \( -type f -o -type l \) \
      -exec cp -pL {} $out/bin \;
    '';

  };
}
