{
  lib,
  config,
  nixCaches,
  ...
}:
let
  modCfg = config.features;
  cfg = modCfg.nix;
in
with lib;
{
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
