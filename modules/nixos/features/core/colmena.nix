{
  pkgs,
  config,
  ...
}:
{
  users = {
    groups.colmena = { };
    users.colmena = {
      isSystemUser = true;
      group = "colmena";
      shell = pkgs.bashInteractive;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ config.features.services.openssh.keys.rika ];
    };
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
}
