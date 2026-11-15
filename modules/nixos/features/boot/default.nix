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
  imports = [
    ./limine.nix
    ./hibernation.nix
  ];

  options.features.boot.kernel.enable = lib.mkEnableOption "Latest Linux kernel.";

  config = lib.mkIf cfg.kernel.enable {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
