{ pkgs, lib, config, inputs, ... }:
{
  options.suites.social = {
    enable = lib.mkEnableOption "social suite";
  };

  config = lib.mkIf config.suites.social.enable {
    programs.nixcord = {
      enable = true;
      discord.enable = true;
      vesktop.enable = true;
    };
  };
}
