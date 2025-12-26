{
  lib,
  config,
  nixCaches,
  ...
}:
{
  options.nixSetup = with lib; {
    enable = mkEnableOption "nixSetup";
    nixpkgs.enable = mkEnableOption "nixpkgs";
    trusted-users = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
    optimise = mkEnableOption "optmise" // {
      default = true;
    };
  };

  config =
    let
      cfg = config.nixSetup;
    in
    lib.mkIf (cfg.enable) {
      nixpkgs.config.allowUnfree = cfg.nixpkgs.enable;
      nix = {
        settings = {
          substituters = lib.mkForce nixCaches.substituters;
          trusted-public-keys = lib.mkForce nixCaches.trusted-public-keys;

          experimental-features = [
            "flakes"
            "nix-command"
          ];
          trusted-users = [
            "root"
            "@wheel"
          ]
          ++ cfg.trusted-users;
          auto-optimise-store = cfg.optimise;
        };

        gc = lib.mkIf cfg.optimise {
          automatic = true;
          options = "-d";
        };

        optimise.automatic = cfg.optimise;
      };
    };
}
