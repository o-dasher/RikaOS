{ lib, config, utils, ... }:
{
  options.games.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf config.games.steam.enable {
    home.file =
      let
        symLinkSteam = utils.selectiveSymLink "/steam-games/SteamLibrary/steamapps" "Games/Steam/steamapps";
      in
      lib.mkMerge [
        (symLinkSteam [
          "common"
          "downloading"
          "shadercache"
        ] { recursive = true; })
      ];
  };
}
