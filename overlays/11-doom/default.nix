(self: super:
let gitinfo = self.lib.importJSON ./git.json;
in {
  emacs-doom = super.stdenv.mkDerivation {
    name = "emacs-doom";
    src = self.fetchgit {
      inherit (gitinfo) url rev sha256;
    };
    installPhase = ''
      mkdir ${builtins.getEnv "HOME"}/.emacs.d
      cp -r * ${builtins.getEnv "HOME"}/.emacs.d
      mkdir $out
      ln -s ${builtins.getEnv "HOME"}/.emacs.d/bin $out/bin
    '';
  };
})
