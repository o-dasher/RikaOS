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

  config = lib.mkIf (config.nixSetup.enable) {
    nixpkgs.config = lib.mkIf config.nixSetup.nixpkgs.enable {
      allowUnfree = true;
    };
    nix = lib.mkMerge [
      {
        settings = lib.mkMerge [
          nixCaches
          {
            experimental-features = [
              "flakes"
              "nix-command"
            ];
            trusted-users = [
              "root"
            ]
            ++ config.nixSetup.trusted-users;
          }
          (lib.mkIf config.nixSetup.optimise {
            auto-optimise-store = true;
          })
        ];
      }
      (lib.mkIf config.nixSetup.optimise {
        gc = {
          automatic = true;
          options = "-d";
        };
        optimise.automatic = true;
      })
    ];
  };
}
