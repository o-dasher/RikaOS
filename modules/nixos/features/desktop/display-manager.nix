{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.desktop.displayManager = {
    gdm.enable = lib.mkEnableOption "GDM display manager";
  };

  config = lib.mkIf config.features.desktop.displayManager.gdm.enable {
    services.displayManager.gdm.enable = true;
  };
}
