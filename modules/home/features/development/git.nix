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
          "wired" = {
            hostname = "wired.dshs.cc";
            user = "lain";
            identityFile = "~/.ssh/id_ed25519";
          };
          "gensokyo" = {
            hostname = "fuio.dshs.cc";
            user = "thiago";
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
