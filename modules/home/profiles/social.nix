{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.social;
in
with lib;
{
  options.profiles.social.enable = mkEnableOption "social profile";

  config = mkIf cfg.enable {
    features.social = {
      enable = true;
      email.enable = true;
      discord.enable = true;
      zapzap.enable = true;
    };
  };
}
