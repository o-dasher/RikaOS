{
  lib,
  config,
  ...
}:
{
  options.profiles.social = {
    enable = lib.mkEnableOption "social profile";
  };

  config = lib.mkIf config.profiles.social.enable {
    features.social = {
      enable = true;
      discord.enable = true;
      zapzap.enable = true;
    };
  };
}
