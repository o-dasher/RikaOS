{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (import ../common/config.nix) username state;
in
{
  imports = [
    ./rika
    ./satoko
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  # Even though open source is cool and all I still use some not libre software.
  nixpkgs.config.allowUnfree = true;

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = state;
  };

  xdg.enable = true;

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
      options = "--delete-older-than 1d";
    };
  };
}
