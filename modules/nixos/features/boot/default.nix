{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.features.boot = {
    enable = lib.mkEnableOption "boot features";
    cachy.enable = lib.mkEnableOption "cachy kernel";
  };

  config =
    let
      cfg = config.features.boot;
    in
    lib.mkIf cfg.enable {
      boot = {
        kernelPackages =
          if cfg.cachy.enable then
            pkgs.cachyosKernels.linuxPackages-cachyos-latest
          else
            pkgs.linuxPackages_latest;
      };

      nixpkgs.overlays = lib.mkIf cfg.cachy.enable [
        inputs.nix-cachyos-kernel.overlays.pinned
      ];
    };
}
