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
{
  options.features.development.git.enable =
    lib.mkEnableOption "Git version control, GitHub CLI (gh), and SSH client host configurations";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    programs = {
      gh.enable = true;
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "*" = {
            SetEnv = {
              TERM = "xterm-256color";
            };
          };
          "github.com" = {
            HostName = "github.com";
            User = "git";
            IdentityFile = "~/.ssh/id_ed25519";
          };
          "github.com-thiago" = {
            HostName = "github.com";
            User = "git";
            IdentityFile = "~/.ssh/id_ed25519-thiago";
          };
        }
        // lib.optionalAttrs (localHostName != null) {
          "${localHostName}" = {
            HostName = "127.0.0.1";
            User = "root";
            IdentityFile = "~/.ssh/id_ed25519";
          };
        };
      };
      git = {
        enable = true;
        signing.format = null;
        settings.safe.directory = lib.mkIf (
          osConfig != null
        ) osConfig.features.filesystem.sharedFolders.folderNames;
      };
    };
  };
}
