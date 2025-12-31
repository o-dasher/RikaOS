{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.features.desktop.fonts.enable = lib.mkEnableOption "common fonts" // {
    default = true;
  };

  config = lib.mkIf config.features.desktop.fonts.enable {
    fonts.fontconfig.enable = true;

    stylix.fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sizes = {
        desktop = 9;
        applications = 12;
        popups = 12;
      };
    };

    home.packages = with pkgs; [
      # Coding / Terminal
      nerd-fonts.fira-mono

      # Essential for Web & Documents
      noto-fonts-cjk-sans
      liberation_ttf
      dejavu_fonts
    ];
  };
}
