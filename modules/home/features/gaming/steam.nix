{
  pkgs,
  lib,
  config,
  osConfig ? null,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.steam;
  steamPackage = if osConfig != null then osConfig.programs.steam.package else pkgs.steam;
in
with lib;
{
  options.features.gaming.steam.enable = mkEnableOption "Steam";

  config = mkIf (modCfg.enable && cfg.enable) {
    xdg.configFile = config.rika.utils.mkAutostartApp steamPackage "${getExe steamPackage} -silent";
  };
}
