{ pkgs, ... }:
{
  theme.sakuyadaora.enable = true;

  profiles.gaming.enable = true;
  desktop.gnome.enable = true;

  terminal = {
    ghostty.enable = true;
  };

  xdg.portal.config.common.default = "*";

  home.packages = with pkgs; [
    mpv
    mission-center
    nautilus
  ];

  services.easyeffects.enable = true;
  programs = {
    home-manager.enable = true;
    librewolf.enable = true;
  };
}
