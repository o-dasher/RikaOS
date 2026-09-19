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
  options.features.nix.optimise = lib.mkEnableOption "Automatic Nix store optimization." // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    nix = lib.mkMerge [
      {
        settings = {
          trusted-users = [ "@wheel" ];
          experimental-features = [
            "flakes"
            "nix-command"
          ];
          min-free = 8 * 1024 * 1024 * 1024; # 8 GiB
          max-free = 32 * 1024 * 1024 * 1024; # 32 GiB
        }
        // nixCaches;
        extraOptions = config.rika.utils.nixAccessTokens;
      }
      (lib.mkIf cfg.optimise {
        settings.auto-optimise-store = true;
        optimise = {
          automatic = true;
          dates = [ "weekly" ];
        };
      })
    ];

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 4 --keep-since 8d";
      };
    };
  };
}
