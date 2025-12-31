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

        gc = lib.mkIf cfg.optimise {
          automatic = true;
          options = "-d";
        };

        optimise.automatic = cfg.optimise;
      };
    };
}
