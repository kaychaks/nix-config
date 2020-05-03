self: pkgs:

{
  thunderbird-beta = with pkgs; thunderbird-bin.overrideAttrs (old : rec {
    version = "76.0b3";
    src = fetchurl {
      url = "https://archive.mozilla.org/pub/thunderbird/releases/${version}/linux-x86_64/en-US/thunderbird-${version}.tar.bz2";
      sha512 = "0ppflpfkfn4wz4gdy14fraraihbp1djh33cl79bgh85s050di47c9572w1g793r0zld4zbwf4nd551wwcdyv321vxq58waavgi8xpql";
    };
  });
}
