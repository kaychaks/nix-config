self: super: {
  installApplication =
    {
      name, appname ? name, version, src, description, homepage,
      postInstall ? "", sourceRoot ? ".", ...
    }:
    with super; stdenv.mkDerivation {
      name = "${name}-${version}";
      version = "${version}";
      inherit src;
      buildInputs = [ undmg unzip ];
      inherit sourceRoot;
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        mkdir -p "$out/Applications/${appname}.app"
        cp -pR * "$out/Applications/${appname}.app"
      '' + postInstall;
      meta = with stdenv.lib; {
        description = description;
        homepage = homepage;
        platforms = platforms.darwin;
      };
    };

    VSCode = self.installApplication rec {
      name = "VSCode";
      version = "1.35";
      sourceRoot = "Visual Studio Code.app";
      src = super.fetchurl {
        url = "https://az764295.vo.msecnd.net/stable/553cfb2c2205db5f15f3ee8395bbd5cf066d357d/VSCode-darwin-stable.zip";
        sha256 = "20b956707966ea02fb12b1edab8979c0e8d63167b84512d71182b3b6f43072d7";
        # date = 2019-06-09T13:16+0530;
      };
      description = "Code editing. Redefined. Free. Built on open source. Runs everywhere.";
      homepage = "https://code.visualstudio.com/";
    };

    Alfred = self.installApplication rec {
      name = "Alfred";
      version = "4";
      sourceRoot = "${name} ${version}.app";
      src = super.fetchurl {
        url = "https://cachefly.alfredapp.com/Alfred_4.0.1_1078.dmg";
        sha256 = "18x5h4laqagz067wiy8dgz1whwh9wpjw4k6q95gpp66jkhyy4zy7";
        # date = 2019-06-09T13:41+0530;
      };
      description = "Alfred is an award-winning app for macOS which boosts your efficiency with hotkeys, keywords, text expansion and more. Search your Mac and the web, and be more productive with custom actions to control your Mac.";
      homepage = "https://www.alfredapp.com/";
    };

}
