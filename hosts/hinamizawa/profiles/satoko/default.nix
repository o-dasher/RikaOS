{ pkgs, ... }:
{
  imports = [
    ./stylix.nix
  ];

  games.enable = true;
  desktop.gnome.enable = true;
  terminal = {
    enable = true;
    ghostty.enable = true;
  };

  nixSetup.enable = true;
  xdgSetup.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
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
