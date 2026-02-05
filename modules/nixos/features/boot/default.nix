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
  imports = [
    ./limine.nix
  ];

  options.features.boot = {
    kernel.enable = mkEnableOption "Install latest linux kernel";
    limine = {
      enable = mkEnableOption "Limine boot loader";
      secure = {
        enable = mkEnableOption "Setup secure boot";
        # Reference for auto unlocking encrypted drive: https://discourse.nixos.org/t/full-disk-encryption-tpm2/29454
        encryptionUnlock.enable = mkEnableOption "Unlock encrypted drives automatically";
      };
    };
    enable = mkEnableOption "boot features" // {
      default = true;
    };
  };

  config = mkIf (modCfg.enable && modCfg.kernel.enable) {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
