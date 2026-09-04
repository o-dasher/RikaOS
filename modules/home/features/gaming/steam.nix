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
{
  options.features.gaming.steam.enable = lib.mkEnableOption "Steam autostart.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    xdg.autostart.entries = [
      (config.rika.utils.mkAutostartApp {
        pkg = steamPackage;
        args = "-silent";
      })
    ];
  };
}
