{
  pkgs,
  config,
  inputs,
  ...
}:
let
  nixGLIntel = inputs.nixGL.packages.${pkgs.system}.nixGLIntel;
in
{
  imports = [
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "0g5yk54766vrmxz26l3j9qnkjifjis3z2izgpsfnczhw243dmxz9";
    })
  ];

  # Fix opengl on nox nixos system. Keep an eye on https://github.com/nix-community/home-manager/issues/3968
  nixGL.prefix = "${nixGLIntel}/bin/nixGLIntel";
  home.packages = [ nixGLIntel ];

  programs.alacritty.package = (config.lib.nixGL.wrap pkgs.alacritty);
}
