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
  options.profiles.social.enable = lib.mkEnableOption "social communication suite (Discord, Thunderbird email, ZapZap WhatsApp, and Signal)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ signal-desktop ];
    features.social = {
      enable = true;
      email.enable = true;
      discord.enable = true;
      zapzap.enable = true;
    };
  };
}
