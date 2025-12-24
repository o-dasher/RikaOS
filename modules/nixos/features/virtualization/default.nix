{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.virtualization = {
    enable = lib.mkEnableOption "virtualization features";
  };

  config = lib.mkIf config.features.virtualization.enable {
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

    programs.virt-manager.enable = true;
  };
}
