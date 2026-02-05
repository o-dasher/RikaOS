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
  config =
    mkIf (modCfg.enable && cfg.enable) {
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
