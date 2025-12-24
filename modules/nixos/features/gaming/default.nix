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
    nixpkgs.config.allowUnfree = true;

    hardware.opentabletdriver.enable = true;

    programs = {
      steam.enable = true;
      steam.remotePlay.openFirewall = true;
      gamemode.enable = true;
      gamescope.enable = true;
      gamescope.capSysNice = false;
    };

    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
  };
}
