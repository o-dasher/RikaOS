{
  pkgs,
  config,
  nixGL,
  ...
}:
let
  nixGLIntel = nixGL.packages.${pkgs.system}.nixGLIntel;
in
{
  imports = [
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "74f9fb98f22581eaca2e3c518a0a3d6198249fb1490ab4a08f33ec47827e85db";
    })
  ];

  # Fix opengl on nox nixos system. Keep an eye on https://github.com/nix-community/home-manager/issues/3968
  nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";
  home.packages = [ nixGLIntel ];

  programs.wezterm.package = (config.lib.nixGL.wrap pkgs.wezterm);
}
