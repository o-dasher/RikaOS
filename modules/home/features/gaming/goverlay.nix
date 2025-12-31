{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.gaming.goverlay.enable = lib.mkEnableOption "goverlay";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.goverlay.enable) {
    home.packages = [ pkgs.goverlay ];
  };
}
