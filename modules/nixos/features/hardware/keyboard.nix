{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.hardware;
  cfg = modCfg.keyboard;
in
{
  options.features.hardware.keyboard.enable =
    lib.mkEnableOption "keyboard flashing and customization permissions (QMK/Via udev rules)";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    hardware.keyboard.qmk.enable = true;
  };
}
