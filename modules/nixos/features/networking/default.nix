{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.networking = {
    enable = lib.mkEnableOption "networking";
    networkManager = {
      enable = lib.mkEnableOption "NetworkManager" // { default = true; };
    };
  };

  config = lib.mkIf config.features.networking.enable {
    networking = {
      networkmanager = {
        enable = config.features.networking.networkManager.enable;
        insertNameservers = lib.mkIf config.features.networking.networkManager.enable [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
    };
    services.openssh.enable = true;
  };
}
