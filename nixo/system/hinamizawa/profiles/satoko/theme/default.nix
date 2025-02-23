{ pkgs, ... }:
{
  gtk = {
    enable = true;
  };
  stylix = {
    image = ../../../../../../assets/Wallpapers/sakuyadaora.jpg;
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    polarity = "dark";
    opacity =
      let
        v = 0.9;
      in
      {
        popups = v;
        terminal = v;
      };
  };
}
