{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.social;
  cfg = modCfg.discord;
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
