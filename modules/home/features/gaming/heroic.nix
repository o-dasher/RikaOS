{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.heroic;
in
with lib;
{
  options.features.gaming.heroic.enable = mkEnableOption "heroic";

  config = mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.heroic ];
    xdg.configFile =
      config.rika.utils.mkAutostartApp pkgs.heroic (getExe pkgs.heroic)
      // {
        "heroic/tools/proton/GE-Proton".source = pkgs.proton-ge-bin.steamcompattool;
      };
  };
}
