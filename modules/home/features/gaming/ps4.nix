{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.gaming.ps4.enable = lib.mkEnableOption "ps4";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.ps4.enable) {
    home.packages = [
      pkgs.shadps4
    ];
  };
}
