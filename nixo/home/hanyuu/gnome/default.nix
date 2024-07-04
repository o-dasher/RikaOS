{ pkgs, lib, ... }:
{
  home.packages =
    with pkgs;
    [
      dconf
      gnome-extension-manager
    ]
    ++ (with gnome; [
      dconf-editor
      gnome-shell-extensions
      gnome-control-center
      nautilus
    ]);

  programs.gnome-shell = {
    enable = true;
    extensions = [ { package = pkgs.gnomeExtensions.pop-shell; } ];
  };

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>c" ];
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
    };
  };
}
