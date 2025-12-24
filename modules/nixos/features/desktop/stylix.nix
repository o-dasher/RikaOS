{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.desktop.stylix = {
    enable = lib.mkEnableOption "stylix theming";
  };

  config = lib.mkIf config.features.desktop.stylix.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    };
  };
}
