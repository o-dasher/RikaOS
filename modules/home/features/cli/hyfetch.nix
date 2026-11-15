{ lib, config, ... }:
let
  cfg = config.features.cli.hyfetch;
in
{
  options.features.cli.hyfetch.enable = lib.mkEnableOption "HyFetch.";

  config = lib.mkIf cfg.enable {
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
