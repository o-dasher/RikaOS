{
  lib,
  pkgs,
  config,
  ...
}:
let
  modCfg = config.features.hardware;
  cfg = modCfg.laptop;
in
{
  options.features.hardware.laptop.enable =
    lib.mkEnableOption "laptop-specific hardware support (UPower battery daemon and brightnessctl udev rules)";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    services = {

      upower.enable = true;
      udev.packages = [ pkgs.brightnessctl ];
    };
  };
}
