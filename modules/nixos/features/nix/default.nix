{ lib, ... }:
with lib;
{
  imports = [
    ./setup.nix
    ./builders.nix
  ];

  options.features.nix = {
    nixpkgs.enable = mkEnableOption "nixpkgs";
    trusted-users = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
    optimise = mkEnableOption "optmise";
    builders = {
      enable = mkEnableOption "distributed nix builders";
      sshKey = mkOption {
        type = types.str;
        description = "Path to SSH private key for connecting to remote builders";
      };
    };
    enable = mkEnableOption "nix" // {
      default = true;
    };
  };
}
