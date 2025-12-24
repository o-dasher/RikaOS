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
        hypr-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        # Use Hyprland's mesa if Hyprland desktop is enabled
        useHyprlandPackages = config.features.desktop.hyprland.enable;
      in
      {
        enable = true;
        enable32Bit = true;
        package = lib.mkIf useHyprlandPackages hypr-pkgs.mesa;
        package32 = lib.mkIf useHyprlandPackages hypr-pkgs.pkgsi686Linux.mesa;
      };
  };
}
