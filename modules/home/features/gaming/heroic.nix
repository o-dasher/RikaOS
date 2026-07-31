{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.heroic;
  extraProtons = {
    "GE-Proton" = pkgs.proton-ge-bin.steamcompattool;
  };
in
with lib;
{
  options.features.gaming.heroic.enable = lib.mkEnableOption "heroic";

  config = mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.heroic ];
    xdg = {
      autostart.entries = [ (config.rika.utils.mkAutostartApp { pkg = pkgs.heroic; }) ];
      configFile = mapAttrs' (
        name: pkg:
        nameValuePair "heroic/tools/proton/${name}" {
          source = pkg;
        }
      ) extraProtons;
    };
  };
}
