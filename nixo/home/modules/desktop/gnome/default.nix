{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.gnome = with lib; {
    enable = mkEnableOption "gnome";
  };

  config = lib.mkIf config.gnome.enable {
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
