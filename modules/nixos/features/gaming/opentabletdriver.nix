{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.otd;
in
{
  options.features.gaming.otd.enable =
    lib.mkEnableOption "OpenTabletDriver daemon and uinput support for graphics tablets"
    // {
      default = true;
    };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    hardware = {
      uinput.enable = true;
      opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };
  };
}
