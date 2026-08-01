{
  lib,
  config,
  ...
}:
let
  cfg = config.features.core.xdg;
in
{
  options.features.core.xdg = {
    enable = lib.mkEnableOption "xdg";
    portal.enable = lib.mkEnableOption "portal";
  };

  config = lib.mkIf (config.features.core.enable && cfg.enable) {
    xdg = {
      enable = true;
      autostart = {
        enable = true;
        readOnly = true;
      };
      mime.enable = true;
      portal = lib.mkIf cfg.portal.enable {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };
  };
}
