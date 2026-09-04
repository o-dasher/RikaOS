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
  options.features.hardware.keyboard.enable = lib.mkEnableOption "Mechanical keyboard configuration.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    hardware.keyboard.qmk.enable = true;
  };
}
