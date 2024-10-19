{ config, pkgs, lib, ... } :

{

  config = {

    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.displayManager.autoLogin.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      gedit # text editor
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      yelp # Help view

      
      gnome-music
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-contacts
      gnome-initial-setup
    ]);

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnome-characters
    ];

    services.gnome.gnome-keyring.enable = true;
    programs.dconf.enable = true;

    # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
    # If no user is logged in, the machine will power down after 20 minutes.
    # This results in a `wall` style message which disrupts console users.
    systemd.targets.sleep.enable = false;
    systemd.targets.suspend.enable = false;
    systemd.targets.hibernate.enable = false;
    systemd.targets.hybrid-sleep.enable = false;
    services.xserver.displayManager.gdm.autoSuspend = false;

  };

} 
