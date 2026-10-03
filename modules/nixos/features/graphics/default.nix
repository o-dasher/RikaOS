{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.features.graphics.enable = lib.mkEnableOption "Graphics stack.";

  config = lib.mkIf config.features.graphics.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      package = pkgs-unstable.mesa;
      package32 = pkgs-unstable.pkgsi686Linux.mesa;
    };
  };
}
