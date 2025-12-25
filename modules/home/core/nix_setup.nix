{
  lib,
  config,
  osConfig ? null,
  ...
}:
{
  options.nixSetup.enable = lib.mkEnableOption "nixSetup" // {
    default = true;
  };

  config = lib.mkMerge [
    (lib.mkIf config.nixSetup.enable {
      programs.nh = {
        enable = true;
        clean.enable = true;
        flake = "${config.multiUserFiles.sharedFolders.configurationRoot}/private";
      };
    })
    (lib.mkIf (osConfig == null || !osConfig.home-manager.useGlobalPkgs) {
      nixpkgs.config.allowUnfree = true;
    })
  ];
}
