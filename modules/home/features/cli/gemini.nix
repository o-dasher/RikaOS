{
  lib,
  config,
  pkgs-bleeding,
  ...
}:
{
  options.cli.gemini.enable = lib.mkEnableOption "gemini-cli";

  config = lib.mkIf config.cli.gemini.enable {
    programs.gemini = {
      enable = true;
      package = pkgs-bleeding.gemini-cli;
    };
  };
}
