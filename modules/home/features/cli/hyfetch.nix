{ lib, config, ... }:
{
  options.features.cli.hyfetch.enable = lib.mkEnableOption "hyfetch";

  config = lib.mkIf config.features.cli.hyfetch.enable {
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
