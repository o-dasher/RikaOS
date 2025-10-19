{ lib, config, ... }:
{
  options.cli.hyfetch.enable = lib.mkEnableOption "hyfetch";

  config = lib.mkIf config.cli.hyfetch.enable {
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
