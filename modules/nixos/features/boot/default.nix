{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.features.boot;
in
{
  imports = [ ./secure-boot.nix ];

  options.features.boot = with lib; {
    enable = mkEnableOption "boot features";
    secure = {
      enable = mkEnableOption "secureBoot";
      # Reference for auto unlocking encrypted drive: https://discourse.nixos.org/t/full-disk-encryption-tpm2/29454
      encryptionUnlock.enable = mkEnableOption "Unlock encrypted drives automatically";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
