{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.virtualization;
in
{
  options.features.virtualization.enable = lib.mkEnableOption "virtualization features" // {
    default = true;
  };

  config = lib.mkIf modCfg.enable {
    programs.virt-manager.enable = true;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [ "--all" ];
        };
      };
    };
  };
}
