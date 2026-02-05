{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.core;
  cfg = modCfg.xdg;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    xdg = {
      enable = true;
      mime.enable = true;
      portal = mkIf cfg.portal.enable {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };
  };
}
