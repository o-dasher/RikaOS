{
  lib,
  config,
  ...
}:
{
  options.features.virtualization = {
    enable = lib.mkEnableOption "virtualization features";
  };

  config = lib.mkIf config.features.virtualization.enable {
    programs.virt-manager.enable = true;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd.enable = true;
      docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
    };
  };
}
