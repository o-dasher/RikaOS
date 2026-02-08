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
