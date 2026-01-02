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
    otd.enable = lib.mkEnableOption "OpenTabletDriver" // {
      default = true;
    };
  };

  config =
    let
      cfg = config.features.gaming;
    in
    lib.mkIf cfg.enable {
      programs = {
        gamemode.enable = true;
        gamescope = {
          enable = true;
          capSysNice = false;
          package = config.rika.pkgs.gamescope;
        };

        steam = lib.mkIf (cfg.steam.enable) {
          enable = true;
          remotePlay.openFirewall = true;
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

      services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };
    };
}
