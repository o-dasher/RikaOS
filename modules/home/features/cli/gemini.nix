{
  lib,
  config,
  ...
}:
{
  options.cli.gemini.enable = lib.mkEnableOption "gemini-cli";

  config = lib.mkIf config.cli.gemini.enable {
    programs.gemini-cli.enable = true;
  };
}
