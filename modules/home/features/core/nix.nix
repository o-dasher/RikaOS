{
  lib,
  config,
  osConfig ? null,
  nixCaches,
  ...
}:
{
  options.features.core.nix = {
    enable = lib.mkEnableOption "nix" // {
      default = true;
    };
    nixpkgs.enable = lib.mkEnableOption "nixpkgs";
  };
  config = lib.mkMerge [
    (lib.mkIf config.features.core.nix.enable {
      nix.settings = nixCaches;
      programs.nh = {
        enable = true;
        clean.enable = true;
        flake = "${config.features.filesystem.sharedFolders.configurationRoot}/private";
      };
    })
    (lib.mkIf
      (
        config.features.core.nix.nixpkgs.enable
        && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)
      )
      {
        nixpkgs.config.allowUnfree = true;
      }
    )
  ];
}
