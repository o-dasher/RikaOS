{
  lib,
  config,
  pkgs-bleeding,
  ...
}:
{
  options.cli.gemini.enable = lib.mkEnableOption "gemini-cli";

  config = lib.mkIf config.cli.gemini.enable {
    home.packages = [ pkgs-bleeding.gemini-cli ];
  };
}
