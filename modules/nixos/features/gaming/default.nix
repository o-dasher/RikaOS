{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  imports = [
    ./opentabletdriver.nix
  ];

  options.features.gaming = {
    steam.enable = mkEnableOption "Steam" // {
      default = true;
    };
    controllers.enable = mkEnableOption "Xbox controllers" // {
      default = true;
    };
    otd.enable = mkEnableOption "OpenTabletDriver" // {
      default = true;
    };
    suppressNotifications.enable =
      mkEnableOption "suppress notifications during gaming (requires mako)"
      // {
        default = true;
      };
    enable = mkEnableOption "gaming features";
  };

  config =
    let
      modCfg = config.features.gaming;
    in
    mkIf modCfg.enable {
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
            custom = mkIf modCfg.suppressNotifications.enable {
              start = "${pkgs.mako}/bin/makoctl mode -s dnd";
              end = "${pkgs.mako}/bin/makoctl mode -s default";
            };
          };
        };

        gamescope = {
          enable = true;
          capSysNice = false;
        };

        steam = mkIf (modCfg.steam.enable) {
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

      hardware = mkIf (modCfg.controllers.enable) {
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
