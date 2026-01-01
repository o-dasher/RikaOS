{
  lib,
  config,
  ...
}:
{
  options.features.core.xdg = {
    enable = lib.mkEnableOption "xdg";
    portal.enable = lib.mkEnableOption "portal";
  };

  config = lib.mkIf config.features.core.xdg.enable {
    xdg = {
      enable = true;
      mime.enable = true;
      portal = lib.mkIf config.features.core.xdg.portal.enable {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };
  };
}
