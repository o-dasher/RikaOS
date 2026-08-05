{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.features.core.colmena;
in
{
  options.features.core.colmena.enable = lib.mkEnableOption "colmena deployment user";

  config = lib.mkIf (config.features.core.enable && cfg.enable) {
    users.users.colmena = {
      isSystemUser = true;
      group = "colmena";
      shell = pkgs.bashInteractive;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ config.features.services.openssh.keys.rika ];
    };

    security.sudo.extraRules = [
      {
        users = [ "colmena" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
