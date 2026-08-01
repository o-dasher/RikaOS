{
  lib,
  config,
  ...
}:
let
  cfg = config.features.hardware.amdgpu;
in
{
  options.features.hardware.amdgpu.enable = lib.mkEnableOption "AMDGPU support";

  config = lib.mkIf (config.features.hardware.enable && cfg.enable) {
    services.lact.enable = true;

    # AMD Anti-Lag 2 Vulkan layer — reduces click-to-photon input latency
    environment.sessionVariables.ENABLE_LAYER_MESA_ANTI_LAG = "1";
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive.enable = true;
    };
  };
}
