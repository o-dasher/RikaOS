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
    backend = lib.mkOption {
      type = lib.types.enum [ "mesa" "hyprland" ];
      default = "mesa";
      description = "Graphics backend to use. 'hyprland' uses bleeding edge mesa from Hyprland flake.";
    };
  };

  config = lib.mkIf config.features.graphics.enable {
    hardware.graphics =
      let
        hypr-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        isHyprland = config.features.graphics.backend == "hyprland";
      in
      {
        enable = true;
        enable32Bit = true;
        package = lib.mkIf isHyprland hypr-pkgs.mesa;
        package32 = lib.mkIf isHyprland hypr-pkgs.pkgsi686Linux.mesa;
      };

    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive.enable = true;
    };

    services.lact.enable = true;
  };
}
