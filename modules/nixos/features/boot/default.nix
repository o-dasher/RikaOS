{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.boot.enable = lib.mkEnableOption "boot features";

  config =
    let
      cfg = config.features.boot;
    in
    lib.mkIf cfg.enable {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
