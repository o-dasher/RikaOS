{
  lib,
  config,
  pkgs,
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
      };
    };

    systemd.services.virt-secret-init-encryption = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.bash}/bin/bash -c 'dd if=/dev/random status=none bs=32 count=1 | ${config.systemd.package}/bin/systemd-creds encrypt --with-key=host --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key'"
        ];
      };
    };
  };
}





