{
  pkgs,
  ...
}:
{
  theme.cirnold.enable = true;
  editors.jetbrains.android-studio.enable = true;

  profiles = {
    development.enable = true;
    gaming.enable = true;
    multimedia.enable = true;
    social.enable = true;
    browser.enable = true;
    security.enable = true;
  };

  xdgSetup.enable = true;
  desktop.hyprland.enable = true;

  games = {
    minecraft.enable = true;
    osu.enable = true;
    ps4.enable = true;
  };

  home.packages = with pkgs; [
    # I love my keyboard.
    via
    vial

    # tools
    pwvucontrol

    # images
    nomacs
  ];

  programs = {
    home-manager.enable = true;
  };
}
