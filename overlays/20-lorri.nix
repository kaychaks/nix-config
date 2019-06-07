self: super: {
  lorri =
    let src = super.fetchFromGitHub {
      # owner = "target";
      owner = "kaychaks"; # https://github.com/target/lorri/issues/27
      repo = "lorri";
      rev = "d7ebd3bff7ff3ed6c29441038b6fec57fa9d28a4";
      sha256 = "11nkvvrk2fwy1773hj3m2s9lm4x7l8h7s6vr1rqhig7zrf7jxhw3";
      # date = 2019-05-27T16:47:00+0530;
    }; in
    import src { inherit src; pkgs = self; };
}
