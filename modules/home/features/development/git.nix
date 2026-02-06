{
  lib,
  config,
  osConfig ? null,
  ...
}:
let
  modCfg = config.features.development;
  cfg = modCfg.git;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs = {
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519";
        };
      };
      git = {
        enable = true;
        settings.safe.directory = mkIf (
          osConfig != null
        ) osConfig.features.filesystem.sharedFolders.folderNames;
      };
    };
  };
}
