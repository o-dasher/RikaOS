{
  pkgs,
  ...
}:
{
  profiles = {
    development = {
      enable = true;
      jetbrains.enable = true;
      zed.enable = true;
    };
    utilities.enable = true;
    gaming.enable = true;
    multimedia.enable = true;
    social.enable = true;
    browser = {
      enable = true;
      chromium.enable = true;
    };
    security.enable = true;
    study.enable = true;
  };

  features = {
    editors.jetbrains = {
      android-studio.enable = true;
      rider.enable = true;
      clion.enable = true;
    };
    utilities = {
      nemo.enable = true;
      trash.enable = true;
    };
    desktop = {
      hyprland.enable = true;
      theme.lucky-star.enable = true;
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
    vial

    # tools
    pwvucontrol
  ];

  programs = {
    home-manager.enable = true;
    imv.enable = true;
  };
}
