{ lib, ... }:
with lib;
{
  imports = [
    ./setup.nix
  ];

  options.features.nix = {
    nixpkgs.enable = mkEnableOption "nixpkgs";
    trusted-users = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
    optimise = mkEnableOption "optmise" // {
      default = true;
    };
    enable = mkEnableOption "nix";
  };
}
