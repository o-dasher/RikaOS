{
  inputs,
  pkgs,
  ...
}:
{
  theme.cirnold.enable = true;

  profiles.development.enable = true;
  editors.jetbrains.android-studio.enable = true;
  profiles.gaming.enable = true;

  desktop = {
    hyprland.enable = true;
  };

  games = {
    minecraft.enable = true;
    osu.enable = true;
  };

  # Enable new suites
  suites = {
    multimedia.enable = true;
    productivity.enable = true;
    development.enable = true;
    social.enable = true;
    browser.enable = true;
  };

  home.packages = with pkgs; [
    # I love my keyboard.
    via
    vial

    # tools
    pavucontrol

    # images
    nomacs

    # files
    nautilus
  ];

  programs = {
    home-manager.enable = true;
  };

}
