{
  lib,
  config,
  ...
}:
{
  options.features.networking = {
    enable = lib.mkEnableOption "networking";
    networkManager = {
      enable = lib.mkEnableOption "NetworkManager";
      cloudflare.enable = lib.mkEnableOption "Cloudflare";
    };
  };

  config = lib.mkIf config.features.networking.enable {
    services.cloudflare-warp.enable = true;
    networking.networkmanager.enable = config.features.networking.networkManager.enable;
  };
}
