{
  lib,
  config,
  osConfig ? null,
  ...
}:
{
  options.nixSetup = {
    enable = lib.mkEnableOption "nixSetup" // {
      default = true;
    };
    nixpkgs.enable = lib.mkEnableOption "nixpkgs";
  };
  config = lib.mkMerge [
    (lib.mkIf config.nixSetup.enable {
      programs.nh = {
        enable = true;
        clean.enable = true;
        flake = "${config.multiUserFiles.sharedFolders.configurationRoot}/private";
      };
    })
    (lib.mkIf
      (config.nixSetup.nixpkgs.enable && (osConfig == null || !osConfig.home-manager.useGlobalPkgs))
      {
        nixpkgs.config.allowUnfree = true;
      }
    )
  ];
}
