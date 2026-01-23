{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./opentabletdriver.nix
  ];

  options.features.gaming = {
    enable = lib.mkEnableOption "gaming features";
    steam.enable = lib.mkEnableOption "Steam" // {
      default = true;
    };
    controllers.enable = lib.mkEnableOption "Xbox controllers" // {
      default = true;
    };
    otd.enable = lib.mkEnableOption "OpenTabletDriver" // {
      default = true;
    };
    suppressNotifications.enable = lib.mkEnableOption "suppress notifications during gaming (requires mako)";
  };

  config =
    let
      cfg = config.features.gaming;
    in
    lib.mkIf cfg.enable {
      boot.kernelModules = [ "ntsync" ];

      # Enables HDR and fixes stuttering games in wayland.
      environment.systemPackages = [ pkgs.gamescope-wsi ];

      programs = {
        gamemode = {
          enable = true;
          settings = {
            general = {
              renice = 0;
              ioprio = "off";
              desiredgov = "off";
            };
            custom = lib.mkIf cfg.suppressNotifications.enable {
              start = "${pkgs.mako}/bin/makoctl mode -a do-not-disturb";
              end = "${pkgs.mako}/bin/makoctl mode -r do-not-disturb";
            };
          };
        };

        gamescope = {
          enable = true;
          capSysNice = false;
        };

        steam = lib.mkIf (cfg.steam.enable) {
          enable = true;
          remotePlay.openFirewall = true;
          protontricks.enable = true;
          gamescopeSession = {
            enable = true;
            steamArgs = [
              "-console"
              "-tenfoot"
              "-pipewire-dmabuf"
            ];
          };
        };
      };

      hardware = lib.mkIf (cfg.controllers.enable) {
        xpadneo.enable = true;
        xone.enable = true;
      };

      services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };
    };
}
