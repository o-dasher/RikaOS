{ lib, ... }:
with lib;
{
  imports = [
    ./xdg.nix
    ./shared-folders.nix
    ./nix.nix
  ];

  options.features = {
    core = {
      enable = mkEnableOption "core features";
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
    };
    filesystem = {
      enable = mkEnableOption "filesystem features";
      sharedFolders = {
        enable = mkEnableOption "sharedFolders";
        configurationRoot = mkOption {
          default = "/shared/.config";
          type = types.str;
        };
      };
    };
  };
}
