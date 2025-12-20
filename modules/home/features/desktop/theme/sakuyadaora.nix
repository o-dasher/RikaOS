{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.theme.sakuyadaora.enable {
    stylix = {
      image = ../../../../../assets/Wallpapers/sakuyadaora.jpg;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      opacity =
        let
          v = 0.9;
        in
        {
          popups = v;
          terminal = v;
        };
    };
  };
}
