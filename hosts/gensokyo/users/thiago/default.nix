{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    bitwarden-desktop
    pwvucontrol
  ];

  programs = {
    home-manager.enable = true;
    imv.enable = true;
  };

  profiles = {
    browser.enable = true;
    study.enable = true;
    utilities.enable = true;
    development = {
      enable = true;
      zed.enable = true;
    };
  };

  features = {
    utilities = {
      nemo.enable = true;
      trash.enable = true;
    };
    desktop = {
      umbriel.enable = true;
      theme.cirnosunset.enable = true;
    };
    core.xdg = {
      enable = true;
      portal.enable = true;
    };
  };
}
