{
  lib,
  config,
  ...
}:
{
  options.features.dev.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.features.dev.git.enable {
    programs.git.enable = true;
  };
}
