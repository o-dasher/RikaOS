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
  config = mkIf (modCfg.enable && cfg.enable) {
    systemd.user.services.heroic = config.rika.utils.mkAutostartService (getExe pkgs.heroic);

    home.packages = [ pkgs.heroic ];
    xdg.configFile."heroic/tools/proton/GE-Proton".source = pkgs.proton-ge-bin.steamcompattool;
  };
}
