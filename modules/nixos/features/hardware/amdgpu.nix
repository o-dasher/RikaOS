{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.hardware.amdgpu = {
    enable = lib.mkEnableOption "AMDGPU support";
  };

  config = lib.mkIf config.features.hardware.amdgpu.enable {
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive.enable = true;
    };

    services.lact.enable = true;
  };
}
