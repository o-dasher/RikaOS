{  config, ... }:
let
  cfg = config.rika;
in
{
  imports = [
    ./rika
    ./satoko
    ../config/setconfig.nix
  ];

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config.allowUnfree = true;

  satoko.enable = (cfg.hostname == "nixo");

  home = {
    username = cfg.username;
    homeDirectory = "/home/${cfg.username}";
    stateVersion = cfg.state;
  };

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
      options = "--delete-older-than 1d";
    };
  };
}
