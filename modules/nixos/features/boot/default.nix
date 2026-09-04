{
  pkgs,
  lib,
  config,
  ...
}:
let
  modCfg = config.features.boot;
in
{
  imports = [
    ./limine.nix
  ];

  options.features.boot = {
    kernel.enable = lib.mkEnableOption "latest Linux kernel packages instead of default LTS kernel";
    enable = lib.mkEnableOption "system boot features and kernel configuration" // {
      default = true;
    };
  };

  config = lib.mkIf (modCfg.enable && modCfg.kernel.enable) {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
