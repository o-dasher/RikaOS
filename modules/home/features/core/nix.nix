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
    enable =
      lib.mkEnableOption "Nix configuration and helper tools (nh, cache substituters, and access tokens)"
      // {
        default = true;
      };
    nixpkgs.enable = lib.mkEnableOption "unfree package allowance in standalone Home Manager" // {
      default = true;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.features.core.enable && cfg.enable) {
      nix = {
        settings = nixCaches;
        extraOptions = config.rika.utils.nixAccessTokens;
      };
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
