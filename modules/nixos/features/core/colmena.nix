{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.core;
  cfg = modCfg.colmena;
  usersWithoutColmena = lib.removeAttrs config.users.users [ "colmena" ];
  inheritedAuthorizedKeys = lib.unique (
    lib.flatten (
      lib.mapAttrsToList (
        _: userCfg: lib.attrByPath [ "openssh" "authorizedKeys" "keys" ] [ ] userCfg
      ) usersWithoutColmena
    )
  );
in
with lib;
{
  config = mkIf (modCfg.enable && cfg.enable) {
    users.users.colmena = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = inheritedAuthorizedKeys;
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
