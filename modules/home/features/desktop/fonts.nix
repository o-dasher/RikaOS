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
    home.packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.fira-mono
      nerd-fonts.jetbrains-mono
    ];
  };
}
