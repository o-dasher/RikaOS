{
  lib,
  config,
  pkgs,
  ...
}:
let
  modCfg = config.features.cli;
  cfg = modCfg.gemini;
in
with lib;
{
  options.features.cli.gemini.enable = mkEnableOption "gemini-cli";

  config = mkIf (modCfg.enable && cfg.enable) {
    programs.gemini-cli = {
      enable = true;
      package = pkgs.gemini-cli-bin;
    };
  };
}
