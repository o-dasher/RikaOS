{
  lib,
  config,
  ...
}:
{
  options.features.dev.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.features.dev.git.enable {
    programs.gh.enable = true;
    programs.git.enable = true;
  };
}
