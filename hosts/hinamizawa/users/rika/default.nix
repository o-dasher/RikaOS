{
  pkgs,
  ...
}:
{

  profiles = {
    development.enable = true;
    utilities.enable = true;
    gaming.enable = true;
    multimedia.enable = true;
    social.enable = true;
    browser.enable = true;
    security.enable = true;
  };

  features = {
    utilities.nemo.enable = true;
    editors.jetbrains.android-studio.enable = true;
    desktop = {
      hyprland.enable = true;
      theme.cirnosunset.enable = true;
    };
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
