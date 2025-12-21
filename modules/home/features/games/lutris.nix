{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.games.lutris.enable = lib.mkEnableOption "lutris";

  config = lib.mkIf config.games.lutris.enable {
    home.packages = with pkgs; [
      wineWow64Packages.full
      winetricks
    ];

    programs.lutris.enable = true;
    programs.lutris.winePackages = [
      pkgs.wineWow64Packages.full
    ];
  };
}
