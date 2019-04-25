{ pkgs }:

with pkgs;
let exe = haskell.lib.justStaticExecutables;
in
[
  nix-scripts
  coreutils
  home-manager

  # shells
  zsh
  tmux

  # tools
  direnv
  git
  jq
  aspell
  aspellDicts.en
  vim
  emacs26

  # system
  htop
  fzf
  less
  nix-bash-completions
  nix-zsh-completions
  time
  tree
  unrar
  unzip
  ripgrep
  gnutar

  # networking
  openssl
  youtube-dl
  ffmpeg
  pandoc
  curl
  wget
  rsync
  # cachix
  cacert

  # x11
  xquartz


  # from brew
  libedit
  libunwind
  libyaml
  libossp_uuid
  pkg-config
  unixODBC
  zlib
  gmp


  # dev
  julia
  haskell.packages.ghc844.Agda
  lean

  # haskell
  (exe haskellPackages.cabal-install)
  (exe haskellPackages.cabal2nix)
  (exe haskellPackages.fast-tags)
  (exe haskellPackages.ghcid)
  (exe haskellPackages.hlint)
  (exe haskellPackages.hoogle)
  (exe haskellPackages.pointfree)
  (exe haskellPackages.stylish-haskell)
]
