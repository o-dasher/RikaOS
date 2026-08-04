{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./opentabletdriver.nix ];

  options.features.gaming = {
    steam.enable = lib.mkEnableOption "Steam" // {
      default = true;
    };
    controllers.enable = lib.mkEnableOption "Xbox controllers" // {
      default = true;
    };
    suppressNotifications.enable = lib.mkEnableOption "suppress notifications during gaming" // {
      default = true;
    };
    enable = lib.mkEnableOption "gaming features";
  };

  config =
    let
      modCfg = config.features.gaming;
    in
    lib.mkIf modCfg.enable {
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
                lact = lib.getExe (config.services.lact.package or pkgs.lact);
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
          package = pkgs.gamescope.overrideAttrs (old: {
            # Blur fix: https://github.com/ValveSoftware/gamescope/issues/1622.
            NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or [ ]) ++ [ "-fno-fast-math" ];
            patches = (old.patches or [ ]) ++ [
              # Fix Gamescope not closing https://github.com/ValveSoftware/gamescope/pull/1908
              (pkgs.fetchpatch {
                url = "https://github.com/ValveSoftware/gamescope/commit/fa900b0694ffc8b835b91ef47a96ed90ac94823b.diff";
                hash = "sha256-eIHhgonP6YtSqvZx2B98PT1Ej4/o0pdU+4ubdiBgBM4=";
              })
            ];
          });
        };
        steam = lib.mkIf modCfg.steam.enable {
          enable = true;
          remotePlay.openFirewall = true;
          protontricks.enable = true;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
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

      hardware = lib.mkIf modCfg.controllers.enable {
        xpadneo.enable = true;
        xone.enable = true;
        uinput.enable = true;
        steam-hardware.enable = lib.mkIf modCfg.steam.enable true;
      };

      services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };
    };
}
