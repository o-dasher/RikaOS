{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.otd;
in
with lib;
{
  options.features.gaming.otd.enable = mkEnableOption "OpenTabletDriver" // {
    default = true;
  };

  config = mkIf (modCfg.enable && cfg.enable) {
    boot.kernelModules = [ "uinput" ];
    hardware = {
      uinput.enable = true;
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };
  };
}
