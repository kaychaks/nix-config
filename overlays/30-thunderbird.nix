self: pkgs:

{
  thunderbird-beta = with pkgs; thunderbird-bin.overrideAttrs (old : rec {
    version = "70.0b4";
    src = fetchurl {
      url = "https://archive.mozilla.org/pub/thunderbird/releases/${version}/linux-x86_64/en-US/thunderbird-${version}.tar.bz2";
      sha512 = "1bm9i71337f5nwd2giq1127yp5m9s9krv24i9fnsv7d6i69ik8ivmy0mm1qmzzcha1gxxm06knlxg4105i33wzz529l2g9b33zsc4v8";
    };
  });
}
