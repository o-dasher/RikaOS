{
  pkgs,
  inputs,
  ...
}:
{
  theme.cirnold.enable = true;

  targets.genericLinux.enable = true;

  profiles.development.enable = true;
  desktop.hyprland.enable = true;

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${system}.twilight
    spotify
  ];

  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };
}
