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
    nix = {
      settings = {
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        trusted-users = [
          "@wheel"
        ]
        ++ cfg.trusted-users;
        auto-optimise-store = cfg.optimise;
      }
      // nixCaches;

      gc = mkIf cfg.optimise {
        automatic = true;
        options = "-d";
      };

      optimise.automatic = cfg.optimise;
    };
  };
}
