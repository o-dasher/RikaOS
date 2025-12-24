{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.networking = {
    enable = lib.mkEnableOption "networking";
  };

  config = lib.mkIf config.features.networking.enable {
    networking = {
      networkmanager = {
        enable = true;
        insertNameservers = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
    };
    services.openssh.enable = true;
  };
}
