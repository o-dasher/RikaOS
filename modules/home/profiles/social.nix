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
  config = mkIf cfg.enable {
    features.social = {
      enable = true;
      discord.enable = true;
      zapzap.enable = true;
    };
  };
}
