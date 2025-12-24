{ lib, config, ... }:
{
  options.profiles.social = {
    enable = lib.mkEnableOption "social profile";
  };

  config = lib.mkIf config.profiles.social.enable {
    programs.nixcord = {
      enable = true;
      discord.enable = true;
      vesktop.enable = true;
    };
  };
}
