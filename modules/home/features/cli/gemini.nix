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
  config = mkIf (modCfg.enable && cfg.enable) {
    programs.gemini-cli = {
      enable = true;
      package = pkgs.gemini-cli-bin;
    };
  };
}
