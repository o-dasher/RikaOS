{
  lib,
  config,
  ...
}:
let
  modCfg = config.profiles.social;
in
with lib;
{
  config = mkIf modCfg.enable {
    features.social = {
      enable = true;
      discord.enable = true;
      zapzap.enable = true;
    };
  };
}
