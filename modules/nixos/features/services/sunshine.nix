{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.sunshine;
in
with lib;
{
  options.features.services.sunshine.enable =
    mkEnableOption "Sunshine game streaming server (for Moonlight clients)";

  config = mkIf (modCfg.enable && cfg.enable) (mkMerge [
    {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = false;
        settings.sunshine_name = config.networking.hostName;
      };
    }
  ]);
}
