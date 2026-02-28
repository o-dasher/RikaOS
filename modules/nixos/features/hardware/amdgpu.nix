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
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };
}
