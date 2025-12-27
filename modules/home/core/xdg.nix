{
  lib,
  config,
  ...
}:
{
  options.xdgSetup = {
    enable = lib.mkEnableOption "xdgSetup";
    portal.enable = lib.mkEnableOption "portal" // {
      default = true;
    };
  };

  config = lib.mkIf config.xdgSetup.enable {
    xdg = {
      enable = true;
      mime.enable = true;
      portal = lib.mkIf config.xdgSetup.portal.enable {
        enable = true;
        xdgOpenUsePortal = true;
        config.common.default = [ "*" ];
      };
    };
  };
}
