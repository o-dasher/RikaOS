{ pkgs, ... }:
{
  xdg.enable = true;
  catppuccin = {
    flavour = "mocha";
    accent = "pink";
  };
  gtk = {
    enable = true;
    catppuccin.enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };
  };
}
