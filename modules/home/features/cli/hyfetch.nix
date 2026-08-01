{ lib, config, ... }:
let
  cfg = config.features.cli.hyfetch;
in
{
  options.features.cli.hyfetch.enable = lib.mkEnableOption "hyfetch";

  config = lib.mkIf (config.features.cli.enable && cfg.enable) {
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
