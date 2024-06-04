{ ... }:
{
  xdg.enable = true;
  catppuccin = {
    flavour = "mocha";
    accent = "pink";
  };
  gtk = {
    enable = true;
    catppuccin.enable = true;
  };
}
