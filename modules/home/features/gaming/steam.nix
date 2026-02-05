{
  pkgs,
  lib,
  config,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.steam;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    systemd.user.services.steam = config.rika.utils.mkAutostartService "${getExe pkgs.steam} -silent";
  };
}
