{
  lib,
  config,
  ...
}:
let
  cfg = config.features.hardware.amdgpu;
in
{
  options.features.hardware.amdgpu.enable = lib.mkEnableOption "AMDGPU support.";

  config = lib.mkIf cfg.enable {
    services.lact.enable = true;

    environment.sessionVariables.ENABLE_LAYER_MESA_ANTI_LAG = "1";
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive.enable = true;
    };
  };
}
