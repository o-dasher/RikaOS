{
  lib,
  config,
  osConfig ? null,
  ...
}:
let
  modCfg = config.features.development;
  cfg = modCfg.git;
  localHostName = if osConfig != null then osConfig.networking.hostName else null;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    programs = {
      gh.enable = true;
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "~/.ssh/id_ed25519";
          };
          "github.com-thiago" = {
            hostname = "github.com";
            user = "git";
            identityFile = "~/.ssh/id_ed25519-thiago";
          };
        }
        // optionalAttrs (localHostName != null) {
          "${localHostName}" = {
            hostname = "127.0.0.1";
            user = "root";
            identityFile = "~/.ssh/id_ed25519";
          };
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
