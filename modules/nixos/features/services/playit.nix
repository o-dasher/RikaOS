{
  lib,
  config,
  ...
}:
{
  options.features.services.playit = {
    enable = lib.mkEnableOption "playit";
  };

  config = lib.mkIf config.features.services.playit.enable {
    services.playit = {
      enable = true;
      secretPath = config.age.secrets.playit-secret.path;
    };
  };
}
