{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {

    "org/gnome/Console" = {
      theme = "palenight";
    };


    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" "caps:ctrl_modifier" "rupeesign:4" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-blink = true;
      enable-animations = false;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      locate-pointer = true;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      delay = mkUint32 226;
      numlock-state = true;
      repeat = true;
      repeat-interval = mkUint32 6;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = false;
      speed = 0.833333;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      maximize = [ "<Super>m" ];
      switch-applications-backward = [ "<Shift><Alt>Tab" "<Shift><Super><Space>" ];
      switch-input-source = [];
      switch-input-source-backward = [];
      switch-applications = [ "<Super>space" "<Alt>Tab" ];
      toggle-overview = [ "<Super>s" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close";
      focus-mode = "click";
      num-workspaces = 4;
      workspace-names = [ "Main" ];
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disable-extension-version-validation = true;
      disabled-extensions = [];
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
        "Vitals@CoreCoding.com"
        "dash-to-panel@jderose9.github.com"
        "space-bar@luchrioh"
      ];
      favorite-apps = [ "org.gnome.Calendar.desktop" "org.gnome.Nautilus.desktop" "firefox.desktop" "org.gnome.Settings.desktop" ];
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "palenight";
    };

    "org/gnome/shell/extensions/vitals" = {
      show-storage = false;
      show-voltage = true;
      show-memory = true;
      show-fan = true;
      show-temperature = true;
      show-processor = true;
      show-network = true;
    };


    "org/gnome/shell/keybindings" = {
      open-application-menu = [];
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
      toggle-message-tray = [ "<Super>v" ];
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 157;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [ 358 81 ];
      window-size = mkTuple [ 1203 902 ];
    };

  };
}

