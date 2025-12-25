{
  lib,
  config,
  cfg,
  ...
}:
let
  inherit (cfg) targetHostName;
in
{
  options.features.networking = {
    enable = lib.mkEnableOption "networking";
    networkManager = {
      enable = lib.mkEnableOption "NetworkManager" // {
        default = true;
      };
      cloudflare.enable = lib.mkEnableOption "Cloudflare";
    };
  };

  config = lib.mkIf config.features.networking.enable {
    networking = {
      hostName = targetHostName;
      networkmanager = {
        enable = config.features.networking.networkManager.enable;
        insertNameservers = lib.mkIf config.features.networking.networkManager.cloudflare.enable [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
    };
  };
}
