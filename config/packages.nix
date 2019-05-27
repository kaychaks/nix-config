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
  texlive.combined.scheme-full

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
  watchman
  nix-prefetch-git

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
  haskellPackages.Agda
  lean

]
