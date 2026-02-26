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
  options.features.core.xdg = {
    enable = mkEnableOption "xdg";
    portal.enable = mkEnableOption "portal";
  };

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
