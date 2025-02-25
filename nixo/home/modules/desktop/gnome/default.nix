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
