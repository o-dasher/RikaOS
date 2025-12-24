{ pkgs, lib, config, ... }:
{
  imports = [
    ./multimedia.nix
    ./productivity.nix
    ./development.nix
    ./social.nix
    ./browser.nix
  ];
}
