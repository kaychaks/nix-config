self: super: {
  rofi-calc = with super; stdenv.mkDerivation rec {
    pname = "rofi-calc";
    version = "1.5";

    src = fetchFromGitHub {
      owner = "svenstaro";
      repo = "rofi-calc";
      rev = "v${version}";
      sha256 = "0mlghhvhj5j93np4yinizvfnk9zigbx83x1h0yq3j8242vy76vhs";
    };

    nativeBuildInputs = [ autoreconfHook wrapGAppsHook pkgconfig cairo glib ];
    buildInputs = [ rofi libqalculate];

    preConfigure = ''
      mkdir build
      cd build
    '';

    configureScript = "../configure";

    installPhase = ''
      mkdir -p $out/libs
      cp -a calc.la $out/calc.la
      cp -a .libs/* $out/libs
    '';

    meta = with stdenv.lib; {
      description = "A rofi plugin that uses libqalculate's qalc to parse natural language input and provide results.";
      homepage = "https://github.com/svenstaro/rofi-calc";
    };
  };
}
