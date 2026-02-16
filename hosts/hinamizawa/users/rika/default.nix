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
    editors.jetbrains.android-studio.enable = true;
    utilities = {
      nemo.enable = true;
      trash.enable = true;
    };
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
      gamescope = {
        enable = true;
        args = [
          "-w 1920"
          "-h 1080"
          "-r 240"
          "--fullscreen"
          "--force-grab-cursor"
          "--expose-wayland"
          "--rt"
        ];
      };
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
