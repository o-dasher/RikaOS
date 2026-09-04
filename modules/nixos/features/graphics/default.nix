{
  lib,
  config,
  ...
}:
{
  options.features.graphics.enable = lib.mkEnableOption "OpenGL and Vulkan graphics stack with 32-bit driver support";

  config = lib.mkIf config.features.graphics.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
