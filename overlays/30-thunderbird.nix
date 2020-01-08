self: pkgs:

{
  thunderbird-beta = with pkgs; thunderbird-bin.overrideAttrs (old : rec {
    version = "72.0b1";
    src = fetchurl {
      url = "https://archive.mozilla.org/pub/thunderbird/releases/${version}/linux-x86_64/en-US/thunderbird-${version}.tar.bz2";
      sha512 = "2pi477wd5j5g5byw8643pkcg8pc7z3k4bj60fa0cg9vwzvvbyfdmv2xczx78gs9gg5xxcnd4b3d4571mys3yxmnd0gif9lnjv5gkp2i";
    };
  });
}
