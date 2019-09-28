self: pkgs:

{
  thunderbird-beta = with pkgs; thunderbird-bin.overrideAttrs (old : rec {
    version = "70.0b2";
    src = fetchurl {
      url = "https://archive.mozilla.org/pub/thunderbird/releases/70.0b2/linux-x86_64/en-US/thunderbird-${version}.tar.bz2";
      sha512 = "03yzvih62kag2sc76xx57mg3y63q3kp76g8m4aq1qk7rc5ah7zfl5bi004kfhb2x8dix29y65nh2prs17fgdg14yvvafjs58hrf73xc";
    };
  });
}
