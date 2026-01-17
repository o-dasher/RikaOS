{
  lib,
  config,
  ...
}:
{
  options.features.graphics = {
    enable = lib.mkEnableOption "graphics stack";
  };

  config = lib.mkIf config.features.graphics.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
