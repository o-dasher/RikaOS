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
  config = mkIf (modCfg.enable && cfg.enable) {
    services.lact.enable = true;
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };
}
