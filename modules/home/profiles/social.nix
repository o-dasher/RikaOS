{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.social;
in
with lib;
{
  options.profiles.social.enable = mkEnableOption "social profile";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ signal-desktop ];
    features.social = {
      enable = true;
      email.enable = true;
      discord.enable = true;
    };
  };
}
