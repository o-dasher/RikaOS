{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  modCfg = config.features.graphics;
in
with lib;
{
  options.features.graphics = {
    enable = mkEnableOption "graphics stack";
  };

  config = mkIf modCfg.enable {
    hardware.graphics = lib.mkMerge [
      {
        enable = true;
        enable32Bit = true;
      }
      (
        with inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        lib.mkIf config.programs.hyprland.enable {
          package = mesa;
          package32 = pkgsi686Linux.mesa;
        }
      )
    ];
  };
}
