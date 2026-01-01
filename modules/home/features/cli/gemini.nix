{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.cli.gemini.enable = lib.mkEnableOption "gemini-cli";

  config = lib.mkIf config.features.cli.gemini.enable {
    programs.gemini-cli = {
      enable = true;
      package = pkgs.gemini-cli-bin;
    };
  };
}
