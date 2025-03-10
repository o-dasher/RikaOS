{
  lib,
  config,
  pkgs,
  pkgs-bleeding,
  utils,
  inputs,
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

        home.packages =
          [ pkgs-bleeding.hydralauncher ]
          ++ (with pkgs; [
            mangohud
            goverlay
            (heroic.override {
              extraPkgs = pkgs: [
                pkgs.gamescope
              ];
            })
            (lib.mkIf config.games.osu.enable
              inputs.nix-gaming.packages.${pkgs.hostPlatform.system}.osu-lazer-bin
            )
            (lib.mkIf config.games.minecraft.enable (
              prismlauncher.override {
                jdks = [
                  temurin-bin-21
                ];
              }
            ))
          ]);
      }
      (lib.mkIf config.games.steam.enable {
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
      })
    ]
  );
}
