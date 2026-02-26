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
    enable = mkEnableOption "boot features" // {
      default = true;
    };
  };

  config = mkIf (modCfg.enable && modCfg.kernel.enable) {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
