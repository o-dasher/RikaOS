{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.theme;
  anyThemeEnabled = cfg.cirnold.enable || cfg.graduation.enable;
in
{
  options.theme = with lib; {
    cirnold.enable = mkEnableOption "Cirnold theme";
    graduation.enable = mkEnableOption "Graduation theme";
  };

  imports = [
    ./cirnold.nix
    ./graduation.nix
  ];

  config = lib.mkIf anyThemeEnabled (
    lib.optionalAttrs (options ? stylix) {
      stylix = {
        enable = true;
        polarity = "dark";
        targets.nixcord.enable = false;
        targets.zen-browser.profileNames = [ "default" ];
      };
    }
  );
}
