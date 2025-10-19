{
  lib,
  config,
  ...
}:
{
  options.xdgSetup.enable = lib.mkEnableOption "xdgSetup" // {
    default = true;
  };

  config = lib.mkIf config.xdgSetup.enable {
    xdg = {
      enable = true;
      mime.enable = true;
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };
  };
}
