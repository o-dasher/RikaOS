{
  config,
  lib,
  pkgs,
  ...
}:
let
  modCfg = config.features.boot;
  cfg = modCfg.limine;
in
with lib;
{
  options.features.boot.limine = {
    enable = mkEnableOption "Limine boot loader";
    secure = {
      enable = mkEnableOption "Setup secure boot";
      # Reference for auto unlocking encrypted drive: https://discourse.nixos.org/t/full-disk-encryption-tpm2/29454
      encryptionUnlock.enable = mkEnableOption "Unlock encrypted drives automatically";
    };
  };

  config = mkIf (modCfg.enable && cfg.enable) (mkMerge [
    {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = false;
        limine = {
          enable = true;
          maxGenerations = 3;
        };
      };
    }
    (mkIf cfg.secure.enable {
      environment.systemPackages =
        with pkgs;
        ([ sbctl ] ++ optionals cfg.secure.encryptionUnlock.enable [ tpm2-tss ]);
      boot = {
        loader.limine.secureBoot.enable = true;
        initrd.systemd = mkIf cfg.secure.encryptionUnlock.enable {
          enable = true;
          tpm2.enable = true;
        };
      };
    })
  ]);
}
