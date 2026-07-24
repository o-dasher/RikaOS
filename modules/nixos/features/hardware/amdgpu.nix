{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.hardware;
  cfg = modCfg.amdgpu;
in
with lib;
{
  options.features.hardware.amdgpu.enable = mkEnableOption "AMDGPU support";

  config = mkIf (modCfg.enable && cfg.enable) {
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
