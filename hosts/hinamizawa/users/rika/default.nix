{
  pkgs,
  ...
}:
{
  theme.cirnold.enable = true;

  profiles = {
    development.enable = true;
    gaming.enable = true;
    multimedia.enable = true;
    social.enable = true;
    browser.enable = true;
    security.enable = true;
  };

  features = {
    desktop.hyprland.enable = true;
    editors.jetbrains.android-studio.enable = true;
    core.xdg = {
      enable = true;
      portal.enable = true;
    };
    gaming = {
      minecraft.enable = true;
      osu.enable = true;
      ps4.enable = true;
    };
  };

  home.packages = with pkgs; [
    # I love my keyboard.
    via
    vial

    # tools
    pwvucontrol
  ];

  programs = {
    home-manager.enable = true;
    imv.enable = true;
  };
}
