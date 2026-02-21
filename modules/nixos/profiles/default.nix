{ lib, ... }:
with lib;
{
  imports = [
    ./secure-server.nix
  ];

  options.profiles = {
    secureServer.enable = mkEnableOption "secure server profile";
  };
}
