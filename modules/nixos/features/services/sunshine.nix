{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.services;
  cfg = modCfg.sunshine;
in
{
  options.features.services.sunshine.enable =
    lib.mkEnableOption "Sunshine game streaming host server (for Moonlight streaming clients)";

  config = lib.mkIf (modCfg.enable && cfg.enable) {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = false;
      settings.sunshine_name = config.networking.hostName;
    };
  };
}
