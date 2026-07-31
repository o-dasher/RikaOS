{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.social;
  cfg = modCfg.discord;
  discordPackage = config.programs.nixcord.finalPackage.discord;
in
with lib;
{
  options.features.social.discord = {
    enable = mkEnableOption "Discord with Krisp";
    enableKrispPatch = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the Krisp noise suppression patch for Discord";
    };
  };

  config = mkIf (modCfg.enable && cfg.enable) {
    xdg.autostart.entries = [ (config.rika.utils.mkAutostartApp { pkg = discordPackage; }) ];
    programs.nixcord = {
      enable = true;
      discord = {
        krisp.enable = true;
        vencord.enable = true;
      };
      config.plugins = {
        fakeNitro.enable = true;
        youtubeAdblock.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
