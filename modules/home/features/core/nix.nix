{
  lib,
  pkgs,
  config,
  osConfig ? null,
  nixCaches,
  ...
}:
let
  cfg = config.features.core.nix;
in
{
  options.features.core.nix = {
    enable = lib.mkEnableOption "nix" // {
      default = true;
    };
    nixpkgs.enable = lib.mkEnableOption "nixpkgs";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.features.core.enable && cfg.enable) {
      nix.settings = nixCaches;
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 4 --keep-since 8d";
        };
        flake = "${config.features.filesystem.sharedFolders.configurationRoot}/private";
      };
    })
    (lib.mkIf
      (
        config.features.core.enable
        && cfg.enable
        && cfg.nixpkgs.enable
        && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)
      )
      {
        nixpkgs.config.allowUnfree = true;
      }
    )
  ];
}
