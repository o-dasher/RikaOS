{ lib, config, ... }:
{
  options.gnome = with lib; {
    enable = mkEnableOption "gnome";
  };

  config = lib.mkIf config.gnome.enable {
    dconf.settings = with lib; {
      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        sources = [
          (mkTuple [
            "xkb"
            "br"
          ])
        ];
      };
    };
  };
}
