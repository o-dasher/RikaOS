{ lib, config, options, ... }:
let
  cfg = config.theme;
  anyThemeEnabled = cfg.cirnold.enable || cfg.graduation.enable || cfg.sakuyadaora.enable;
in
{
  options.theme = with lib; {
    cirnold.enable = mkEnableOption "Cirnold theme";
    graduation.enable = mkEnableOption "Graduation theme";
    sakuyadaora.enable = mkEnableOption "Sakuyadaora theme";
  };

  imports = [
    ./cirnold.nix
    ./graduation.nix
    ./sakuyadaora.nix
  ];

  config = lib.mkIf anyThemeEnabled (lib.optionalAttrs (options ? stylix) {
    stylix = {
      enable = true;
      polarity = "dark";
      targets.nixcord.enable = false;
    };
  });
}
