{ lib, ... }:
{
  options.rika = with lib; {
    username = mkOption {
      description = "The username of the main user of this machine.";
      type = types.str;
    };
    hostName = mkOption {
      description = "The name of the host of this machine.";
      type = types.str;
    };
    state = mkOption {
      description = "The nix state of this host, used for compatibility.";
      type = types.str;
    };
  };

  config.rika = import ./myconfig.nix;
}
