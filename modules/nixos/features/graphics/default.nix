{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.graphics;
in
with lib;
{
  options.features.graphics = {
    enable = mkEnableOption "graphics stack";
  };

  config = mkIf modCfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
