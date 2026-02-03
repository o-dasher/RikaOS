{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.boot;
in
{
  config = lib.mkIf (cfg.enable && cfg.secure.enable) {
    environment.systemPackages = [
      pkgs.sbctl
    ];

    boot = {
      initrd.systemd = lib.mkIf (cfg.secure.encryptionUnlock.enable) {
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
