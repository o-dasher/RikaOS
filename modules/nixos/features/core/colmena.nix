{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.core;
  cfg = modCfg.colmena;
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    users.users.colmena = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys =
        let
          inherit (config.features.services.openssh.keys) rika;
        in
        [ rika ];
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
