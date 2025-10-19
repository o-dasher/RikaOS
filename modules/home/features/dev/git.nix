{ lib, config, ... }:
{
  options.dev.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.dev.git.enable {
    programs.gh.enable = true;
  };
}
