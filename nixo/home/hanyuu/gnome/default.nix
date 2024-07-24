{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      dconf
      dconf-editor
      nautilus
      gnome-tweaks
      gnome-extension-manager
    ]
    ++ (with gnome; [
      gnome-shell-extensions
      gnome-control-center
    ]);

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.pop-shell; }
      { package = pkgs.gnomeExtensions.unite; }
    ];
  };

  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>c" ];
      toggle-fullscreen = [ "<Super>f" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = lib.getExe pkgs.wezterm;
      name = "Terminal";
    };

    "org/gnome/shell/extensions/pop-shell" = {
      tile-enter = [ "<Super>?" ];
      toggle-stacking-global = [ "<Super>w" ];
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.wezfurlong.wezterm.desktop"
      ];
    };
  };
}
