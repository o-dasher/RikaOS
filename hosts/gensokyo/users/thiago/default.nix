{
  pkgs,
  ...
}:
{
  profiles = {
    browser.enable = true;
    development.enable = true;
    study.enable = true;
    utilities.enable = true;
    security.enable = true;
  };

  features = {
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
  };

  home.packages = with pkgs; [ pwvucontrol ];
  programs = {
    home-manager.enable = true;
    imv.enable = true;
  };
}
