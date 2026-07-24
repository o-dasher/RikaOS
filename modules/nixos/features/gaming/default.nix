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
      boot = {
        kernelModules = [ "ntsync" ];
        # CS2 and Vulkan games allocate massive memory maps; default value causes stalls.
        kernel.sysctl."vm.max_map_count" = 2147483642;
      };

      programs = {
        gamemode = {
          enable = true;
          enableRenice = false;
          settings = {
            general = {
              renice = 0;
              ioprio = "off";
              softrealtime = "off";
              desiredgov = "performance";
              disable_splitlock = 1;
              inhibit_screensaver = 1;
            };
            custom = mkIf modCfg.suppressNotifications.enable {
              start = "${pkgs.mako}/bin/makoctl mode -s dnd";
              end = "${pkgs.mako}/bin/makoctl mode -s default";
            };
          };
        };

        gamescope = {
          enable = true;
          enableWsi = true;
          capSysNice = false;
        };

        steam = mkIf modCfg.steam.enable {
          enable = true;
          remotePlay.openFirewall = true;
          protontricks.enable = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
            nur.repos.forkprince.proton-cachyos-v3-bin
          ];
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

      hardware = mkIf modCfg.controllers.enable {
        xpadneo.enable = true;
        xone.enable = true;
        uinput.enable = true;
        steam-hardware.enable = mkIf modCfg.steam.enable true;
      };

      services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };
    };
}
