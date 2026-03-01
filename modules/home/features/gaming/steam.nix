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
  options.features.gaming.steam.enable = mkEnableOption "Steam";

  config = mkIf (modCfg.enable && cfg.enable) {
    xdg.configFile = config.rika.utils.mkAutostartApp pkgs.steam "${getExe pkgs.steam} -silent";
  };
}
