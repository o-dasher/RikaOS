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
      mkEnableOption "suppress notifications during gaming (requires wayle)"
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
        zswap.enable = true;
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
            custom =
              let
                wayle = lib.getExe pkgs.wayle;
                lact = lib.getExe config.services.lact.package or pkgs.lact;
                mkScript =
                  name: profile:
                  lib.getExe (
                    pkgs.writeShellScriptBin "gamemode-${name}" ''
                      ${lib.optionalString modCfg.suppressNotifications.enable "${wayle} notify dnd || true"}
                      ${lib.optionalString config.services.lact.enable "${lact} cli profile set \"${profile}\" || true"}
                    ''
                  );
              in
              {
                start = mkScript "start" "Gaming";
                end = mkScript "end" "Default";
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
