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
    kernel.enable = lib.mkEnableOption "Latest Linux kernel.";
    enable = lib.mkEnableOption "Boot features." // {
      default = true;
    };
  };

  config = lib.mkIf (modCfg.enable && modCfg.kernel.enable) {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
