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
{
  options.features.boot.limine = {
    enable = lib.mkEnableOption "Limine boot loader";
    secure = {
      enable = lib.mkEnableOption "Setup secure boot";
      # Reference for auto unlocking encrypted drive: https://discourse.nixos.org/t/full-disk-encryption-tpm2/29454
      encryptionUnlock.enable = lib.mkEnableOption "Unlock encrypted drives automatically";
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) (
    lib.mkMerge [
      {
        boot.loader = {
          efi.canTouchEfiVariables = true;
          grub.enable = false;
          systemd-boot.enable = false;
          limine = {
            enable = true;
            maxGenerations = 3;
          };
        };
      }
      (lib.mkIf cfg.secure.enable {
        environment.systemPackages =
          with pkgs;
          ([ sbctl ] ++ lib.optionals cfg.secure.encryptionUnlock.enable [ tpm2-tss ]);

        boot = {
          loader.limine.secureBoot.enable = true;
          initrd.systemd = lib.mkIf cfg.secure.encryptionUnlock.enable {
            enable = true;
            tpm2.enable = true;
          };
        };

        security.tpm2 = lib.mkIf cfg.secure.encryptionUnlock.enable {
          enable = true;
          tctiEnvironment.enable = true;
        };
      })
    ]
  );
}
