{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.features.hardware.keyboard;
in
{
  options.features.hardware.keyboard.enable = lib.mkEnableOption "keyboard configuration (QMK/Via)";

  config = lib.mkIf (config.features.hardware.enable && cfg.enable) {
    hardware.keyboard.qmk.enable = true;
    services.udev.packages = [ pkgs.via ];
  };
}
