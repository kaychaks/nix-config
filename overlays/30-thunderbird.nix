self: pkgs:

{
  thunderbird-beta = with pkgs; thunderbird-bin.overrideAttrs (old : rec {
    version = "74.0b2";
    src = fetchurl {
      url = "https://archive.mozilla.org/pub/thunderbird/releases/${version}/linux-x86_64/en-US/thunderbird-${version}.tar.bz2";
      sha512 = "02lxf01ysvk8hy8gkhfzrllxf0a9zkvr2r9bmyq3kdk9lvfpckmxd4s2bf4kxwp5xnzly94d72pvgpc7v0pxnyq9bpyq1wlhvczlmn4";
    };
  });
}
