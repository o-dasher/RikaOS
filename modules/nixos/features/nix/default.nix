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
    optimise = lib.mkEnableOption "Automatic Nix store optimization." // {
      default = true;
    };

    buildLimits = {
      enable = lib.mkEnableOption "Low-priority Nix daemon scheduling and build parallelism limits.";

      maxJobs = lib.mkOption {
        type = lib.types.nullOr (lib.types.either (lib.types.enum [ "auto" ]) lib.types.ints.positive);
        default = null;
        description = "Maximum number of concurrent Nix build jobs (nix.settings.max-jobs).";
      };

      cores = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.unsigned;
        default = null;
        description = "Maximum number of CPU cores per Nix build job (nix.settings.cores).";
      };
    };
  };

  config = {
    nix = lib.mkMerge [
      {
        extraOptions = config.rika.utils.nixAccessTokens;
        settings = {
          min-free = 8 * 1024 * 1024 * 1024; # 8 GiB
          max-free = 32 * 1024 * 1024 * 1024; # 32 GiB
          trusted-users = [ "@wheel" ];
          experimental-features = [
            "flakes"
            "nix-command"
          ];
        }
        // nixCaches;
      }
      (lib.mkIf cfg.optimise {
        settings.auto-optimise-store = true;
        optimise = {
          automatic = true;
          dates = [ "weekly" ];
        };
      })
      (lib.mkIf cfg.buildLimits.enable {
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";
        settings =
          lib.optionalAttrs (cfg.buildLimits.maxJobs != null) {
            max-jobs = cfg.buildLimits.maxJobs;
          }
          // lib.optionalAttrs (cfg.buildLimits.cores != null) {
            cores = cfg.buildLimits.cores;
          };
      })
    ];

    systemd.services.nix-daemon.serviceConfig = lib.mkIf cfg.buildLimits.enable {
      CPUWeight = 10;
      IOWeight = 10;
      OOMScoreAdjust = 500;
    };

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 3";
      };
    };
  };
}
