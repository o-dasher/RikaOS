{
  lib,
  config,
  osConfig ? null,
  ...
}:
{
  options.features.dev.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.features.dev.git.enable {
    programs.git = {
      enable = true;
      settings.safe.directory = lib.mkIf (
        osConfig != null
      ) osConfig.features.filesystem.sharedFolders.folderNames;
    };
  };
}
