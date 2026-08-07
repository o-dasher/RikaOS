{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.hardware;
  cfg = modCfg.amdgpu;
in
{
  options.features.hardware.amdgpu.enable = lib.mkEnableOption "AMDGPU support";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    services.lact.enable = true;

    environment.sessionVariables = {
      AMD_DEBUG = "nodcc";
      RADV_DEBUG = "nodcc";
      ENABLE_LAYER_MESA_ANTI_LAG = "1";
    };

    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive.enable = true;
    };
  };
}
