{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.social;
in
{
  options.profiles.social.enable = lib.mkEnableOption "Social profile.";

  config = lib.mkIf cfg.enable {
    features.social = {
      enable = true;
      email.enable = true;
      discord.enable = true;
      signal.enable = true;
    };
  };
}
