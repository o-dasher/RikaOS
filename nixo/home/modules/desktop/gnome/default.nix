{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.desktop.gnome = with lib; {
    enable = mkEnableOption "gnome";
  };

  config = lib.mkIf config.desktop.gnome.enable {
    xdg.portal.extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs; [
        { package = gnomeExtensions.pop-shell; }
        { package = gnomeExtensions.unite; }
        { package = gnomeExtensions.blur-my-shell; }
        { package = gnomeExtensions.dash-to-dock; }
        { package = gnomeExtensions.tray-icons-reloaded; }
        { package = gnomeExtensions.freon; }
      ];
    };

    dconf.settings = {
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>c" ];
        toggle-fullscreen = [ "<Super>f" ];
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        switch-to-application-5 = [ ];
        switch-to-application-6 = [ ];
        switch-to-application-7 = [ ];
        switch-to-application-8 = [ ];
        switch-to-application-9 = [ ];
        switch-to-application-10 = [ ];
        move-to-workspace-1 = [ "<Shift><Super>1" ];
        move-to-workspace-2 = [ "<Shift><Super>2" ];
        move-to-workspace-3 = [ "<Shift><Super>3" ];
        move-to-workspace-4 = [ "<Shift><Super>4" ];
        move-to-workspace-5 = [ "<Shift><Super>5" ];
        move-to-workspace-6 = [ "<Shift><Super>6" ];
        move-to-workspace-7 = [ "<Shift><Super>7" ];
        move-to-workspace-8 = [ "<Shift><Super>8" ];
        move-to-workspace-9 = [ "<Shift><Super>9" ];
        move-to-workspace-10 = [ "<Shift><Super>0" ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-5 = [ "<Super>5" ];
        switch-to-workspace-6 = [ "<Super>6" ];
        switch-to-workspace-7 = [ "<Super>7" ];
        switch-to-workspace-8 = [ "<Super>8" ];
        switch-to-workspace-9 = [ "<Super>9" ];
        switch-to-workspace-10 = [ "<Super>0" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 10;
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        hot-keys = false;
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = lib.getExe pkgs.ghostty;
        name = "Terminal";
      };

      "org/gnome/shell/extensions/pop-shell" = {
        tile-enter = [ "<Super>?" ];
        toggle-stacking-global = [ "<Super>w" ];
      };

      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        sources = [
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "br"
          ])
        ];
      };
    };
  };
}
