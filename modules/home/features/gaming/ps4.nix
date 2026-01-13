{
  lib,
  config,
  ...
}:
{
  options.features.gaming.ps4.enable = lib.mkEnableOption "ps4";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.ps4.enable) {
    services.flatpak.packages = [ "net.shadps4.shadPS4" ];
  };
}
