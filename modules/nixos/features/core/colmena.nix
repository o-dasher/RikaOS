{
  lib,
  config,
  ...
}:
let
  modCfg = config.features.core;
  cfg = modCfg.colmena;
  usersWithoutColmena = lib.removeAttrs config.users.users [ "colmena" ];
  wheelUsers = lib.filterAttrs (
    _: userCfg:
    let
      extraGroups = lib.attrByPath [ "extraGroups" ] [ ] userCfg;
      primaryGroup = lib.attrByPath [ "group" ] null userCfg;
    in
    lib.elem "wheel" extraGroups || primaryGroup == "wheel"
  ) usersWithoutColmena;
  inheritedAuthorizedKeys = lib.unique (
    lib.flatten (
      lib.mapAttrsToList (
        _: userCfg: lib.attrByPath [ "openssh" "authorizedKeys" "keys" ] [ ] userCfg
      ) wheelUsers
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
