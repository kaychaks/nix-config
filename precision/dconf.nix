# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/Console" = {
      theme = "night";
    };

    "org/gnome/control-center" = {
      last-panel = "keyboard";
      window-state = mkTuple [ 948 1032 ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [ "gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.eog.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" "caps:ctrl_modifier" "rupeesign:4" ];
    };

    "org/gnome/desktop/interface" = {
      cursor-blink = true;
      enable-animations = false;
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      locate-pointer = true;
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "org-gnome-nautilus" "gnome-power-panel" "org-gnome-console" "firefox" ];
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
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
      close = [ "<Super>q" "<Alt>F4" ];
      maximize = [];
      minimize = [];
      move-to-monitor-down = [];
      move-to-monitor-left = [];
      move-to-monitor-right = [];
      move-to-monitor-up = [];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-down = [ "<Super><Shift>Down" "<Super><Shift>j" ];
      move-to-workspace-left = [ "<Super><Shift>Left" "<Super><Shift>l" ];
      move-to-workspace-right = [ "<Super><Shift>Right" "<Super><Shift>h" ];
      move-to-workspace-up = [ "<Super><Shift>Up" "<Super><Shift>k" ];
      switch-applications = [ "<Super>Tab" "<Alt>Tab" "<Super>space" ];
      switch-input-source = [];
      switch-input-source-backward = [];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-down = [ "<Primary><Super>Down" "<Primary><Super>j" ];
      switch-to-workspace-left = [ "<Primary><Super>Left" "<Primary><Super>l" ];
      switch-to-workspace-right = [ "<Primary><Super>Right" "<Primary><Super>h" ];
      switch-to-workspace-up = [ "<Primary><Super>Up" "<Primary><Super>k" ];
      toggle-maximized = [ "<Super>m" ];
      unmaximize = [];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close";
      focus-mode = "click";
      num-workspaces = 4;
    };

    "org/gnome/epiphany/state" = {
      is-maximized = false;
      window-position = mkTuple [ (-1) (-1) ];
      window-size = mkTuple [ 1024 768 ];
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/font-manager/font-viewer" = {
      window-position = mkTuple [ 26 23 ];
      window-size = mkTuple [ 546 299 ];
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = false;
      edge-tiling = true;
      focus-change-on-pointer-rest = false;
      workspaces-only-on-primary = true;
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [];
      toggle-tiled-right = [];
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [];
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      search-filter-time-type = "last_modified";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 550 ];
      maximized = false;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
      email = [];
      home = [ "<Super>e" ];
      rotate-video-lock-static = [];
      screensaver = [ "@as ['<Super>Escape']" ];
      terminal = [ "<Super>t" ];
      www = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "alacritty";
      name = "Open Alacritty";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "nothing";
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [];
      enabled-extensions = [ "pop-shell@system76.com" ];
      welcome-dialog-last-shown-version = "42.3.1";
    };

    "org/gnome/shell/extensions/pop-shell" = {
      active-hint = false;
      gap-inner = mkUint32 2;
      gap-outer = mkUint32 2;
      smart-gaps = true;
      snap-to-grid = false;
      tile-by-default = false;
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
      toggle-overview = [];
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
