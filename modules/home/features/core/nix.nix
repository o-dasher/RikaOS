{
  lib,
  pkgs,
  config,
  osConfig ? null,
  nixCaches,
  ...
}:
let
  cfg = config.features.core.nix;
in
{
  options.features.core.nix = {
    enable = lib.mkEnableOption "nix" // {
      default = true;
    };
    nixpkgs.enable = lib.mkEnableOption "nixpkgs";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.features.core.enable && cfg.enable) {
      nix.settings = nixCaches;
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep 4 --keep-since 8d";
        };
        flake = "${config.features.filesystem.sharedFolders.configurationRoot}/private";
      };

      systemd.user.tmpfiles.rules = [
        # Recursively clean all stale files in ~/.cache older than 16 days
        "e %h/.cache - - - 16d -"
      ];

      # Automatically run user tmpfiles cleanup on a daily schedule
      systemd.user.services.tmpfiles-clean = {
        Unit.Description = "Cleanup stale user cache and temporary files";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.systemd}/bin/systemd-tmpfiles --user --clean";
        };
      };

      systemd.user.timers.tmpfiles-clean = {
        Unit.Description = "Scheduled cleanup of user cache and temporary files";
        Timer = {
          OnCalendar = "daily";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    })
    (lib.mkIf
      (
        config.features.core.enable
        && cfg.enable
        && cfg.nixpkgs.enable
        && (osConfig == null || !osConfig.home-manager.useGlobalPkgs)
      )
      {
        nixpkgs.config.allowUnfree = true;
      }
    )
  ];
}
