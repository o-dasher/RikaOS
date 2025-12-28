{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.desktop.fonts.enable = lib.mkEnableOption "common fonts" // {
    default = true;
  };

  config = lib.mkIf config.desktop.fonts.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # Coding / Terminal
      nerd-fonts.fira-mono
      nerd-fonts.jetbrains-mono

      # Essential for Web & Documents
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      dejavu_fonts
    ];
  };
}
