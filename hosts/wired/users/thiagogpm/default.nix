{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../../../modules/home/theme/cirnold.nix
  ];

  targets.genericLinux.enable = true;

  development.enable = true;
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
