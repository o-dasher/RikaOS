{
  config,
  lib,
  pkgs,
  inputs,
  nixgl,
  ...
}:
{
  imports = [
    ../../../../home/modules/theme/graduation.nix
  ];

  targets.genericLinux.enable = true;

  xdgSetup.enable = true;
  nixSetup.enable = true;

  nixGL.packages = nixgl.packages;
  sharedFolders.configurationRoot = "~/Programming/RikaOS";

  development.enable = true;
  desktop.hyprland.enable = true;

  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;
  wayland.windowManager.hyprland.package = lib.mkForce (config.lib.nixGL.wrap pkgs.hyprland);

  home.packages = with pkgs; [
    inputs.zen-browser.packages.${system}.twilight
    inputs.agenix.packages.${system}.default
    spotify
  ];

  age.secrets.tavily-api-key.file = ../../../../secrets/tavily-api-key.age;

  home.sessionVariables = {
    TAVILY_API_KEY = ''
      $(${pkgs.coreutils}/bin/cat ${config.age.secrets.tavily-api-key.path})
    '';
  };

  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };
}
