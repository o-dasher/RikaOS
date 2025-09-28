{ lib, config, ... }:
{
  config = lib.mkIf (config.cli.enable && config.cli.hyfetch.enable) {
    programs.hyfetch = {
      enable = true;
      settings = {
        preset = "bisexual";
        mode = "rgb";
        color_align.mode = "horizontal";
      };
    };
  };
}
