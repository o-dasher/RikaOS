{
  config,
  lib,
  pkgs,
  ...
}:
{

  options.secureBoot = with lib; {
    enable = mkEnableOption "secureBoot";
    # Reference for auto unlocking encrypted drive: https://discourse.nixos.org/t/full-disk-encryption-tpm2/29454
    encryptionUnlock.enable = mkEnableOption "Unlock encrypted drives automatically";
  };

  config =
    let
      cfg = config.secureBoot;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        pkgs.sbctl
      ];

      boot = {
        initrd.systemd = lib.mkIf (cfg.encryptionUnlock.enable) {
          enable = true;
          tpm2.enable = true;
        };

        loader = {
          efi.canTouchEfiVariables = true;
          limine = {
            enable = true;
            secureBoot.enable = true;
            maxGenerations = 3;
          };
        };
      };
    };
}
