{
  lib,
  config,
  nixCaches,
  ...
}:
let
  cfg = config.features.nix;
in
with lib;
{
  options.features.nix = {
    nixpkgs.enable = mkEnableOption "nixpkgs";
    trusted-users = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
    optimise = mkEnableOption "optmise";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = cfg.nixpkgs.enable;
    nix = mkMerge [
      {
        settings = {
          trusted-users = [ "@wheel" ] ++ cfg.trusted-users;
          experimental-features = [
            "flakes"
            "nix-command"
          ];
        }
        // nixCaches;
      }
      (mkIf cfg.optimise {
        settings.auto-optimise-store = true;
        optimise.automatic = true;
        gc = {
          automatic = true;
          options = "-d";
        };
      })
    ];
  };
}
