{ lib, config, ... }:
{
  options.gnome = with lib; {
    enable = mkEnableOption "gnome";
  };

  config = lib.mkIf config.gnome.enable {
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
