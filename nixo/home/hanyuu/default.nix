{
  inputs,
  pkgs,
  config,
  ...
}:
let
  nixGLIntel = inputs.nixGL.packages.${pkgs.system}.nixGLIntel;
in
{
  imports = [
    ../rika
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "74f9fb98f22581eaca2e3c518a0a3d6198249fb1490ab4a08f33ec47827e85db";
    })
  ];

  targets.genericLinux.enable = true;
  stylix.image = ../../../assets/Wallpapers/purplyu.jpg;

  # Fix opengl on nox nixos system. Keep an eye on https://github.com/nix-community/home-manager/issues/3968
  nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";
  home.packages = [ nixGLIntel ];

  stylix = {
    autoenable = false;

    # We opt-in because gtk theming is broken on gnome?
    targets = {
      tmux.enable = true;
      firefox.enable = true;
      fish.enable = true;
      lazygit.enable = true;
      wezterm.enable = true;
      sway.enable = true;
      waybar.enable = true;
      vim.enable = true;
    };
  };

  programs = {
    gnome-shell.enable = true;
    wezterm.package = (config.lib.nixGL.wrap pkgs.wezterm);
  };
}
