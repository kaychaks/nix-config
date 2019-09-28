self: pkgs:

  let
    pname = "zulip";
    version = "4.0.0";

    plat = {
      i386-linux = "i386";
      x86_64-linux = "x86_64";
    }.${pkgs.stdenv.hostPlatform.system};

    imageName = "Zulip";
    name = "${imageName}-${version}-${plat}";

    sha256 = {
      x86_64-linux = "1pni02mb5bvwx3k45vd6ga269ghdl633gjklyslai24rrhp16h9z";
    }.${pkgs.stdenv.hostPlatform.system};

    src = pkgs.fetchurl {
      url = "https://github.com/zulip/zulip-desktop/releases/download/v${version}/${name}.AppImage";
      inherit sha256;
    };

    appimageContents = pkgs.appimageTools.extractType2 {
      inherit name src;
    };

  in {

    zulip = pkgs.appimageTools.wrapType2 {
      inherit name src;

      extraInstallCommands = ''
        mv $out/bin/${name} $out/bin/${pname}
        install -m 444 -D ${appimageContents}/zulip.desktop $out/share/applications/zulip.desktop
        install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/zulip.png \
        $out/share/icons/hicolor/512x512/apps/zulip.png
        substituteInPlace $out/share/applications/zulip.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      '';

      meta = with pkgs.stdenv.lib; {
        description = "The world’s most productive team chat";
        longDescription = ''
          Zulip combines the immediacy of real-time chat with an email threading model.
          With Zulip, you can catch up on important conversations while ignoring irrelevant ones.
        '';
        homepage = https://zulipchat.com/;
        license = licenses.asl20;
        maintainers = with maintainers; [ kaychaks ];
        platforms = [ "x86_64-linux" ];
      };
    };
  }
