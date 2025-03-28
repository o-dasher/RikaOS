{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.secureBoot = with lib; {
    enable = mkEnableOption "secureBoot";
  };

  config = lib.mkIf config.secureBoot.enable {

    environment.systemPackages = [ pkgs.sbctl ];

    # Use the systemd-boot EFI boot loader.
    boot = {
      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
      loader.systemd-boot = {
        enable = lib.mkForce false;
        consoleMode = "max";
        configurationLimit = 3;
        edk2-uefi-shell.enable = true;
      };
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };
  };
}
