{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.features.gaming = {
    enable = lib.mkEnableOption "gaming features";
  };

  config = lib.mkIf config.features.gaming.enable {
    hardware.opentabletdriver.enable = true;

    programs = {
      gamemode.enable = true;
      gamescope = {
        enable = true;
        capSysNice = false;
      };
      steam = {
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
