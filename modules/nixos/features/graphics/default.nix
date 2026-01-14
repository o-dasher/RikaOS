{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.features.graphics = {
    enable = lib.mkEnableOption "graphics stack";
  };

  config = lib.mkIf config.features.graphics.enable {
    hardware.graphics =
      let
        hypr-pkgs =
          inputs.hyprnix.inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      lib.mkMerge [
        {
          enable = true;
          enable32Bit = true;
        }

        (lib.mkIf config.features.desktop.hyprland.enable {
          package = hypr-pkgs.mesa;
          package32 = hypr-pkgs.pkgsi686Linux.mesa;
        })
      ];
  };
}
