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
  # lorri
  git
  jq
  aspell
  aspellDicts.en
  vim
  emacs26
#  texlive.combined.scheme-full
  VSCode
  # Alfred
  multimarkdown
  pandoc

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
  clang
  fd

  # networking
  openssl
  youtube-dl
  ffmpeg
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
  # julia
  # haskellPackages.Agda
  # lean
  sbt-extras
  jdk


  nodejs_latest
  # nodejs-12_x
  nodePackages.node2nix
  nodePackages.eslint
  nodePackages.prettier
  nodePackages.tern
  nodePackages.typescript-language-server
  nodePackages.typescript

<<<<<<< HEAD
=======

>>>>>>> master
  (exe haskellPackages.cabal-install)
  (exe haskellPackages.cabal2nix)
  (exe haskellPackages.fast-tags)
  (exe haskellPackages.ghcid)
  (exe haskellPackages.hlint)
  (exe haskellPackages.hoogle)
  (exe haskellPackages.pointfree)
  (exe haskellPackages.stylish-haskell)
]
