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
    services.udev.packages = with pkgs; [
      qmk-udev-rules
      via
    ];
  };
}
