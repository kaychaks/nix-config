{ pkgs, ... } :

{

  config = {
    users.mutableUsers = true;

    programs.nm-applet.enable = true;
  
    fonts.fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      hinting.style = "full";
    };

    fonts.enableDefaultPackages = true;
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      fira-code
      fira-code-symbols
    ];

    environment.systemPackages = with pkgs; [
    ];

    services.printing.enable = true;

    virtualisation.podman.enable = true;
  };
}
