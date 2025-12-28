{
  lib,
  config,
  ...
}:
{
  config =
    let
      cfg = config.features.gaming;
    in
    lib.mkIf (cfg.enable && cfg.otd.enable) {
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
