{
  pkgs,
  ...
}:
{
  theme.lain-realism.enable = true;

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
    desktop.hyprland.enable = true;
    desktop.dolphin.enable = true;
    editors.jetbrains.android-studio.enable = true;
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
