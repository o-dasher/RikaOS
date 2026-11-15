{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.features.hardware.laptop;
in
{
  options.features.hardware.laptop.enable = lib.mkEnableOption "Laptop hardware support.";

  config = lib.mkIf cfg.enable {
    services = {
      upower.enable = true;
      udev.packages = [ pkgs.brightnessctl ];
    };
  };
}
