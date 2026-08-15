{
  lib,
  pkgs,
  config,
  ...
}:
let
  modCfg = config.features.gaming;
  cfg = modCfg.ps4;
in
{
  options.features.gaming.ps4.enable = lib.mkEnableOption "ps4";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    home.packages = with pkgs; [
      shadps4-qtlauncher
      liborbispkg-pkgtool
    ];
  };
}
