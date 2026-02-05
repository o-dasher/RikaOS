{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.virtualization;
in
with lib;
{
  options.features.virtualization = {
    enable = mkEnableOption "virtualization features";
  };

  config = mkIf modCfg.enable {
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
