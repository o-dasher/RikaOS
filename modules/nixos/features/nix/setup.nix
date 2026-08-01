{
  lib,
  config,
  nixCaches,
  ...
}:
let
  cfg = config.features.nix;
in
{
  options.features.nix = {
    nixpkgs.enable = lib.mkEnableOption "nixpkgs";
    trusted-users = lib.mkOption {
      default = [ ];
      type = lib.types.listOf lib.types.str;
    };
    optimise = lib.mkEnableOption "optmise";
  };

  config = lib.mkIf cfg.enable {
    nix = lib.mkMerge [
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
      (lib.mkIf cfg.optimise {
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
