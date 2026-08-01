{
  lib,
  config,
  ...
}:
let
  cfg = config.features.services.sunshine;
in
{
  options.features.services.sunshine.enable =
    lib.mkEnableOption "Sunshine game streaming server (for Moonlight clients)";

  config = lib.mkIf (config.features.services.enable && cfg.enable) {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = false;
      settings.sunshine_name = config.networking.hostName;
    };
  };
}
