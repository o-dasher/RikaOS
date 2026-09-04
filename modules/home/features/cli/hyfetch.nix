{ lib, config, ... }:
let
  modCfg = config.features.cli;
  cfg = modCfg.hyfetch;
in
{
  options.features.cli.hyfetch.enable = lib.mkEnableOption "HyFetch.";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    programs = {
      fastfetch.enable = true;
      hyfetch = {
        enable = true;
        settings = {
          preset = "bisexual";
          mode = "rgb";
          color_align.mode = "horizontal";
          backend = "fastfetch";
          pride_month_disable = false;
        };
      };
    };
  };
}
