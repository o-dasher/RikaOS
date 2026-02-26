{ lib, ... }:
with lib;
{
  imports = [
    ./secure-server.nix
  ];
}
