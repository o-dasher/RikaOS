{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.games = with lib; {
    enable = mkEnableOption "games";
    osu.enable = mkEnableOption "osu-lazer";
    minecraft.enable = mkEnableOption "minecraft";
    steam.enable = mkEnableOption "steam";
  };

  config = lib.mkIf config.games.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          mangohud
          goverlay
          (heroic.override {
            extraPkgs = pkgs: [
              pkgs.gamescope
            ];
          })
          (lib.mkIf config.games.osu.enable osu-lazer-bin)
          (lib.mkIf config.games.minecraft.enable (
            prismlauncher.override {
              jdks = [
                temurin-bin-21
              ];
            }
          ))
        ];
      }
      (lib.mkIf config.games.steam.enable {
        home.file."Games/Steam/steamapps/common".source =
          config.lib.file.mkOutOfStoreSymlink "/steam-games/SteamLibrary/steamapps/common";

        home.file."Games/Steam/steamapps/downloading".source =
          config.lib.file.mkOutOfStoreSymlink "/steam-games/SteamLibrary/steamapps/downloading";

        home.file."Games/Steam/steamapps/shadercache".source =
          config.lib.file.mkOutOfStoreSymlink "/steam-games/SteamLibrary/steamapps/shadercache";
      })
    ]
  );
}
