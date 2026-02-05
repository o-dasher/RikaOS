{
  lib,
  config,
  osConfig ? null,
  ...
}:
let
  modCfg = config.features.dev;
  cfg = modCfg.git;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.git = {
      enable = true;
      settings.safe.directory = mkIf (
        osConfig != null
      ) osConfig.features.filesystem.sharedFolders.folderNames;
    };
  };
}
