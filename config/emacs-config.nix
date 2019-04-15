self: pkgs:


## direcly copying from https://github.com/jwiegley/nix-config/blob/master/overlays/10-emacs.nix
{
  emacs26 = with pkgs; stdenv.lib.overrideDerivation
  (pkgs.emacs26.override { srcRepo = true; }) (attrs: rec {
    name = "emacs-${version}${versionModifier}";
    version = "26.1";
    versionModifier = ".92";
    doCheck = false;
    buildInputs = (attrs.buildInputs or []) ++
    [ git libpng.dev libjpeg.dev libungif libtiff.dev librsvg.dev
    imagemagick.dev ];
    patches = lib.optionals stdenv.isDarwin
    [ ../overlays/patches/tramp-detect-wrapped-gvfsd.patch
    ../overlays/patches/at-fdcwd.patch
    ../overlays/patches/emacs-26.patch ];

    CFLAGS = "-Ofast -momit-leaf-frame-pointer -DMAC_OS_X_VERSION_MAX_ALLOWED=101200";

    src = fetchgit {
      url = https://git.savannah.gnu.org/git/emacs.git;
      rev = "emacs-${version}${versionModifier}";
      sha256 = "0v6nrmf0viw6ahf8s090hwpsrf6gjpi37r842ikjcsakfxys9dmc";
      # date = 2019-02-20T07:33:53-08:00;
    };
  });
}
