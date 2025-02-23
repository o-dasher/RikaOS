{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.games = with lib; {
    enable = mkEnableOption "games";
    minecraft = {
      enable = mkEnableOption "minecraft";
      username = mkOption {
        default = "Daishes";
        type = types.str;
      };
    };
  };

  config = lib.mkIf config.games.enable {
    home.packages = with pkgs; [
      heroic
      (lib.mkIf config.games.minecraft.enable prismlauncher)
    ];
  };
}
