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
    enable = lib.mkEnableOption "Discord with Krisp";
    enableKrispPatch = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the Krisp noise suppression patch for Discord";
    };
  };

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    xdg.autostart.entries = [
      (config.rika.utils.mkAutostartApp { pkg = config.programs.nixcord.finalPackage.discord; })
    ];
    programs.nixcord = {
      enable = true;
      discord = {
        krisp.enable = cfg.enableKrispPatch;
        vencord.enable = true;
        commandLineArgs = [
          "--enable-features=Vulkan"
          "--use-vulkan=native"
        ];
      };
      config.plugins = {
        fakeNitro.enable = true;
        youtubeAdblock.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
