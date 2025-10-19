{ lib, config, ... }:
{
  options.nixSetup = with lib; {
    enable = mkEnableOption "nixSetup";
    trusted-users = mkOption {
      default = [ ];
      type = types.listOf types.str;
    };
    optimise = mkEnableOption "optmise" // {
      default = true;
    };
  };

  config = lib.mkIf (config.nixSetup.enable) {
    nix = lib.mkMerge [
      {
        settings = lib.mkMerge [
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
