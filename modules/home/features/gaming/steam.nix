{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.features.gaming.steam;
in
{
  options.features.gaming.steam.enable = lib.mkEnableOption "Steam";

  config = lib.mkIf (config.features.gaming.enable && cfg.enable) {
    systemd.user.services.steam = config.rika.utils.mkAutostartService "${lib.getExe pkgs.steam} -silent";
  };
}
