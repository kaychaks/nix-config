{ config, lib, pkgs, ... }:

{

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };

    overlays = [ (import ./config/emacs-config.nix) ];
  };

  environment = {
    systemPackages =
      let packages = {pkgs}:
        with pkgs;
        [
          coreutils

          # shells
          zsh
          tmux

          # tools
          direnv
          git
          jq
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
        ];
      in
      packages { inherit pkgs; };

    variables = {
      LC_CTYPE = "en_US.UTF-8";
      TERM = "xterm-256color";
      LANG = "en_US.UTF-8";
    };

    shellAliases = {
      setup-proxies = "$HOME/Developer/scripts/setup-proxies.sh && source ~/.zshrc";
      remove-proxies = "$HOME/Developer/scripts/remove-proxies.sh && source ~/.zshrc";
      Emacs = "/run/current-system/Applications/Emacs.app/Contents/MacOS/Emacs --daemon";
      ec = "nohup emacsclient -nqc \"$@\" &> /dev/null";
      cdp = "cd ~/Developer/src/personal/";
      cdw = "cd ~/Developer/src/work/";
      l = "ls -lah";
      ll = "ls -lh";
      la = "ls -lAh";
      d = "dirs -v | head -10";
    };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;
  nix = {
    package = pkgs.nix;
    maxJobs = 8;
    buildCores = 4;
    distributedBuilds = true;

  };

  programs.bash = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableBashCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableFzfHistory = true;
    promptInit = ''
      autoload -U promptinit && promptinit
      setopt PROMPTSUBST
      _prompt_nix() {
      [ -z "$IN_NIX_SHELL" ] || echo "%F{yellow}%B[''${name:+$name}λ]%b%f "
      }
      PS1='%F{blue}λ%f '
      RPS1='$(_prompt_nix)%F{green}%~%f'
    '';
    loginShellInit = ''
      take() {
        mkdir -p $@ && cd ''${@:$#}
      }
    '';
    interactiveShellInit = ''
      setopt AUTOCD AUTOPUSHD
      autoload -U down-line-or-beginning-search
      autoload -U up-line-or-beginning-search
      bindkey '^[[A' down-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      zle -N up-line-or-beginning-search
    '';
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

}
