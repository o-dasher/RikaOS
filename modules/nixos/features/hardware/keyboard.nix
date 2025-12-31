{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.hardware.keyboard = {
    enable = lib.mkEnableOption "keyboard configuration (QMK/Via)";
  };

  config = lib.mkIf config.features.hardware.keyboard.enable {
    hardware.keyboard.qmk.enable = true;
    services.udev.packages = [ pkgs.via ];
  };
}
