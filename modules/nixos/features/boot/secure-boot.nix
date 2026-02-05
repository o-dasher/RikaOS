{
  config,
  lib,
  pkgs,
  ...
}:
let
  modCfg = config.features.boot;
  cfg = modCfg.secure;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    environment.systemPackages = [
      pkgs.sbctl
    ];

    boot = {
      initrd.systemd = mkIf cfg.encryptionUnlock.enable {
        enable = true;
        tpm2.enable = true;
      };

      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = false;
        limine = {
          enable = true;
          secureBoot.enable = true;
          maxGenerations = 3;
        };
      };
    };
  };
}
