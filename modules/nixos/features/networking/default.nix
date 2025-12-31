{
  lib,
  config,
  cfg,
  ...
}:
let
  inherit (cfg) hostName;
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
    services.cloudflare-warp.enable = true;
    networking = {
      inherit hostName;
      networkmanager.enable = config.features.networking.networkManager.enable;
    };
  };
}
