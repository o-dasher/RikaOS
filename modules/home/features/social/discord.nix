{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.social;
  cfg = modCfg.discord;
in
{
  options.features.social.discord = {
    enable = lib.mkEnableOption "Discord.";
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    xdg.autostart.entries = [
      (config.rika.utils.mkAutostartApp { pkg = config.programs.nixcord.finalPackage.discord; })
    ];
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
