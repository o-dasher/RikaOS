{
  lib,
  config,
  osConfig ? null,
  nixCaches,
  ...
}:
let
  modCfg = config.features.core;
  cfg = modCfg.nix;
in
with lib;
{
  options.features.core.nix = {
    enable = mkEnableOption "nix" // {
      default = true;
    };
    nixpkgs.enable = mkEnableOption "nixpkgs";
  };

  config = mkMerge [
    (mkIf (modCfg.enable && cfg.enable) {
      nix.settings = nixCaches;
      programs.nh = {
        enable = true;
        clean.enable = true;
        flake = "${config.features.filesystem.sharedFolders.configurationRoot}/private";
      };
    })
    (mkIf
      (
        modCfg.enable
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
