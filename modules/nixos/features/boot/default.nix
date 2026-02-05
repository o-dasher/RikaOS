{
  pkgs,
  lib,
  config,
  ...
}:
let
  modCfg = config.features.boot;
in
with lib;
{
  imports = [ ./secure-boot.nix ];

  options.features.boot = {
    secure = {
      enable = mkEnableOption "secureBoot";
      # Reference for auto unlocking encrypted drive: https://discourse.nixos.org/t/full-disk-encryption-tpm2/29454
      encryptionUnlock.enable = mkEnableOption "Unlock encrypted drives automatically";
    };
    enable = mkEnableOption "boot features";
  };

  config = mkIf modCfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
