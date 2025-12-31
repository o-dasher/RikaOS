{
  lib,
  config,
  ...
}:
{
  options.features.hardware.amdgpu = {
    enable = lib.mkEnableOption "AMDGPU support";
  };

  config = lib.mkIf config.features.hardware.amdgpu.enable {
    services.lact.enable = true;
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive.enable = true;
    };
  };
}
