{
  lib,
  config,
  ...
}:
let
  cfg = config.features.social.discord;
in
{
  options.features.social.discord = {
    enable = lib.mkEnableOption "Discord with Krisp";
    enableKrispPatch = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Krisp noise suppression patch for Discord";
    };
  };

  config = lib.mkIf (config.features.social.enable && cfg.enable) {
    xdg.autostart.entries = [
      (config.rika.utils.mkAutostartApp { pkg = config.programs.nixcord.finalPackage.discord; })
    ];
    programs.nixcord = {
      enable = true;
      discord = {
        krisp.enable = cfg.enableKrispPatch;
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
