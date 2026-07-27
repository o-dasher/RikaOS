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
    "Proton-Cachyos" = pkgs.nur.repos.forkprince.proton-cachyos-v3-bin;
  };
in
{
  options.features.gaming.heroic.enable = lib.mkEnableOption "heroic";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home.packages = [ pkgs.heroic ];
    xdg.configFile =
      (config.rika.utils.mkAutostartApp pkgs.heroic (lib.getExe pkgs.heroic))
      // (lib.mapAttrs' (
        name: pkg:
        lib.nameValuePair "heroic/tools/proton/${name}" {
          source = pkg;
        }
      ) extraProtons);
  };
}
