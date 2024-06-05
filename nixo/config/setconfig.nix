{ lib, ... }:
let
  cfg = import ./myconfig.nix;
in
{
  options.rika = {
    username = lib.mkOption {
      description = "The username of the main user of this machine.";
      type = lib.types.str;
    };
    hostname = lib.mkOption {
      description = "The name of the host of this machine.";
      type = lib.types.str;
    };
    state = lib.mkOption {
      description = "The nix state of this host, used for compatibility.";
      type = lib.types.str;
    };
  };

  config.rika = cfg;
}
