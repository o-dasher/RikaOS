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
{
  options.features.gaming.heroic.enable = lib.mkEnableOption "heroic";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.heroic ];
    xdg = {
      autostart.entries = [ (config.rika.utils.mkAutostartApp { pkg = pkgs.heroic; }) ];
      configFile = lib.mapAttrs' (
        name: pkg:
        lib.nameValuePair "heroic/tools/proton/${name}" {
          source = pkg;
        }
      ) extraProtons;
    };
  };
}
