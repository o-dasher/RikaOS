{
  lib,
  config,
  ...
}:
{
  options.features.cli.gemini.enable = lib.mkEnableOption "gemini-cli";

  config = lib.mkIf config.features.cli.gemini.enable {
    programs.gemini-cli.enable = true;
  };
}
