{ lib, ... }:
with lib;
{
  imports = [
    ./xdg.nix
    ./nix.nix
  ];

  options.features.core = {
    nix = {
      enable = mkEnableOption "nix" // {
        default = true;
      };
      nixpkgs.enable = mkEnableOption "nixpkgs";
    };
    xdg = {
      enable = mkEnableOption "xdg";
      portal.enable = mkEnableOption "portal";
    };
    enable = mkEnableOption "core features" // {
      default = true;
    };
  };
}
