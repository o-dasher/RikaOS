{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.gaming.heroic.enable = lib.mkEnableOption "heroic";

  config = lib.mkIf (config.features.gaming.enable && config.features.gaming.heroic.enable) {
    systemd.user.services.heroic = config.rika.utils.mkAutostartService (lib.getExe pkgs.heroic);
    home.packages = [
      pkgs.heroic
    ];
  };
}
