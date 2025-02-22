{
  cfg,
  lib,
  config,
  ...
}:
{
  options.homeSetup = with lib; {
    enable = mkEnableOption "homeSetup" // {
      default = true;
    };
  };

  config = lib.mkIf (config.homeSetup.enable) {
    home = {
      username = cfg.username;
      homeDirectory = "/home/${cfg.username}";
      stateVersion = cfg.state;
    };
  };
}
